import React from 'react';
import { IoMdSend } from 'react-icons/io';
import { BsThreeDotsVertical, BsPrinter } from 'react-icons/bs';
import { BiImageAlt, BiSmile } from 'react-icons/bi';
import { FaMicrophone } from 'react-icons/fa';

export const MessageHeader = ({ customer }) => (
  <div className="flex flex-shrink-0 justify-between items-center p-4 bg-white border-b">
    <div className="flex items-center space-x-3">
      <div className={`overflow-hidden w-10 h-10 bg-blue-100 rounded-full`}>
        <img src={customer.avatar} alt={customer.name} className="object-cover w-full h-full" />
      </div>
      <div>
        <div className="font-semibold text-[15px]">{customer.name}</div>
        <div className="text-sm font-normal text-gray-500">Customer</div>
      </div>
    </div>
    <div className="flex items-center space-x-4">
      <button className="text-gray-600 hover:text-gray-800">
        <BsPrinter className="text-xl" />
      </button>
      <button className="text-gray-600 hover:text-gray-800">
        <BsThreeDotsVertical className="text-xl" />
      </button>
    </div>
  </div>
);

export const MessageItem = ({ message }) => (
  <div className={`flex ${message.isCustomer ? 'justify-end' : 'justify-start'} mb-4`}>
    <div className={`max-w-[70%] ${message.isCustomer ? 'bg-[#FFECD9]' : 'bg-white'} rounded-lg p-3 shadow-sm`}>
      <div className="text-[15px] leading-relaxed">{message.content}</div>
      <div className="text-xs text-gray-500 mt-1.5 font-medium">
        {message.time} {message.isCustomer ? message.sender : 'You'}
      </div>
    </div>
  </div>
);

export const MessageThread = ({ messages }) => (
  <div className="flex-1 overflow-y-auto p-4 bg-gray-50 [scrollbar-width:4px] [&::-webkit-scrollbar]:w-1 [&::-webkit-scrollbar-thumb]:bg-gray-300/50 [&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-track]:bg-transparent scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
    {messages.map((message) => (
      <MessageItem key={message.id} message={message} />
    ))}
  </div>
);

export const ActionButton = ({ icon }) => (
  <button className="p-2 text-gray-600 rounded-full hover:bg-gray-100">
    {icon}
  </button>
);

export const MessageInput = () => (
  <div className="flex-shrink-0 p-4 bg-white border-t">
    <div className="flex items-center py-1 space-x-2">
      <input
        type="text"
        placeholder="Type a Notes...."
        className="flex-1 px-4 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#808C6C] text-[15px]"
      />
      <ActionButton icon={<BiImageAlt className="text-xl" />} />
      <ActionButton icon={<FaMicrophone className="text-xl" />} />
      <ActionButton icon={<BiSmile className="text-xl" />} />
      <button className="p-2 bg-[#808C6C] text-white rounded-lg">
        <IoMdSend className="text-xl" />
      </button>
    </div>
  </div>
);
