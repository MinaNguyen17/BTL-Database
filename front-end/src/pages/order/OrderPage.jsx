import { useState } from 'react'

import { OrderStatusTabs } from './components/OrderStatusTabs';
import { OrderTable } from './components/OrderTable';
import { OrderTableActions } from './components/OrderTableActions';
import { OrderPagination } from './components/OrderPagination';

import { tabs, orders } from './data/orderData';

function OrderSummary() {
  const [activeTab, setActiveTab] = useState('All Order')
  const [currentPage, setCurrentPage] = useState(1)

  return (
    <div className="flex min-h-screen  ">
      {/* Sidebar */}
      

      {/* Main Content */}
      <div className="flex-1 flex flex-col">
        {/* Header */}
        

        {/* Main Content Area */}
        <main className="flex-1 ">
          <div className="space-y-6">
            <h1 className="text-2xl font-semibold bg-white p-4 pl-6">Order Summary</h1>
            <div className="bg-gray-100 p-8">  
              <div className="bg-white rounded-lg p-6">
                {/* Search and Actions */}
                <OrderTableActions />

                {/* Order Status Tabs */}
                <OrderStatusTabs 
                  tabs={tabs} 
                  activeTab={activeTab} 
                  onTabChange={setActiveTab} 
                />

                {/* Orders Table */}
                <OrderTable orders={orders} />

                {/* Pagination */}
                <OrderPagination 
                  currentPage={currentPage} 
                  onPageChange={setCurrentPage} 
                  totalEntries={orders.length} 
                />
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  )
}

export default OrderSummary
