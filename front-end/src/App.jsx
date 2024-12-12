import { BrowserRouter as Router, Route, Routes, Navigate  } from 'react-router-dom';
import OrderSummary from "./pages/order/OrderPage";
import ProductPage from "./pages/product/ProductPage";
import Layout from './Layout';
import TransactionPage from './pages/transaction/TransactionPage';
import MessagePage from './pages/message/MessagePage';
import ProductAdd from './pages/product-add1/ProductAdd';

function App() {
  return (
      <Router>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/order" element={<OrderSummary />} />
            <Route path="/productview" element={<ProductPage />} />
            <Route path="/productadd1" element={<ProductAdd />} />
            <Route path="/transaction" element={<TransactionPage />} />
            <Route path="/message" element={<MessagePage />} />
            <Route path='*' element={<Navigate to="/order" />} />
          </Route>
        </Routes>
      </Router>
  );
}
export default App;