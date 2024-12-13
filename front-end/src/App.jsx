import { BrowserRouter as Router, Route, Routes, Navigate  } from 'react-router-dom';
import OrderSummary from "./pages/order/OrderPage";
import ProductPage from "./pages/product-view-employee/ProductView";
import ProductViewEmployee from "./pages/product-details/ProductPage";
import Layout from './Layout';
import TransactionPage from './pages/transaction/TransactionPage';
import MessagePage from './pages/message/MessagePage';
import ProductAdd from './pages/product-add1/ProductAdd';
import ProductAdd2 from './pages/product-add2/ProductAdd';
import LoginPage from './pages/Acc/login';
import EmployeeInfo from './pages/Acc/empInfo';
import EmpShift from './pages/Acc/shift';

function App() {
  return (
      <Router>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/order" element={<OrderSummary />} />
            <Route path="/productview" element={<ProductViewEmployee />} />
            <Route path="/product-details" element={<ProductPage />} />
            <Route path="/productadd1" element={<ProductAdd />} />
            <Route path="/productadd2" element={<ProductAdd2 />} />
            <Route path="/transaction" element={<TransactionPage />} />
            <Route path="/message" element={<MessagePage />} />
            <Route path="/empInfo" element={<EmployeeInfo />} />
          <Route path="Login" element={<LoginPage />} />
            <Route path='*' element={<Navigate to="/order" />} />
            <Route  path="shift" element={<EmpShift/>}/>
          </Route>
        </Routes>
      </Router>
  );
}
export default App;