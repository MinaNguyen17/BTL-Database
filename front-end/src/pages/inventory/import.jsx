import React, { useState, useEffect } from "react";
import axiosInstance from '@/utils/axiosInstance';
import "./import.css"; // Import file CSS

const Import = () => {
  const [quantity, setQuantity] = useState('');
  const [importPrice, setImportPrice] = useState('');
  const [shippingFee, setShippingFee] = useState('');
  const [selectedSupplier, setSelectedSupplier] = useState(null);
  const [selectedItem, setSelectedItem] = useState(null);

  const handleQuantityChange = (e) => setQuantity(e.target.value);
  const handleImportPriceChange = (e) => setImportPrice(e.target.value);
  const handleShippingFee = (e) => setShippingFee(e.target.value);

  const handleCreate = () => {
    const data = {
      itemID: selectedItem.ITEM_ID,
      supplierID: selectedSupplier.SUPPLIER_ID,
      importQuantity: quantity,
      importPrice: parseFloat(importPrice),
      totalFee: parseFloat(quantity) * parseFloat(importPrice) + parseFloat(shippingFee || 0)
    };

    axiosInstance.post("/importBill/create", data)
      .then(response => {
        console.log('Import created successfully:', response.data);
      })
      .catch(error => {
        console.error('Error creating import:', error);
      });
  };

  return (
    <div className="ImportContainer">
      <Supplier selectedSupplier={selectedSupplier} setSelectedSupplier={setSelectedSupplier} />
      <ItemList selectedItem={selectedItem} setSelectedItem={setSelectedItem} />
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
        <span>Import Price</span>
        <input 
          type="number"
          value={importPrice}
          onChange={handleImportPriceChange}
          placeholder="Enter import price"
        />
      </div>

      <div className="input-field">
        <span>Shipping Fee</span>
        <input 
          type="number"
          value={shippingFee}
          onChange={handleShippingFee}
          placeholder="Enter shipping fee"
        />
      </div>

      <div className="total-fee">
        <span>Total Fee: </span>
        <span>
          {quantity && importPrice ? (quantity * importPrice + parseFloat(shippingFee || 0)) : 0}
        </span>
      </div>

      <button 
        className="create-btn" 
        onClick={handleCreate}
        disabled={!selectedSupplier || !selectedItem || !quantity || !importPrice}
      >
        Create
      </button>
    </div>
  );
};

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
      {/* Hiển thị thông tin nhà cung cấp đã chọn */}
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

const ItemList = ({selectedItem, setSelectedItem }) => {
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
          {selectedItem ? selectedItem.ITEM_ID : "Choose Supplier"}
        </div>
        {isDropdownOpen && (
          <ul className="dropdown-list">
            {items.map(item => (
            <li 
                key={item.id || item.ITEM_ID} // Đảm bảo key là duy nhất
                onClick={() => handleSelectItem(item)}
            >
                {item.name || item.ITEM_ID} 
            </li>
            ))}

          </ul>
        )}
      </div>
      <div className="SelectContent">
      {/* Hiển thị thông tin nhà cung cấp đã chọn */}
      {selectedItem && (
  <div className="selected-supplier">
    <h3>Selected Item:</h3>
    <p><strong>ID:</strong> {selectedItem.ITEM_ID}</p> {/* Displaying ITEM_ID */}
    <p><strong>Selling Price:</strong> {selectedItem.SELLING_PRICE}</p> {/* Displaying SELLING_PRICE */}
    <p><strong>Size:</strong> {selectedItem.SIZE}</p> {/* Displaying SIZE */}
    <p><strong>Color:</strong> {selectedItem.COLOR}</p> {/* Displaying COLOR */}
    <p><strong>Stock:</strong> {selectedItem.STOCK}</p> {/* Displaying STOCK */}
  </div>
)}

      </div>
    </div>
  );
};

export default Import;
