import React from 'react';
import { motion } from 'framer-motion';
import { RiStarFill, RiGlobalLine } from 'react-icons/ri';

export default function ProductImageGallery({ 
  images, 
  selectedImage, 
  setSelectedImage
}) {
  const mainImage = images[selectedImage];
  return (
    <div className="w-1/2">
      <motion.div 
        className="aspect-square rounded-lg overflow-hidden mb-4 bg-gray-100"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
      >
        <img 
          src={mainImage} 
          alt="Product" 
          className="w-full h-full object-cover"
        />
      </motion.div>
      
      <div className="grid grid-cols-3 gap-4 mb-8">
        {images.map((img, index) => (
          <div 
            key={index}
            className={`aspect-square rounded-lg overflow-hidden cursor-pointer bg-gray-100 ${
              selectedImage === index ? 'ring-2 ring-[#8B9B7E]' : ''
            }`}
            onClick={() => setSelectedImage(index)}
          >
            <img src={img} alt={`Product ${index + 1}`} className="w-full h-full object-cover" />
          </div>
        ))}
      </div>

      {/* Ratings Section */}
      <div className="flex gap-12">
        {/* Ratings */}
        <div className="flex items-center gap-4">
          <div className="bg-[#8B9B7E] text-white text-3xl font-medium h-14 w-20 rounded-lg flex items-center justify-center">
            4.9
          </div>
          <div className="flex flex-col">
            <div className="flex text-yellow-400">
              {[...Array(5)].map((_, i) => (
                <RiStarFill key={i} />
              ))}
            </div>
            <div className="text-sm text-gray-500">Based on of 05 ratings</div>
          </div>
        </div>

        {/* Global Review */}
        <div>
          <div className="flex items-center gap-2 mb-4">
            <RiGlobalLine className="text-xl" />
            <span className="font-medium">Global Review</span>
          </div>
          {/* Review Example */}
          <div className="space-y-2">
            <div className="flex justify-between items-center">
              <div className="font-medium">Lucia</div>
              <div className="flex text-yellow-400">
                {[...Array(5)].map((_, i) => (
                  <RiStarFill key={i} className="text-sm" />
                ))}
              </div>
            </div>
            <p className="text-gray-500 text-sm">
              Lorem ipsum dolor sit amet consectetur. Lacus id rutrum retra neque sodales.
            </p>
            <div className="flex gap-2">
              {[1, 2, 3].map((i) => (
                <div key={i} className="w-8 h-8 rounded-full bg-gray-200" />
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
