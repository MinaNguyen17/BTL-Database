import React from 'react';
import { MoreVertical, Download } from 'lucide-react';

export const OrderTableActions = () => {
  return (
    <div className="flex justify-between items-center mb-6">
      <input
        type="text"
        placeholder="Search Transaction"
        className="w-64 px-4 py-2 rounded-lg border border-gray-200"
      />
      <div className="flex gap-3">
        <button className="flex items-center gap-2 px-4 py-2 border rounded-lg hover:bg-gray-50">
          <MoreVertical className="h-4 w-4" />
          Bulk Action
        </button>
        <button className="flex items-center gap-2 px-4 py-2 border rounded-lg hover:bg-gray-50">
          <Download className="h-4 w-4" />
          Export Product
        </button>
      </div>
    </div>
  );
};
