import React, { useState, useEffect } from 'react';
import ProductImageUpload from '../../components/product/ProductImageUpload';
import ProductBasicInfo from './ProductBasicInfo';
import ProductVariantSelector from './ProductVariantSelector';
import ProductDescriptionForm from '../../components/product/ProductDescriptionForm';
import { useLocation, useNavigate } from 'react-router-dom';

const ProductAdd = () => {
  const location = useLocation();
  const navigate = useNavigate();

  // Initialize state with default or location state values
  const [productData, setProductData] = useState({
    name: '',
    brand: '',
    category: '',
    season: '',
    styleTags: [],
    colors: [],
    sizes: [],
    about: '',
    images: [],
    price: '', // Ensure price is in initial state
    versions: []
  });

  // Use effect to populate data from navigation state
  useEffect(() => {
    if (location.state && location.state.productData) {
      // Merge existing state with new state, prioritizing new data
      setProductData(prevData => ({
        ...prevData,
        ...location.state.productData
      }));
    }
  }, [location.state]);

  const handleImageUpload = (images) => {
    setProductData(prev => ({
      ...prev,
      images: [...prev.images, ...images]
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    navigate('/productadd2', { state: { productData } });
  };

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Product</h1>
      <form onSubmit={handleSubmit} className="flex gap-6">
        <div className="w-[35%] flex flex-col gap-5">
          <div className="bg-white rounded-lg shadow-xl min-h-1/2 p-5">
            <ProductImageUpload onImageUpload={handleImageUpload} />
          </div>
          
          <div className="bg-white rounded-lg shadow-xl min-h-1/2 p-5">
            <ProductDescriptionForm 
              productData={productData} 
              setProductData={setProductData} 
            />
          </div>
        </div>
        
        <div className="flex-1 bg-white rounded-lg shadow-2xl border-t-4 shadow-inner-xl shadow-gray-300 p-5">
          <ProductBasicInfo 
            productData={productData} 
            setProductData={setProductData} 
          />
          
          <ProductVariantSelector 
            productData={productData} 
            setProductData={setProductData} 
          />
          
          <button 
            type="submit" 
            className="w-1/3 mx-auto mt-8 block px-6 py-3 bg-blue-500 text-white font-semibold rounded-full shadow-md hover:bg-blue-600 transform hover:-translate-y-0.5 transition-all duration-200 uppercase tracking-wide"
          >
            Submit Product
          </button>
        </div>
      </form>
    </div>
  );
};

export default ProductAdd;
