import React from 'react';

export const OrderPagination = ({ currentPage, onPageChange, totalEntries }) => {
  const pageNumbers = [1, 2, '...', 9, 10];

  return (
    <div className="flex justify-between items-center mt-4 text-sm text-gray-500">
      <div>Showing 1 to 10 of {totalEntries} entries</div>
      <div className="flex gap-2">
        {pageNumbers.map((page, index) => (
          <button
            key={index}
            onClick={() => onPageChange(typeof page === 'number' ? page : currentPage)}
            className={`w-8 h-8 rounded flex items-center justify-center focus:outline-none ${
              page === currentPage 
                ? 'bg-[#8B9D83] text-white' 
                : 'hover:bg-gray-100'
            }`}
          >
            {page}
          </button>
        ))}
      </div>
    </div>
  );
};
