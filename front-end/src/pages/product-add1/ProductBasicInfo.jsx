import React from 'react';

const ProductBasicInfo = ({ productData, setProductData }) => {
  return (
    <>
      <div className="mb-6">
        <label className="block text-gray-700 font-medium mb-2">Name Product</label>
        <input 
          type="text" 
          placeholder="T-shirt"
          value={productData.name}
          onChange={(e) => setProductData(prev => ({...prev, name: e.target.value}))}
          className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        />
      </div>

      <div className="grid grid-cols-2 gap-4 mb-6">
        <div>
          <label className="block text-gray-700 font-medium mb-2">Price</label>
          <input 
            type="text" 
            placeholder="$23.00"
            value={productData.price}
            onChange={(e) => setProductData(prev => ({...prev, price: e.target.value}))}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
        <div>
          <label className="block text-gray-700 font-medium mb-2">Brand</label>
          <input 
            type="text" 
            placeholder="Dior"
            value={productData.brand}
            onChange={(e) => setProductData(prev => ({...prev, brand: e.target.value}))}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4 mb-6">
        <div>
          <label className="block text-gray-700 font-medium mb-2">Season</label>
          <input 
            type="text" 
            placeholder="Season-Year"
            value={productData.season}
            onChange={(e) => setProductData(prev => ({...prev, season: e.target.value}))}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
        <div>
          <label className="block text-gray-700 font-medium mb-2">Category</label>
          <select 
            value={productData.category}
            onChange={(e) => setProductData(prev => ({...prev, category: e.target.value}))}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          >
            <option value="">Choose Category</option>
            <option value="clothes">Clothes</option>
            <option value="accessories">Accessories</option>
          </select>
        </div>
      </div>
    </>
  );
};

export default ProductBasicInfo;
