import React from 'react';

export function TransactionStatusBadge({ status }) {
  const styles = {
    Income: 'bg-green-100 text-green-800',
    Outcome: 'bg-red-100 text-red-800',
    Pending: 'bg-yellow-100 text-yellow-800',
  };

  return (
    <span className={`px-3 py-1 rounded-full text-sm font-medium ${styles[status]}`}>
      {status}
    </span>
  );
}
