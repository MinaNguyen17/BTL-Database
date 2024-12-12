import React, { useState, useRef } from 'react';

const ProductImageUpload = ({ onImageUpload }) => {
  const [selectedImages, setSelectedImages] = useState([]);
  const fileInputRef = useRef(null);

  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    const imageFiles = files.filter(file => file.type.startsWith('image/'));
    
    const newImages = imageFiles.map(file => ({
      file,
      preview: URL.createObjectURL(file)
    }));

    setSelectedImages(prevImages => [...prevImages, ...newImages]);
    
    // Call parent component's upload handler if provided
    if (onImageUpload) {
      onImageUpload(imageFiles);
    }
  };

  const handleImageRemove = (indexToRemove) => {
    setSelectedImages(prevImages => 
      prevImages.filter((_, index) => index !== indexToRemove)
    );
  };

  const triggerFileInput = () => {
    fileInputRef.current.click();
  };

  return (<>
    <h2 className="text-xl font-semibold mb-4">Add Image</h2>
    <div className="flex flex-col items-center gap-4">
      <input 
        type="file" 
        ref={fileInputRef}
        onChange={handleImageChange}
        multiple 
        accept="image/*" 
        className="hidden"
      />
      
      <div 
        className="w-full h-64 border-2 border-dashed border-blue-500 rounded-lg flex justify-center items-center cursor-pointer hover:bg-blue-50 hover:border-blue-600 transition-all duration-200"
        onClick={triggerFileInput}
      >
        <span className="text-blue-500 font-semibold">+ Add Image</span>
      </div>
      
      {selectedImages.length > 0 && (
        <div className="flex flex-wrap gap-3 justify-center">
          {selectedImages.map((image, index) => (
            <div key={index} className="relative w-36 h-36 rounded-lg overflow-hidden shadow-md">
              <img 
                src={image.preview} 
                alt={`Product preview ${index + 1}`} 
                className="w-full h-full object-cover"
              />
              <button 
                className="absolute top-1 right-1 w-6 h-6 bg-red-500 bg-opacity-70 hover:bg-opacity-90 text-white rounded-full flex items-center justify-center transition-colors duration-200"
                onClick={(e) => {
                  e.stopPropagation();
                  handleImageRemove(index);
                }}
              >
                ×
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
    </>);
};

export default ProductImageUpload;
