import React from 'react';
import { CustomerList } from './components/CustomerListComponents';
import { MessageHeader, MessageThread, MessageInput } from './components/MessageComponents';
import { OrderDetails } from './components/OrderDetailsComponents';
import { messages, customerList } from './data/messageData';

const MessagePage = () => {
 
  return (
    <div className="flex-1 flex bg-gray-50 h-[calc(100vh-100px)]">
      <CustomerList customers={customerList} />
      
      <div className="flex flex-col flex-1 h-full">
        <MessageHeader customer={customerList[0]} />
        <MessageThread messages={messages} />
        <MessageInput />
      </div>

      <OrderDetails />
    </div>
  );
};

export default MessagePage;