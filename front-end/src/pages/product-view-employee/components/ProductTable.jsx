import React from 'react';
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { useNavigate } from 'react-router-dom';
import { 
  EyeIcon, 
  EditIcon, 
  MoreHorizontalIcon 
} from 'lucide-react';
import { 
  DropdownMenu, 
  DropdownMenuContent, 
  DropdownMenuItem, 
  DropdownMenuTrigger 
} from "@/components/ui/dropdown-menu";
import { toast } from "sonner";
import productService from "@/services/productService";

const ProductTableSkeleton = ({ itemsPerPage }) => {
  return (
    <>
      {[...Array(itemsPerPage)].map((_, index) => (
        <tr 
          key={index} 
          className={`${index % 2 === 0 ? 'bg-[#FAFCF3]' : 'bg-white'}`}
        >
          {[...Array(8)].map((_, colIndex) => (
            <td key={colIndex} className="p-4">
              <Skeleton className="h-4 w-full" />
            </td>
          ))}
        </tr>
      ))}
    </>
  );
};

const ProductTable = ({ 
  products, 
  onToggleStatus, 
  currentPage, 
  itemsPerPage, 
  totalItems, 
  onPageChange,
  isLoading,
  onRefreshProducts 
}) => {
  const navigate = useNavigate();

  // Calculate total pages
  const totalPages = Math.ceil(totalItems / itemsPerPage);

  // Generate page numbers to display
  const getPageNumbers = () => {
    const pageNumbers = [];
    const maxPagesToShow = 5;
    
    if (totalPages <= maxPagesToShow) {
      for (let i = 1; i <= totalPages; i++) {
        pageNumbers.push(i);
      }
    } else {
      pageNumbers.push(1);
      
      if (currentPage > 3) {
        pageNumbers.push('...');
      }
      
      const startPage = Math.max(2, currentPage - 1);
      const endPage = Math.min(totalPages - 1, currentPage + 1);
      
      for (let i = startPage; i <= endPage; i++) {
        if (!pageNumbers.includes(i)) {
          pageNumbers.push(i);
        }
      }
      
      if (currentPage < totalPages - 2) {
        pageNumbers.push('...');
      }
      
      pageNumbers.push(totalPages);
    }
    
    return pageNumbers;
  };

  const handleViewProduct = (productId) => {
    navigate(`/productview/${productId}`);
  };

  const handleEditProduct = (product) => {
    navigate('/productedit', { state: { product } });
  };

  const handleDeleteProduct = async (productId) => {
    try {
      await productService.deleteProduct(productId);
      toast.success('Sản phẩm đã được xóa thành công');
      // Refresh products list if onRefreshProducts is provided
      if (onRefreshProducts) {
        onRefreshProducts();
      }
    } catch (error) {
      toast.error('Không thể xóa sản phẩm: ' + error.message);
    }
  };

  return (
    <div className="bg-white rounded-lg">
      <table className="w-full">
        <thead>
          <tr className="border-b">
            <th className="p-4 text-left">Product ID</th>
            <th className="p-4 text-left">Product Name</th>
            <th className="p-4 text-left">Brand</th>
            <th className="p-4 text-left">Style Tag</th>
            <th className="p-4 text-left">Season</th>
            <th className="p-4 text-left">Category</th>
            <th className="p-4 text-left">Description</th>
            <th className="p-4 text-left">Actions</th>
          </tr>
        </thead>
        <tbody>
          {isLoading ? (
            <ProductTableSkeleton itemsPerPage={itemsPerPage} />
          ) : (
            products.map((product, index) => (
              <tr 
                key={index} 
                className={`
                  ${index % 2 === 0 ? 'bg-[#FAFCF3]' : 'bg-white'}
                  ${product.isEditing ? 'pointer-events-none opacity-50' : ''}
                  hover:bg-gray-50 transition-colors duration-200
                `}
              >
                <td className="p-4">{product.PRODUCT_ID}</td>
                <td className="p-4">{product.PRODUCT_NAME}</td>
                <td className="p-4">{product.BRAND}</td>
                <td className="p-4">{product.STYLE_TAG}</td>
                <td className="p-4">{product.SEASON}</td>
                <td className="p-4">{product.CATEGORY}</td>
                <td className="p-4">{product.DESCRIPTION}</td>
                <td className="p-4">
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button 
                        variant="ghost" 
                        size="sm" 
                        className="hover:bg-gray-100"
                      >
                        <MoreHorizontalIcon className="h-4 w-4" />
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end" className="w-[160px]">
                      <DropdownMenuItem 
                        onSelect={() => handleViewProduct(product.PRODUCT_ID)}
                        className="cursor-pointer"
                      >
                        <EyeIcon className="mr-2 h-4 w-4" />
                        Xem chi tiết
                      </DropdownMenuItem>
                      <DropdownMenuItem 
                        onSelect={() => handleEditProduct(product)}
                        className="cursor-pointer"
                      >
                        <EditIcon className="mr-2 h-4 w-4" />
                        Chỉnh sửa
                      </DropdownMenuItem>
                      {/* <DropdownMenuItem 
                        onSelect={() => handleDeleteProduct(product.PRODUCT_ID)}
                        className="cursor-pointer text-red-600 focus:bg-red-50 focus:text-red-700"
                      >
                        <EditIcon className="mr-2 h-4 w-4 text-red-500" />
                        Xóa
                      </DropdownMenuItem> */}
                    </DropdownMenuContent>
                  </DropdownMenu>
                </td>
              </tr>
            ))
          )}
        </tbody>
      </table>
      <div className="flex justify-between items-center p-4 border-t">
        <span className="text-sm text-gray-500">
          {!isLoading && (
            <>
              Showing {(currentPage - 1) * itemsPerPage + 1} to{' '}
              {Math.min(currentPage * itemsPerPage, totalItems)} of {totalItems} entries
            </>
          )}
        </span>
        <div className="flex gap-2">
          <Button 
            variant={currentPage === 1 ? 'outline' : 'ghost'} 
            size="sm"
            className={`
              ${currentPage === 1 ? '' : 'hover:bg-[#8B9B7E]/10'}
              ${currentPage === 1 ? 'hover:bg-primary/90' : ''}
            `}
            onClick={() => onPageChange(currentPage - 1)}
            disabled={currentPage === 1}
          >
            ←
          </Button>
          {getPageNumbers().map((page, index) => (
            <Button 
              key={index}
              variant={page === currentPage ? 'outline' : 'ghost'} 
              size="sm"
              className={`
                ${page === currentPage ? '' : 'hover:bg-[#8B9B7E]/10'}
                ${page === currentPage ? 'hover:bg-primary/90' : ''}
              `}
              onClick={() => onPageChange(page)}
              disabled={page === '...'}
            >
              {page}
            </Button>
          ))}
          <Button 
            variant={currentPage === totalPages ? 'outline' : 'ghost'} 
            size="sm"
            className={`
              ${currentPage === totalPages ? '' : 'hover:bg-[#8B9B7E]/10'}
              ${currentPage === totalPages ? 'hover:bg-primary/90' : ''}
            `}
            onClick={() => onPageChange(currentPage + 1)}
            disabled={currentPage === totalPages}
          >
            →
          </Button>
        </div>
      </div>
    </div>
  );
};

export default ProductTable;
