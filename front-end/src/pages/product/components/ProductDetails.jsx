import React from 'react';
import { RiArchiveLine, RiExchangeLine } from 'react-icons/ri';

export default function ProductDetails({
  stock,
  sales,
  price,
  productName,
  productId,
  description,
  attributes
}) {
  return (
    <div className="w-1/2">
      <div className="flex justify-between mb-8">
      
      {/* Product Price */}
        <div className="flex items-center gap-12">
          <div>
            <div className="flex items-center gap-2 text-gray-600 mb-1">
              <RiArchiveLine />
              <span>Stock</span>
            </div>
            <div className="text-4xl inline-block font-semibold">{stock}</div>
            <div className="text-sm inline-block text-gray-400">/Pack</div>
          </div>
          <div>
            <div className="flex items-center gap-2 text-gray-600 mb-1">
              <RiExchangeLine />
              <span>Sales</span>
            </div>
            <div className="text-4xl inline-block font-semibold">{sales}</div>
            <div className="text-sm inline-block text-gray-400">/Pack</div>
          </div>
        </div>

        <div className="text-4xl font-semibold text-[#8B9B7E]">${price.toFixed(2)}</div>
      </div>


      <h2 className="text-2xl font-semibold mb-1">{productName}</h2>
      <div className="text-gray-500 mb-6">{productId}</div>

      <div className="mb-8">
        <h3 className="font-medium mb-2">About Product</h3>
        <p className="text-gray-600">{description}</p>
      </div>
      

      {/* Product Attributes */}
      <div className="space-y-6">
        {attributes.map((attr) => (
          <div key={attr.label}>
            <div className="font-medium mb-2">{attr.label}</div>
            <div className="flex flex-wrap gap-2">
              {attr.options.map((option) => (
                <span 
                  key={option}
                  className="px-4 py-2 rounded-full border hover:bg-gray-50 cursor-pointer"
                >
                  {option}
                </span>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
