import React, { useState } from 'react';

const ProductVariantSelector = ({ productData, setProductData }) => {
  const [newColor, setNewColor] = useState('');
  const [newSize, setNewSize] = useState('');
  const [newTag, setNewTag] = useState('');

  const handleAddColor = () => {
    if (newColor.trim() && !productData.colors.includes(newColor.trim())) {
      setProductData(prev => ({
        ...prev,
        colors: [...prev.colors, newColor.trim()]
      }));
      setNewColor('');
    }
  };

  const handleRemoveColor = (colorToRemove) => {
    setProductData(prev => ({
      ...prev,
      colors: prev.colors.filter(color => color !== colorToRemove)
    }));
  };

  const handleAddSize = () => {
    if (newSize.trim() && !productData.sizes.includes(newSize.trim())) {
      setProductData(prev => ({
        ...prev,
        sizes: [...prev.sizes, newSize.trim()]
      }));
      setNewSize('');
    }
  };

  const handleRemoveSize = (sizeToRemove) => {
    setProductData(prev => ({
      ...prev,
      sizes: prev.sizes.filter(size => size !== sizeToRemove)
    }));
  };

  const handleAddTag = () => {
    if (newTag.trim() && !productData.styleTags.includes(newTag.trim())) {
      setProductData(prev => ({
        ...prev,
        styleTags: [...prev.styleTags, newTag.trim()]
      }));
      setNewTag('');
    }
  };

  const handleRemoveTag = (tagToRemove) => {
    setProductData(prev => ({
      ...prev,
      styleTags: prev.styleTags.filter(tag => tag !== tagToRemove)
    }));
  };

  return (
    <>
      <div className="grid grid-cols-2 gap-4 mb-6">
        <div>
          <label className="block text-gray-700 font-medium mb-2">Color</label>
          <div className="flex gap-2">
            <input 
              type="text" 
              placeholder="Add Color"
              value={newColor}
              onChange={(e) => setNewColor(e.target.value)}
              className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <button 
              type="button" 
              onClick={handleAddColor}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
            >
              +
            </button>
          </div>
          <div className="flex flex-wrap gap-2 mt-2">
            {productData.colors.map((color, index) => (
              <span 
                key={index} 
                className="group relative px-3 py-2 border-solid border-[1px] border-black bg-[#D4E7C4] text-[#353A32] rounded-xl text-sm"
              >
                {color}
                <button 
                  onClick={() => handleRemoveColor(color)}
                  className="absolute -top-2 -right-2 w-5 h-5 bg-red-500 text-white rounded-full text-xs flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                >
                  ×
                </button>
              </span>
            ))}
          </div>
        </div>
        <div>
          <label className="block text-gray-700 font-medium mb-2">Size</label>
          <div className="flex gap-2">
            <input 
              type="text" 
              placeholder="Add Size"
              value={newSize}
              onChange={(e) => setNewSize(e.target.value)}
              className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <button 
              type="button" 
              onClick={handleAddSize}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
            >
              +
            </button>
          </div>
          <div className="flex flex-wrap gap-2 mt-2">
            {productData.sizes.map((size, index) => (
              <span 
                key={index} 
                className="group relative px-3 py-1 bg-[#F6E9D3] text-[#353A32] rounded-xl border-[1px] border-black border-solid text-sm"
              >
                {size}
                <button 
                  onClick={() => handleRemoveSize(size)}
                  className="absolute -top-2 -right-2 w-5 h-5 bg-red-500 text-white rounded-full text-xs flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                >
                  ×
                </button>
              </span>
            ))}
          </div>
        </div>
      </div>

      <div className="mb-6">
        <label className="block text-gray-700 font-medium mb-2">Style Tag</label>
        <div className="flex gap-2">
          <input 
            type="text" 
            placeholder="Add Tag"
            value={newTag}
            onChange={(e) => setNewTag(e.target.value)}
            className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
          <button 
            type="button" 
            onClick={handleAddTag}
            className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
          >
            +
          </button>
        </div>
        <div className="flex flex-wrap gap-2 mt-2">
          {productData.styleTags.map((tag, index) => (
            <span 
              key={index} 
              className="group relative px-3 py-1 bg-purple-100 text-[#353A32] rounded-full text-sm"
            >
              {tag}
              <button 
                onClick={() => handleRemoveTag(tag)}
                className="absolute -top-2 -right-2 w-5 h-5 bg-red-500 text-white rounded-full text-xs flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-200"
              >
                ×
              </button>
            </span>
          ))}
        </div>
      </div>
    </>
  );
};

export default ProductVariantSelector;
