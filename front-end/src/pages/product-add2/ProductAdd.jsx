import { useState, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import ProductImageUpload from "../../components/product/ProductImageUpload";
import ProductDescriptionForm from "../../components/product/ProductDescriptionForm";
import ProductService from "../../services/productService";
import ItemService from "../../services/itemService";

const ProductAdd = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [productData, setProductData] = useState({
    about: '',
    images: [],
    price: '' // Explicitly add price to initial state
  });

  const [versions, setVersions] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    if (location.state && location.state.productData) {
      const stateProductData = location.state.productData;
      
      // Log the entire product data for debugging
      console.log('Product Data in ProductAdd2:', stateProductData);

      setProductData(prevData => ({
        ...prevData,
        ...stateProductData
      }));

      // ALWAYS regenerate versions based on current colors and sizes
      const { colors = [], sizes = [] } = stateProductData;
      const generatedVersions = colors.flatMap((color, colorIndex) => 
        sizes.map((size, sizeIndex) => {
          // Create a stable, unique ID based on color and size
          const id = `V_${color}_${size}`.replace(/\s+/g, '_');

          // Try to find an existing price for this combination
          const existingVersion = (stateProductData.versions || []).find(
            v => v.color === color && v.size === size
          );

          // Determine the price to use
          let versionPrice = '';
          if (existingVersion && existingVersion.sellingPrice) {
            versionPrice = existingVersion.sellingPrice;
          } else if (stateProductData.price) {
            versionPrice = stateProductData.price;
          }

          console.log(`Version for ${color} ${size}:`, {
            id,
            color,
            size,
            price: versionPrice
          });

          return {
            id, 
            name: stateProductData.name || 'Product', 
            size, 
            color,
            sellingPrice: versionPrice,
            stock: 0
          };
        })
      );

      // Replace any existing versions with newly generated ones
      setVersions(generatedVersions);
    }
  }, [location.state]);

  const handleImageUpload = (images) => {
    setProductData(prev => ({
      ...prev,
      images: [...(prev.images || []), ...images]
    }));
  };

  const handleDelete = (id) => {
    console.log('Attempting to delete version with id:', id);
    console.log('Current versions:', versions);
    
    const updatedVersions = versions.filter((version) => version.id !== id);
    console.log('Updated versions:', updatedVersions);
    
    setVersions(updatedVersions);
  };

  const handlePriceChange = (id, price) => {
    setVersions(prev => 
      prev.map(version => 
        version.id === id ? { ...version, sellingPrice: price } : version
      )
    );
  };

  const handleSave = async () => {
    try {
      setIsLoading(true);

      // Validate versions have prices
      const invalidVersions = versions.filter(v => !v.sellingPrice);
      if (invalidVersions.length > 0) {
        alert('Please set selling price for all product versions');
        setIsLoading(false);
        return;
      }

      // Prepare product data for creation
      const productPayload = {
        name: productData.name,
        brand: productData.brand,
        style_tag: productData.styleTags[0] || '',
        season: productData.season,
        category: productData.category,
        description: productData.about
      };

      // Create base product first
      const createdProduct = await ProductService.createProduct(productPayload);
      console.log('Created product:', createdProduct.product.PRODUCT_ID);
      // Create individual items
      const updatedVersions = versions.map(version => ({
        sellingPrice: version.sellingPrice,
        size: version.size,
        color: version.color,
        productID: createdProduct.product.PRODUCT_ID.toString(),
      }));
      // setVersions(updatedVersions);
      console.log('Versions to create:', updatedVersions);

      const itemCreationPromises = updatedVersions.map(version => 
        ItemService.createItem(version)
      );

      // Wait for all item creations
      await Promise.all(itemCreationPromises);

      // Update the product data with the latest changes before navigating
      const updatedProductData = {
        ...productData,
        versions: versions
      };

      alert('Product and its versions created successfully!');
      navigate('/productview', { 
        state: { 
          updatedProductData // Optional: pass updated data if needed in next view
        } 
      });
    } catch (error) {
      console.error('Error creating product:', error);
      alert(`Failed to create product: ${error.message}`);
    } finally {
      setIsLoading(false);
    }
  };

  const handleCancel = () => {
    // Preserve ALL current data when canceling
    navigate('/productadd1', { 
      state: { 
        productData: {
          ...productData,
          versions: versions // Include the current versions
        }
      } 
    });
  };

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Product Versions</h1>
      <div className="flex gap-6">
        <div className="w-[35%] flex flex-col gap-5">
          <div className="bg-white rounded-lg shadow-xl p-5">
            <ProductImageUpload 
              initialImages={productData.images || []}
              onImageUpload={handleImageUpload} 
            />
          </div>

          <div className="bg-white rounded-lg shadow-xl p-5">
            <ProductDescriptionForm 
              productData={productData} 
              setProductData={setProductData} 
            />
          </div>
        </div>
        
        <div className="flex-1 bg-white rounded-lg shadow-2xl border-t-4 shadow-inner-xl shadow-gray-300 p-5">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-semibold">Product Versions</h2>
            <div className="text-sm text-gray-500">
              Total Versions: {versions.length}
            </div>
          </div>

          <div className="bg-gray-50 space-y-3 rounded-lg">
            <div className="flex justify-around p-4 text-sm text-gray-600">
              <div className="w-1/5">Name</div>
              <div className="w-1/5">Size</div>
              <div className="w-1/5">Color</div>
              <div className="w-1/5">Selling Price</div>
              {/* <div className="w-1/6">Stock</div> */}
              <div className="w-1/5">Action</div>
            </div>
            
            {versions.map((version) => (
              <motion.div
                key={version.id}
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="bg-[#EEEEFF] flex justify-around p-4 hover:bg-orange-100 transition-colors items-center text-sm"
              >
                <div className="w-1/5">{version.name}</div>
                <div className="w-1/5">{version.size}</div>
                <div className="w-1/5">{version.color}</div>
                <div className="w-1/5">
                  <input 
                    type="number" 
                    placeholder="Price"
                    value={version.sellingPrice}
                    onChange={(e) => handlePriceChange(version.id, e.target.value)}
                    className="w-full px-2 py-1 border rounded"
                  />
                </div>
                {/* <div className="w-1/5">
                  <input 
                    type="number" 
                    value={version.stock}
                    onChange={(e) => {
                      setVersions(prev => 
                        prev.map(v => 
                          v.id === version.id ? { ...v, stock: parseInt(e.target.value) } : v
                        )
                      );
                    }}
                    className="w-full px-2 py-1 border rounded"
                  />
                </div> */}
                <div className="w-1/5 flex justify-center">
                  <button
                    onClick={() => handleDelete(version.id)}
                    className="p-1 hover:bg-gray-200 rounded"
                  >
                    <svg className="w-5 h-5 text-gray-500" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
              </motion.div>
            ))}
          </div>

          <div className="flex justify-center gap-12 mt-12">
            <button 
              onClick={handleCancel}
              className="px-6 py-2 w-1/3 rounded-lg border-solid border-black border-2 hover:bg-gray-200 transition-colors"
              disabled={isLoading}
            >
              Cancel
            </button>
            <button 
              onClick={handleSave}
              className="px-6 py-2 w-1/3 rounded-lg bg-[#8C9581] text-white hover:bg-[#7A8270] transition-colors"
              disabled={isLoading}
            >
              {isLoading ? 'Saving...' : 'Save'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProductAdd;