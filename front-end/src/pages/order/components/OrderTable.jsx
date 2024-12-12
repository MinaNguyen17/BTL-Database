import React from 'react';
import { MoreHorizontal } from 'lucide-react';
import { OrderStatusBadge } from './OrderStatusBadge';

export const OrderTable = ({ orders }) => {
  return (
    <table className="w-full">
      <thead>
        <tr className="border-b border-gray-200">
          <th className="text-left py-4 pl-4 font-medium text-gray-500">ID</th>
          <th className="text-left py-4 pl-4 font-medium text-gray-500">Customer</th>
          <th className="text-left py-4 pl-4 font-medium text-gray-500">Order</th>
          <th className="text-left py-4 pl-4 font-medium text-gray-500">Amount</th>
          <th className="text-left py-4 pl-4 font-medium text-gray-500">Date</th>
          <th className="text-left py-4 pl-4 font-medium text-gray-500">Status</th>
          <th className="text-left py-4 pl-4 font-medium text-gray-500">Action</th>
        </tr>
      </thead>
      <tbody>
        {orders.map((order) => (
          <tr key={order.id} className="border-b border-gray-100">
            <td className="py-4 pl-4">{order.id}</td>
            <td className="py-4 pl-4">{order.customer}</td>
            <td className="py-4 pl-4">{order.type}</td>
            <td className="py-4 pl-4">${order.amount.toFixed(2)}</td>
            <td className="py-4 pl-4">{order.date}</td>
            <td className="py-4 pl-4">
              <OrderStatusBadge status={order.status} />
            </td>
            <td className="py-4 pl-8">
              <button className="text-gray-400 hover:text-gray-600 focus:outline-none">
                <MoreHorizontal className="h-5 w-5" />
              </button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};
