import React from 'react';
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { ArrowUpDown, ArrowUp, ArrowDown } from 'lucide-react';

const ProductTableSkeleton = ({ itemsPerPage }) => {
  return (
    <>
      {[...Array(itemsPerPage)].map((_, index) => (
        <tr 
          key={index} 
          className={`${index % 2 === 0 ? 'bg-[#FAFCF3]' : 'bg-white'}`}
        >
          {[...Array(6)].map((_, colIndex) => (
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
  data, 
  currentPage, 
  itemsPerPage, 
  totalItems, 
  paginate,
  isLoading,
  sortConfig,
  onSort
}) => {
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

  // Render sort icon based on current sort configuration
  const renderSortIcon = (key) => {
    if (sortConfig.key !== key) return <ArrowUpDown className="h-4 w-4" />;
    return sortConfig.direction === 'ascending' 
      ? <ArrowUp className="h-4 w-4" /> 
      : <ArrowDown className="h-4 w-4" />;
  };

  return (
    <div className="bg-white rounded-lg">
      <table className="w-full">
        <thead>
          <tr className="border-b">
            <th className="p-4 text-left">ID Card Number</th>
            <th className="p-4 text-left">Last Name</th>
            <th className="p-4 text-left flex items-center">
              First Name
              <Button 
                variant="ghost" 
                size="sm" 
                onClick={() => onSort('Fname')}
                className="ml-2"
              >
                {renderSortIcon('Fname')}
              </Button>
            </th>
            <th className="p-4 text-left">Date of Birth</th>
            <th className="p-4 text-left">Position</th>
            <th className="p-4 text-left flex items-center">
              Wage 
              <Button 
                variant="ghost" 
                size="sm" 
                onClick={() => onSort('Wage')}
                className="ml-2"
              >
                {renderSortIcon('Wage')}
              </Button>
            </th>
          </tr>
        </thead>
        <tbody>
          {isLoading ? (
            <ProductTableSkeleton itemsPerPage={itemsPerPage} />
          ) : (
            data.map((employee, index) => (
              <tr 
                key={index} 
                className={`
                  ${index % 2 === 0 ? 'bg-[#FAFCF3]' : 'bg-white'}
                `}
              >
                <td className="p-4">{employee.ID_Card_Num}</td>
                <td className="p-4">{employee.Lname}</td>
                <td className="p-4">{employee.Fname}</td>
                <td className="p-4">{new Date(employee.DOB).toLocaleDateString()}</td>
                <td className="p-4">{employee.Position}</td>
                <td className="p-4">{employee.Wage.toLocaleString('en-US', { style: 'currency', currency: 'USD' })}</td>
              </tr>
            ))
          )}
        </tbody>
      </table>

      {/* Pagination */}
      <div className="flex justify-center items-center space-x-2 p-4">
        <Button 
          variant="outline" 
          size="sm" 
          onClick={() => paginate(currentPage - 1)} 
          disabled={currentPage === 1}
        >
          Previous
        </Button>

        <div className="flex space-x-1">
          {getPageNumbers().map((pageNumber, index) => (
            <Button
              key={index}
              variant={pageNumber === currentPage ? 'default' : 'outline'}
              size="sm"
              onClick={() => typeof pageNumber === 'number' && paginate(pageNumber)}
              disabled={pageNumber === '...'}
            >
              {pageNumber}
            </Button>
          ))}
        </div>

        <Button 
          variant="outline" 
          size="sm" 
          onClick={() => paginate(currentPage + 1)} 
          disabled={currentPage === totalPages}
        >
          Next
        </Button>
      </div>
    </div>
  );
};

export default ProductTable;
