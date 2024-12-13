import React, { useState, useEffect } from "react";
import axiosInstance from '@/utils/axiosInstance';
import "./return.css"; // Import file CSS

const Return = () => {
  const [quantity, setQuantity] = useState('');
  const [price, setPrice] = useState('');
  const [refundFee, setRefundFee] = useState('');
  const [reason, setReason] = useState('');
  const [selectedSupplier, setSelectedSupplier] = useState(null);
  const [selectedItem, setSelectedItem] = useState(null);

  const handleQuantityChange = (e) => setQuantity(e.target.value);
  const handlePriceChange = (e) => setPrice(e.target.value);
  const handleRefundFeeChange = (e) => setRefundFee(e.target.value);
  const handleReasonChange = (e) => setReason(e.target.value);

  const handleCreate = () => {
    const data = {
        reason: reason,
        returnFee: parseFloat(quantity) * parseFloat(price),
      itemID: selectedItem.ITEM_ID,
      supplierID: selectedSupplier.SUPPLIER_ID,
      returnQuantity: quantity,
      returnPrice: parseFloat(price)
    };

    axiosInstance.post("/returnBill/create", data)
      .then(response => {
        alert('Return created successfully:', response.data);
      })
      .catch(error => {
        console.error('Error creating return:', error);
      });
  };

  return (
    <div className="ReturnContainer">
      <div className="ContainerRow">
      <Supplier selectedSupplier={selectedSupplier} setSelectedSupplier={setSelectedSupplier} />
      <ItemList selectedItem={selectedItem} setSelectedItem={setSelectedItem} />
      </div>
      <div className="ContainerRow">
      <div className="input-field">
        <span>QUANTITY</span>
        <input 
          type="number"
          value={quantity}
          onChange={handleQuantityChange}
          placeholder="Enter quantity"
        />
      </div>

      <div className="input-field">
        <span>Price</span>
        <input 
          type="number"
          value={price}
          onChange={handlePriceChange}
          placeholder="Enter price per unit"
        />
      </div>

      

      <div className="input-field">
        <span>Reason</span>
        <textarea 
          value={reason}
          onChange={handleReasonChange}
          placeholder="Enter reason for return"
        />
      </div>
      </div>

      <div className="total-refund">
        <span>Total Refund: </span>
        <span>
          {quantity && price ? (quantity * price - parseFloat(refundFee || 0)) : 0}
        </span>
      </div>

      <button 
        className="create-btn" 
        onClick={handleCreate}
        disabled={!selectedSupplier || !selectedItem || !quantity || !price || !reason}
      >
        Create
      </button>
    </div>
  );
};
export default Return;

const Supplier = ({ selectedSupplier, setSelectedSupplier }) => {
  const [suppliers, setSuppliers] = useState([]);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  useEffect(() => {
    axiosInstance.get("/supplier/all")
      .then(response => setSuppliers(response.data || []))
      .catch(error => {
        console.error("Error fetching suppliers:", error);
        setSuppliers([]);
      });
  }, []);

  const handleSelectSupplier = (supplier) => {
    setSelectedSupplier(supplier);
    setIsDropdownOpen(false);
  };

  return (
    <div className="supplier-container">
      <strong>Supplier</strong>
      <div className="dropdown-container">
        <div 
          className="dropdown-btn" 
          onClick={() => setIsDropdownOpen(!isDropdownOpen)}
        >
          {selectedSupplier ? selectedSupplier.SUPPLIER_NAME : "Choose Supplier"}
        </div>
        {isDropdownOpen && (
          <ul className="dropdown-list">
            {suppliers.map(supplier => (
              <li 
                key={supplier.SUPPLIER_ID} 
                onClick={() => handleSelectSupplier(supplier)}
              >
                {supplier.SUPPLIER_NAME}
              </li>
            ))}
          </ul>
        )}
      </div>
      <div className="SelectContent">
      {selectedSupplier && (
        <div className="selected-supplier">
          <h3>Selected Supplier:</h3>
          <p><strong>Name:</strong> {selectedSupplier.SUPPLIER_NAME}</p>
          <p><strong>Email:</strong> {selectedSupplier.SUPPLIER_EMAIL}</p>
          <p><strong>Phone:</strong> {selectedSupplier.SUPPLIER_PHONE}</p>
          <p><strong>Address:</strong> {selectedSupplier.ADDRESS}</p>
        </div>
      )}
      </div>
    </div>
  );
};

const ItemList = ({ selectedItem, setSelectedItem }) => {
  const [items, setItems] = useState([]);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  useEffect(() => {
    axiosInstance.get("/item/all")
      .then(response => setItems(response.data || []))
      .catch(error => {
        console.error("Error fetching items:", error);
        setItems([]);
      });
  }, []);

  const handleSelectItem = (item) => {
    setSelectedItem(item);
    setIsDropdownOpen(false);
  };

  return (
    <div className="item-container">
      <strong>Item</strong>
      <div className="dropdown-container">
        <div 
          className="dropdown-btn" 
          onClick={() => setIsDropdownOpen(!isDropdownOpen)}
        >
          {selectedItem ? selectedItem.ITEM_ID : "Choose Item"}
        </div>
        {isDropdownOpen && (
          <ul className="dropdown-list">
            {items.map(item => (
              <li 
                key={item.id || item.ITEM_ID}
                onClick={() => handleSelectItem(item)}
              >
                {item.name || item.ITEM_ID}
              </li>
            ))}
          </ul>
        )}
      </div>
      <div className="SelectContent">
      {selectedItem && (
        <div className="selected-item">
          <h3>Selected Item:</h3>
          <p><strong>ID:</strong> {selectedItem.ITEM_ID}</p>
          <p><strong>Selling Price:</strong> {selectedItem.SELLING_PRICE}</p>
          <p><strong>Size:</strong> {selectedItem.SIZE}</p>
          <p><strong>Color:</strong> {selectedItem.COLOR}</p>
          <p><strong>Stock:</strong> {selectedItem.STOCK}</p>
        </div>
      )}
      </div>
    </div>
  );
};


