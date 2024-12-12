import { useState } from 'react';
import { TransactionHeader } from './components/TransactionHeader';
import { TransactionTable } from './components/TransactionTable';
import { transactions } from './data/transactionData';


function TransactionPage() {
  const [search, setSearch] = useState('');

  const handleSearchChange = (e) => {
    setSearch(e.target.value);
  };

  return (
    <div className="flex flex-col min-h-screen bg-gray-50">
      <TransactionHeader 
        search={search} 
        onSearchChange={handleSearchChange} 
      />

      <main className="flex-1 p-8">
        <TransactionTable transactions={transactions} />
      </main>
    </div>
  );
}

export default TransactionPage;