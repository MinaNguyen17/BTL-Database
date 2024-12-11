import { useState } from 'react';
import { productImages, productDetails } from './data/productData';
import ProductDetails from './components/ProductDetails';
import ProductImageGallery from './components/ProductImageGallery';

export default function ProductPage() {
  const [selectedImage, setSelectedImage] = useState(0);
   
  return (
    <div className="flex min-h-screen bg-white">
  
      {/* Main Content */}
      <div className="flex-1">
        {/* Header */}
        <h1 className="text-2xl font-semibold pl-8 pt-4">Product Details</h1>

        {/* Product Content */}
        <div className="p-8 max-w-7xl mx-auto">
          <div className="flex gap-8">
            <ProductImageGallery 
              images={productImages} 
              selectedImage={selectedImage} 
              setSelectedImage={setSelectedImage}
            />
            <ProductDetails 
              stock={productDetails.stock}
              sales={productDetails.sales}
              price={productDetails.price}
              productName={productDetails.productName}
              productId={productDetails.productId}
              description={productDetails.description}
              attributes={productDetails.attributes}
            />
          </div>
        </div>
      </div>
    </div>
  );
}
