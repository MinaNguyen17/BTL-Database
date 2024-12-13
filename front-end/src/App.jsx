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
import AddShift from './pages/Acc/addshift';
import ProtectedRoute from './components/route/ProtectedRoute';
import CreateAccount from './pages/Acc/createAccount';
import Import from './pages/inventory/import';
import ImportBill from './pages/inventory/importBill';
import EmployeeView from './pages/employee-view/EmployeeView';
import ProductView from './pages/productview';
import ProductEdit from './pages/productedit';

function App() {
  return (
      <Router>
        <Routes>
          {/* Public Login Route */}
          <Route path="/login" element={<LoginPage />} />

          {/* Protected Routes */}
          <Route element={<ProtectedRoute />}>
            <Route element={<Layout />}>
              <Route path="/order" element={<OrderSummary />} />
              <Route path="/productview" element={<ProductViewEmployee />} />
              <Route path="/productview/:productId" element={<ProductView />} />
              <Route path="/productedit" element={<ProductEdit />} />
              <Route path="/employeeview" element={<EmployeeView />} />
              <Route path="/product-details" element={<ProductPage />} />
              <Route path="/productadd1" element={<ProductAdd />} />
              <Route path="/productadd2" element={<ProductAdd2 />} />
              <Route path="/transaction" element={<TransactionPage />} />
              <Route path="/message" element={<MessagePage />} />
              <Route path="/empInfo" element={<EmployeeInfo />} />
              <Route path="/create-account" element={<CreateAccount />} />
              <Route path="/shift" element={<EmpShift/>}/>
              <Route path="/add-shift" element={<AddShift/>}/>
              <Route path="/import" element={<Import/>} />
              <Route path="/importbill" element={<ImportBill/>} />

              <Route path='*' element={<Navigate to="/order" />} />
              
            </Route>
          </Route>
        </Routes>
      </Router>
  );
}
export default App;