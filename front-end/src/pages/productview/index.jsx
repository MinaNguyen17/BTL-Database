import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Button } from "@/components/ui/button";
import { 
  Package, 
  Tag, 
  Shirt, 
  Sun, 
  BookmarkIcon, 
  FileTextIcon, 
  ArrowLeftIcon 
} from 'lucide-react';
import productService from "@/services/productService";
import { toast } from "sonner";

const ProductView = () => {
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { productId } = useParams();
  const navigate = useNavigate();

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        const fetchedProduct = await productService.getProductById(productId);
        setProduct(fetchedProduct);
        setLoading(false);
      } catch (err) {
        setError(err);
        setLoading(false);
        toast.error('Không thể tải thông tin sản phẩm');
      }
    };

    fetchProduct();
  }, [productId]);

  const handleEdit = () => {
    navigate('/productedit', { state: { product } });
  };

  const handleBack = () => {
    navigate(-1);
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-screen bg-gray-100">
        <div className="animate-spin rounded-full h-32 w-32 border-t-2 border-b-2 border-green-500"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex justify-center items-center min-h-screen bg-red-50">
        <div className="text-center p-8 bg-white rounded-xl shadow-lg">
          <h2 className="text-2xl font-bold text-red-600 mb-4">Lỗi</h2>
          <p className="text-gray-700">Không thể tải thông tin sản phẩm</p>
          <Button onClick={handleBack} className="mt-4" variant="outline">
            Quay lại
          </Button>
        </div>
      </div>
    );
  }

  if (!product) {
    return (
      <div className="flex justify-center items-center min-h-screen bg-gray-100">
        <div className="text-center p-8 bg-white rounded-xl shadow-lg">
          <h2 className="text-2xl font-bold text-gray-600 mb-4">Không tìm thấy sản phẩm</h2>
          <Button onClick={handleBack} variant="outline">
            Quay lại
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto bg-white shadow-xl rounded-xl overflow-hidden">
        <div className="p-6 bg-green-50 border-b border-gray-200">
          <div className="flex justify-between items-center">
            <h1 className="text-3xl font-bold text-green-800 flex items-center">
              <Package className="mr-3 text-green-600" size={32} />
              Chi tiết sản phẩm
            </h1>
            <Button 
              onClick={handleBack} 
              variant="outline" 
              className="text-gray-600 hover:bg-gray-100"
            >
              <ArrowLeftIcon className="mr-2" size={20} /> Quay lại
            </Button>
          </div>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 p-8">
          <div className="space-y-4">
            <DetailItem 
              icon={<Tag className="text-blue-500" />} 
              label="Mã sản phẩm" 
              value={product.PRODUCT_ID} 
            />
            <DetailItem 
              icon={<Shirt className="text-green-500" />} 
              label="Tên sản phẩm" 
              value={product.PRODUCT_NAME} 
            />
            <DetailItem 
              icon={<BookmarkIcon className="text-purple-500" />} 
              label="Thương hiệu" 
              value={product.BRAND} 
            />
          </div>
          
          <div className="space-y-4">
            <DetailItem 
              icon={<Tag className="text-yellow-500" />} 
              label="Nhãn kiểu" 
              value={product.STYLE_TAG} 
            />
            <DetailItem 
              icon={<Sun className="text-orange-500" />} 
              label="Mùa" 
              value={product.SEASON} 
            />
            <DetailItem 
              icon={<BookmarkIcon className="text-red-500" />} 
              label="Danh mục" 
              value={product.CATEGORY} 
            />
          </div>
          
          <div className="col-span-full">
            <DetailItem 
              icon={<FileTextIcon className="text-gray-500" />} 
              label="Mô tả" 
              value={product.DESCRIPTION} 
              fullWidth 
            />
          </div>
        </div>
        
        <div className="p-6 bg-gray-50 text-right">
          <Button 
            onClick={handleEdit} 
            className="bg-green-600 text-white hover:bg-green-700"
          >
            Chỉnh sửa sản phẩm
          </Button>
        </div>
      </div>
    </div>
  );
};

// Reusable detail item component
const DetailItem = ({ icon, label, value, fullWidth = false }) => (
  <div className={`bg-white border rounded-lg p-4 shadow-sm ${fullWidth ? 'col-span-full' : ''}`}>
    <div className="flex items-center mb-2">
      {icon}
      <span className="ml-3 text-sm font-medium text-gray-500">{label}</span>
    </div>
    <p className="text-lg font-semibold text-gray-800">{value || 'Không có thông tin'}</p>
  </div>
);

export default ProductView;
