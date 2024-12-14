import React, { useState } from 'react';
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Search } from 'lucide-react';

import axiosInstance from '@/utils/axiosInstance';

const ProductSearchBar = ({ 
  data, 
  searchKeys = ['ID_Card_Num'], 
  onSearch 
}) => {



  // State để điều khiển form popup
  const [isOpen, setIsOpen] = useState(false);
  
  // State để lưu trữ thông tin form
  const [employee, setEmployee] = useState({
    ID_Card_Num: '',
    Fname: '',
    Lname: '',
    DOB: '',
    Sex: '',
    Position: '',
    Wage: ''
  });

  // State để lưu thông báo từ server
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  // Hàm để mở/đóng pop-up form
  const togglePopup = () => {
    setIsOpen(!isOpen);
    setMessage('');
    setError('');
  };

  // Hàm cập nhật giá trị các trường trong form
  const handleChange = (e) => {
    const { name, value } = e.target;
    setEmployee(prevState => ({
      ...prevState,
      [name]: value
    }));
  };

  // Hàm gửi thông tin nhân viên tới API
  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const response = await axiosInstance.post('/employee', employee);
      if (response.data.message) {
        setMessage(response.data.message);
        setError('');
      }
    } catch (err) {
      setError(err.response?.data?.error || 'Có lỗi xảy ra');
      setMessage('');
    }
  };



  const [searchTerm, setSearchTerm] = useState('');

  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };

  const handleSearchSubmit = () => {
    // Trigger search in parent component, focusing on ID search
    onSearch(searchTerm);
  };

  // Optional: Filter data for local preview (not used for API search)
  const filteredData = data.filter(item => 
    searchKeys.some(key => 
      item[key] && 
      item[key].toString().toLowerCase().includes(searchTerm.toLowerCase())
    )
  );

  return (
    <div className="flex gap-4 mb-6">
      <div className="relative flex-grow">
        <Input 
          type="text" 
          placeholder="Search by Employee ID" 
          className="max-w-md pr-10"
          value={searchTerm}
          onChange={handleSearchChange}
          onKeyPress={(e) => e.key === 'Enter' && handleSearchSubmit()}
        />
        <Button 
          variant="ghost" 
          size="icon" 
          className="absolute right-0 top-1/2 -translate-y-1/2"
          onClick={handleSearchSubmit}
        >
          <Search className="h-5 w-5 text-gray-500" />
        </Button>
      </div>
      <Button variant="outline" className="gap-2">
        <span className="text-lg">⋮</span>
        Bulk Action
      </Button>
      <Button variant="ghost" className="gap-2">
        <span>↓</span>
        Export Employees
      </Button>
      {/* <Button className="gap-2 bg-primary hover:bg-primary/90">
        <span>+</span>
        Add Employee
      </Button> */}
      <div>
      <Button 
        className="gap-2 bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded-md"
        onClick={togglePopup}
      >
        <span>+</span> Add Employee
      </Button>

      {isOpen && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 flex justify-center items-center z-50">
          <div className="bg-white p-6 rounded-lg w-96 shadow-lg">
            <h2 className="text-xl font-bold mb-4 text-center">Thêm nhân viên</h2>
            <form onSubmit={handleSubmit}>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700">ID Card Number</label>
                <input
                  type="text"
                  name="ID_Card_Num"
                  value={employee.ID_Card_Num}
                  onChange={handleChange}
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700">First Name</label>
                <input
                  type="text"
                  name="Fname"
                  value={employee.Fname}
                  onChange={handleChange}
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700">Last Name</label>
                <input
                  type="text"
                  name="Lname"
                  value={employee.Lname}
                  onChange={handleChange}
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700">Date of Birth</label>
                <input
                  type="date"
                  name="DOB"
                  value={employee.DOB}
                  onChange={handleChange}
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700">Sex</label>
                <select
                  name="Sex"
                  value={employee.Sex}
                  onChange={handleChange}
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700">Position</label>
                <input
                  type="text"
                  name="Position"
                  value={employee.Position}
                  onChange={handleChange}
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700">Wage</label>
                <input
                  type="number"
                  name="Wage"
                  value={employee.Wage}
                  onChange={handleChange}
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <button 
                type="submit"
                className="w-full py-2 bg-green-500 hover:bg-green-600 text-white font-semibold rounded-md"
              >
                Thêm nhân viên
              </button>
            </form>

            {message && <div className="mt-4 text-green-500 text-center">{message}</div>}
            {error && <div className="mt-4 text-red-500 text-center">{error}</div>}

            <button
              onClick={togglePopup}
              className="mt-4 w-full py-2 bg-gray-300 hover:bg-gray-400 text-gray-700 rounded-md"
            >
              Đóng
            </button>
          </div>
        </div>
      )}
    </div>

    </div>
  );
};

export default ProductSearchBar;
