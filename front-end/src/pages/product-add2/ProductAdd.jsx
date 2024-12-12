import { useState } from "react";
import { motion } from "framer-motion";
import ProductImageUpload from "../../components/product/ProductImageUpload";
import ProductDescriptionForm from "../../components/product/ProductDescriptionForm";

const ProductAdd = () => {
  const [productData, setProductData] = useState({
    about: '',
    images: []
  });

  const [versions, setVersions] = useState([
    { id: "P909", name: "T-Shirt", size: "M", color: "White" },
    { id: "P919", name: "T-Shirt", size: "L", color: "White" },
    { id: "P929", name: "T-Shirt", size: "M", color: "Black" },
    { id: "P939", name: "T-Shirt", size: "L", color: "Black" },
    { id: "P949", name: "T-Shirt", size: "M", color: "Green" },
    { id: "P959", name: "T-Shirt", size: "L", color: "Green" },
  ]);

  const handleImageUpload = (images) => {
    setProductData(prev => ({
      ...prev,
      images: [...(prev.images || []), ...images]
    }));
  };

  const handleDelete = (id) => {
    setVersions(versions.filter((version) => version.id !== id));
  };

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Product</h1>
      <div className="flex gap-6">
        <div className="w-[35%] flex flex-col gap-5">
          <div className="bg-white rounded-lg shadow-xl p-5">
            <ProductImageUpload onImageUpload={handleImageUpload} />
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
            <h2 className="text-xl font-semibold">Product Version</h2>
            <div className="flex items-center gap-2">
              <div className="relative">
                <input
                  type="text"
                  placeholder="Search Anything..."
                  className="w-[250px] h-10 pl-4 pr-10 rounded-lg border border-gray-200 focus:outline-none focus:border-gray-300"
                />
                <svg className="w-5 h-5 absolute right-3 top-2.5 text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </div>
            </div>
          </div>

          <div className="bg-gray-50 space-y-3  rounded-lg">
            <div className="flex justify-around p-4 text-sm text-gray-600">
              <div>ID</div>
              <div>Name</div>
              <div>Size</div>
              <div>Color</div>
              <div></div>
            </div>
            
            {versions.map((version) => (
              <motion.div
                key={version.id}
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className=" bg-[#EEEEFF] flex justify-around p-4 hover:bg-orange-100 transition-colors items-center text-sm"
              >
                <div>{version.id}</div>
                <div>{version.name}</div>
                <div>{version.size}</div>
                <div className="relative left-4">{version.color}</div>
                <div className="flex  justify-end">
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
            <button className="px-6 py-2 w-1/3 rounded-lg border-solid border-black border-2  hover:bg-gray-200 transition-colors">
              Cancel
            </button>
            <button className="px-6 py-2 w-1/3 rounded-lg bg-[#8C9581] text-white hover:bg-[#7A8270] transition-colors">
              Save
            </button>
          </div>

        </div>
      </div>
    </div>
  );
};

export default ProductAdd;