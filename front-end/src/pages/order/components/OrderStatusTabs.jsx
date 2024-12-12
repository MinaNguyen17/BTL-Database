import React from 'react';

export const OrderStatusTabs = ({ tabs, activeTab, onTabChange }) => {
  return (
    <div className="flex gap-8 border-b mb-6">
      {tabs.map((tab) => (
        <button
          key={tab.name}
          onClick={() => onTabChange(tab.name)}
          className={`pb-4 relative group hover:border-none ${
            activeTab === tab.name 
              ? 'text-[#8B9D83] font-medium' 
              : 'text-gray-500 hover:text-gray-700'
          }`}
        >
          <span className="flex items-center gap-2">
            {tab.name} 
            {tab.count !== null && (
              <span className={`text-sm ${
                activeTab === tab.name 
                  ? 'text-[#8B9D83]' 
                  : 'text-gray-400'
              }`}>
                ({tab.count})
              </span>
            )}
          </span>
          {/* Hover indicator */}
          <div className={`absolute bottom-0 left-0 right-0 h-[2px] transition-opacity duration-200 ${
            activeTab === tab.name 
              ? 'bg-[#8B9D83] opacity-100' 
              : 'bg-[#8B9D83]/40 opacity-0 group-hover:opacity-100'
          }`} />
        </button>
      ))}
    </div>
  );
};
