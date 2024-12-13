import React, { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from "@/components/ui/select";
import productService from "@/services/productService";
import { toast } from "sonner";
import { 
  Package, 
  Tag, 
  Shirt, 
  Sun, 
  BookmarkIcon, 
  FileTextIcon, 
  SaveIcon, 
  XIcon 
} from 'lucide-react';

const ProductEdit = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [product, setProduct] = useState({
    PRODUCT_ID: '',
    PRODUCT_NAME: '',
    BRAND: '',
    STYLE_TAG: '',
    SEASON: '',
    CATEGORY: '',
    DESCRIPTION: ''
  });

  useEffect(() => {
    // If product is passed through navigation state, pre-fill the form
    if (location.state && location.state.product) {
      setProduct(location.state.product);
    }
  }, [location.state]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setProduct(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSelectChange = (name, value) => {
    setProduct(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await productService.updateProduct(product.PRODUCT_ID, {
        name: product.PRODUCT_NAME,
        brand: product.BRAND,
        style_tag: product.STYLE_TAG,
        season: product.SEASON,
        category: product.CATEGORY,
        description: product.DESCRIPTION
      });
      toast.success('Sản phẩm đã được cập nhật thành công');
      navigate('/product-view-employee');
    } catch (error) {
      toast.error('Lỗi khi cập nhật sản phẩm: ' + error.message);
    }
  };

  const handleCancel = () => {
    navigate(-1);
  };

  return (
    <div className="min-h-screen bg-gray-100 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto bg-white shadow-xl rounded-xl overflow-hidden">
        <div className="p-6 bg-green-50 border-b border-gray-200">
          <div className="flex justify-between items-center">
            <h1 className="text-3xl font-bold text-green-800 flex items-center">
              <Package className="mr-3 text-green-600" size={32} />
              Chỉnh sửa sản phẩm
            </h1>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="p-8 space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <FormInput
              label="Mã sản phẩm"
              name="PRODUCT_ID"
              value={product.PRODUCT_ID}
              onChange={handleInputChange}
              icon={<Tag className="text-blue-500" />}
              disabled
            />
            
            <FormInput
              label="Tên sản phẩm"
              name="PRODUCT_NAME"
              value={product.PRODUCT_NAME}
              onChange={handleInputChange}
              icon={<Shirt className="text-green-500" />}
              required
            />
            
            <FormInput
              label="Thương hiệu"
              name="BRAND"
              value={product.BRAND}
              onChange={handleInputChange}
              icon={<BookmarkIcon className="text-purple-500" />}
              required
            />
            
            <FormInput
              label="Nhãn kiểu"
              name="STYLE_TAG"
              value={product.STYLE_TAG}
              onChange={handleInputChange}
              icon={<Tag className="text-yellow-500" />}
            />
            
            <FormSelect
              label="Mùa"
              name="SEASON"
              value={product.SEASON}
              onValueChange={(value) => handleSelectChange('SEASON', value)}
              icon={<Sun className="text-orange-500" />}
              options={[
                { value: 'Spring', label: 'Xuân' },
                { value: 'Summer', label: 'Hè' },
                { value: 'Autumn', label: 'Thu' },
                { value: 'Winter', label: 'Đông' }
              ]}
            />
            
            <FormSelect
              label="Danh mục"
              name="CATEGORY"
              value={product.CATEGORY}
              onValueChange={(value) => handleSelectChange('CATEGORY', value)}
              icon={<BookmarkIcon className="text-red-500" />}
              options={[
                { value: 'Clothing', label: 'Quần áo' },
                { value: 'Accessories', label: 'Phụ kiện' },
                { value: 'Shoes', label: 'Giày' }
              ]}
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center">
              <FileTextIcon className="mr-2 text-gray-500" />
              Mô tả
            </label>
            <textarea 
              name="DESCRIPTION"
              value={product.DESCRIPTION}
              onChange={handleInputChange}
              className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
              rows="4"
              placeholder="Nhập mô tả sản phẩm"
            />
          </div>

          <div className="flex justify-end space-x-4 pt-6">
            <Button 
              type="button" 
              variant="outline" 
              onClick={handleCancel}
              className="text-gray-600 hover:bg-gray-100"
            >
              <XIcon className="mr-2" /> Hủy
            </Button>
            <Button 
              type="submit" 
              className="bg-green-600 text-white hover:bg-green-700"
            >
              <SaveIcon className="mr-2" /> Lưu thay đổi
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
};

// Reusable input component
const FormInput = ({ 
  label, 
  name, 
  value, 
  onChange, 
  icon, 
  disabled = false, 
  required = false 
}) => (
  <div>
    <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center">
      {icon}
      <span className="ml-2">{label}</span>
    </label>
    <Input
      name={name}
      value={value}
      onChange={onChange}
      disabled={disabled}
      required={required}
      className={`
        w-full 
        ${disabled ? 'bg-gray-100 cursor-not-allowed' : ''}
        focus:ring-2 focus:ring-green-500 focus:border-transparent
      `}
      placeholder={`Nhập ${label.toLowerCase()}`}
    />
  </div>
);

// Reusable select component
const FormSelect = ({ 
  label, 
  name, 
  value, 
  onValueChange, 
  icon, 
  options 
}) => (
  <div>
    <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center">
      {icon}
      <span className="ml-2">{label}</span>
    </label>
    <Select 
      value={value}
      onValueChange={onValueChange}
    >
      <SelectTrigger className="w-full focus:ring-2 focus:ring-green-500 focus:border-transparent">
        <SelectValue placeholder={`Chọn ${label.toLowerCase()}`} />
      </SelectTrigger>
      <SelectContent>
        {options.map((option) => (
          <SelectItem key={option.value} value={option.value}>
            {option.label}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  </div>
);

export default ProductEdit;
