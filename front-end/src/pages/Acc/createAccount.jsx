import React, { useState } from 'react';
import axiosInstance, { setAuthToken } from '../../utils/axiosInstance';
import './login.css';

const CreateAccount = () => {
  const [username, setUsername] = useState('');
  const [role, setRole] = useState('');
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  const handleSubmit = async (event) => {
    event.preventDefault(); // Ngăn hành vi mặc định của form

    // Lấy token từ localStorage
    const token = localStorage.getItem('authToken');
    const ID = localStorage.getItem('UserID');

    console.log(ID);

    // Kiểm tra token hợp lệ
    if (!token) {
      setErrorMessage('You must be logged in to create an account!');
      return;
    }

    // Cấu hình axios với token
    setAuthToken(token);

    // Gửi yêu cầu tạo tài khoản
    try {
      setLoading(true); // Đặt trạng thái loading
      const response = await axiosInstance.post(
        '/account/create',
        { ID_Card_Num: username, Role: role },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
    
      // Lấy ra username từ phản hồi
      const createdUsername = response.data.account?.username;
    
      alert(`Create Account successful for username: ${createdUsername}`);
      setLoading(false);
    
      // Reset form sau khi thành công
      setUsername('');
      setRole('');
    } catch (error) {
      setLoading(false);
    
      if (error.response) {
        // Lỗi từ server
        setErrorMessage(error.response.data?.message || 'Failed to create account.');
      } else {
        // Lỗi mạng hoặc không có phản hồi từ server
        setErrorMessage('Network error. Please try again later.');
      }
    }
  };

  return (
    <div className="login-container">
      <div className="login-left">
        <form onSubmit={handleSubmit}>
          <h2>Fashion Store Management!</h2>

          {/* Thông báo lỗi */}
          {errorMessage && <div className="error-message">{errorMessage}</div>}

          <div className="input-group">
            <label htmlFor="username">Employee ID_Card_Num</label>
            <input
              type="text"
              id="username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Enter ID Card Number"
              required
            />
          </div>
          <div className="input-group">
            <label htmlFor="role">Role</label>
            <input
              type="text"
              id="role"
              value={role}
              onChange={(e) => setRole(e.target.value)}
              placeholder="Enter Role (e.g., Admin)"
              required
            />
          </div>

          <button type="submit" className="btn-signin" disabled={loading}>
            {loading ? 'Creating Account...' : 'Create'}
          </button>
        </form>
      </div>
      <div className="login-right">
        <img src="src/assets/images/l.avif" alt="Laptop Dashboard" className="laptop-image" />
      </div>
    </div>
  );
};

export default CreateAccount;
