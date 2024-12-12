import React from 'react';
import { BiSearch } from 'react-icons/bi';

export const CustomerListItem = ({ customer }) => (
  <div className="p-4 border-b cursor-pointer hover:bg-green-50">
    <div className="flex items-center space-x-3">
      <div className="relative">
        <div className={`w-12 h-12 rounded-full overflow-hidden ${customer.bgColor}`}>
          <img src={customer.avatar} alt={customer.name} className="object-cover w-full h-full" />
        </div>
        {customer.unread && (
          <div className="absolute -top-1 -right-1 w-5 h-5 bg-[#808C6C] text-white rounded-full flex items-center justify-center text-xs font-medium">
            {customer.unread}
          </div>
        )}
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex justify-between items-center">
          <div className="font-semibold text-[15px] truncate">{customer.name}</div>
          <div className="text-xs font-medium text-gray-500">{customer.time}</div>
        </div>
        <div className="text-sm font-normal text-gray-500 truncate">{customer.message}</div>
      </div>
    </div>
  </div>
);

export const SearchBar = () => (
  <div className="relative">
    <input
      type="text"
      placeholder="Search Anything..."
      className="w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#808C6C]"
    />
    <BiSearch className="absolute left-3 top-2.5 text-gray-400 text-xl" />
  </div>
);

export const FilterButtons = () => (
  <div className="flex mt-4 space-x-2">
    <button className="px-4 py-2 bg-[#808C6C] text-white rounded-md">All</button>
    <button className="px-4 py-2 text-gray-600 rounded-md hover:bg-gray-100">Unread</button>
    <button className="px-4 py-2 text-gray-600 rounded-md hover:bg-gray-100">Complaint</button>
  </div>
);

export const CustomerList = ({ customers }) => (
  <div className="flex flex-col w-96 h-full bg-white border-r">
    <div className="p-4 border-b">
      <SearchBar />
      <FilterButtons />
    </div>
    <div className="overflow-y-auto flex-1 [scrollbar-width:4px] [&::-webkit-scrollbar]:w-1 [&::-webkit-scrollbar-thumb]:bg-gray-300/50 [&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-track]:bg-transparent scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
      {customers.map((customer) => (
        <CustomerListItem key={customer.id} customer={customer} />
      ))}
    </div>
  </div>
);
