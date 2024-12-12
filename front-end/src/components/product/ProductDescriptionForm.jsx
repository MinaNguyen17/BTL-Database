import React from 'react';

const ProductDescriptionForm = ({ productData, setProductData }) => {
  return (
    <>
    <h2 className="text-xl font-semibold mb-6">About product</h2>
    <div className="mt-6">
      {/* <label className="block text-gray-700 font-medium mb-2">About Product</label> */}
      <textarea 
        placeholder="Bodycare is healthy"
        value={productData.about}
        onChange={(e) => setProductData(prev => ({...prev, about: e.target.value}))}
        className="w-full h-56 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent h-32 resize-none"
      />
    </div>
    </>);
};

export default ProductDescriptionForm;
