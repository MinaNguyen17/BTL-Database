import { useState } from 'react';
import { motion } from 'framer-motion';
import thumb1 from './assets/images/thumb1.png';
import thumb2 from './assets/images/thumb2.png';
import thumb3 from './assets/images/thumb3.png';
import mainProduct from './assets/images/productmain.png'

export default function ProductDetail() {
  const [selectedImage, setSelectedImage] = useState(0);
  
  const images = [
    thumb1,
    thumb2,
    thumb3,
  ];

  return (
    <div className="flex min-h-screen bg-white">
      {/* Sidebar */}
      <div className="w-64 border-r p-6 space-y-4">
        <div className="text-xl font-semibold mb-8">dpopstore</div>
        
        <nav className="space-y-4">
          <div className="text-sm text-gray-500">General</div>
          <div className="space-y-3">
            {['Dashboard', 'Order Summary', 'Transaction', 'Inventory', 'Product'].map((item) => (
              <div 
                key={item} 
                className={`p-2 rounded cursor-pointer ${
                  item === 'Product' ? 'bg-[#8B9B7E] text-white' : 'hover:bg-gray-100'
                }`}
              >
                {item}
              </div>
            ))}
          </div>
        </nav>
      </div>

      {/* Main Content */}
      <div className="flex-1 p-8">
        <div className="max-w-6xl mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-8">
            <h1 className="text-2xl font-semibold">Product</h1>
            <div className="flex items-center space-x-4">
              <input 
                type="search" 
                placeholder="Search Anything..."
                className="px-4 py-2 border rounded-lg"
              />
            </div>
          </div>

          {/* Product Content */}
          <div className="flex gap-8">
            {/* Product Images */}
            <div className="w-1/2">
              <motion.div 
                className="aspect-square rounded-lg overflow-hidden mb-4"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
              >
                <img 
                  src={mainProduct} 
                  alt="Product" 
                  className="w-full h-full object-cover"
                />
              </motion.div>
              
              <div className="grid grid-cols-3 gap-4">
                {images.map((img, index) => (
                  <div 
                    key={index}
                    className={`aspect-square rounded-lg overflow-hidden cursor-pointer ${
                      selectedImage === index ? 'ring-2 ring-[#8B9B7E]' : ''
                    }`}
                    // onClick={() => setSelectedImage(index)}
                  >
                    <img src={img} alt={`Product ${index + 1}`} className="w-full h-full object-cover" />
                  </div>
                ))}
              </div>
            </div>

            {/* Product Details */}
            <div className="w-1/2">
              <div className="flex justify-between mb-8">
                <div className="flex items-center gap-8">
                  <div>
                    <div className="text-gray-600 mb-1">Stock</div>
                    <div className="text-3xl font-semibold">245</div>
                    <div className="text-sm text-gray-400">/Pack</div>
                  </div>
                  <div>
                    <div className="text-gray-600 mb-1">Sales</div>
                    <div className="text-3xl font-semibold">12.345</div>
                    <div className="text-sm text-gray-400">/Pack</div>
                  </div>
                </div>
                <div className="text-3xl font-semibold text-[#8B9B7E]">$80.00</div>
              </div>

              <h2 className="text-2xl font-semibold mb-1">Name Produk</h2>
              <div className="text-gray-500 mb-4">ID Product</div>

              <div className="mb-6">
                <div className="font-medium mb-2">About Product</div>
                <p className="text-gray-600">
                  Lorem ipsum dolor sit amet consectetur. Eget gravida nisl faucibus egestas. Fames pharetra elit etiam scelerisque ultricies a orci sed mus.
                </p>
              </div>

              {/* Product Attributes */}
              <div className="space-y-4">
                {[/* eslint-disable indent */
                  { label: 'Brand', options: ['Sweet Flower'] },
                  { label: 'Season', options: ['2024 -Winter'] },
                  { label: 'Color', options: ['Sweet Flower', 'Deep Forest', 'Ocean', 'Vanilla blue'] },
                  { label: 'Size', options: ['Travel Size', '60ml'] },
                  { label: 'Tag', options: ['Sweet Flower', 'Deep Forest', 'Ocean', 'Vanilla blue'] },
                ].map((attr) => (
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
          </div>
        </div>
      </div>
    </div>
  );
}