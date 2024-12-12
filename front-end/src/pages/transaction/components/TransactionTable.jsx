import React from 'react';
import { MoreHorizontal } from 'lucide-react';
import { TransactionStatusBadge } from './TransactionStatusBadge';

export function TransactionTable({ transactions }) {
  return (
    <div className="bg-white rounded-lg p-6">
      <table className="w-full">
        <thead>
          <tr className="border-b border-gray-200">
            <th className="text-left py-4 font-medium text-gray-500">ID</th>
            <th className="text-left py-4 font-medium text-gray-500">Customer</th>
            <th className="text-left py-4 font-medium text-gray-500">Amount</th>
            <th className="text-left py-4 font-medium text-gray-500">Date</th>
            <th className="text-left py-4 font-medium text-gray-500">Status</th>
            <th className="text-left py-4 font-medium text-gray-500">Action</th>
          </tr>
        </thead>
        <tbody>
          {transactions.map((transaction) => (
            <tr key={transaction.id} className="border-b border-gray-100">
              <td className="py-4">{transaction.id}</td>
              <td className="py-4">{transaction.customer}</td>
              <td className="py-4">${transaction.amount.toFixed(2)}</td>
              <td className="py-4">{transaction.date}</td>
              <td className="py-4">
                <TransactionStatusBadge status={transaction.status} />
              </td>
              <td className="py-4">
                <button className="text-gray-400 hover:text-gray-600">
                  <MoreHorizontal className="h-5 w-5" />
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
