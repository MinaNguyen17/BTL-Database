import React from 'react';
import { Bell, Search, MoreVertical, Download } from 'lucide-react';

export function TransactionHeader({ search, onSearchChange }) {
  return (
    <header className="bg-white border-b border-gray-200 px-8 py-4 flex justify-between items-center">
      <h1 className="text-2xl font-semibold">Transaction</h1>
      <div className="flex items-center gap-4">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 h-4 w-4" />
          <input 
            type="text" 
            placeholder="Search Transaction" 
            className="w-64 pl-10 border border-gray-200 rounded-lg"
            value={search}
            onChange={onSearchChange}
          />
        </div>
        <button className="flex items-center gap-2 border border-gray-200 rounded-lg px-4 py-2 hover:bg-gray-50">
          <MoreVertical className="h-4 w-4" />
          Bulk Action
        </button>
        <button className="flex items-center gap-2 border border-gray-200 rounded-lg px-4 py-2 hover:bg-gray-50">
          <Download className="h-4 w-4" />
          Export Product
        </button>
        <button className="relative">
          <Bell className="text-gray-600 h-5 w-5" />
          <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center">2</span>
        </button>
      </div>
    </header>
  );
}
