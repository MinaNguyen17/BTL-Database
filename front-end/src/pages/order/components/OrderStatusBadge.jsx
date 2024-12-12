import React from 'react';

export const OrderStatusBadge = ({ status }) => {
  const styles = {
    Received: 'bg-green-100 text-green-800',
    Shipping: 'bg-purple-100 text-purple-800',
    Complaint: 'bg-red-100 text-red-800',
    Canceled: 'bg-gray-100 text-gray-800',
    Done: 'bg-blue-100 text-blue-800',
  }

  return (
    <span className={`px-3 py-1 rounded-full text-sm font-medium ${styles[status]}`}>
      {status}
    </span>
  );
};
