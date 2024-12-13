import React, { useState } from 'react';
import axiosInstance, { setAuthToken } from '../../utils/axiosInstance';
import './login.css';

const CreateAccount = () => {
  const [username, setUsername] = useState('');
  const [role, setRole] = useState('');
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  const handleSubmit = async (event) => {
    event.preventDefault(); // Prevent default form submission behavior

    // Lấy token từ localStorage hoặc context (tuỳ theo cách bạn quản lý token)
    const token = localStorage.getItem('token');

    // Kiểm tra token hợp lệ
    if (!token) {
      setErrorMessage('You must be logged in to create an account!');
      return;
    }

    // Cấu hình axios với token để xác thực
    setAuthToken(token);

    // Kiểm tra quyền phân quyền trước khi gửi yêu cầu
    try {
      const roleResponse = await axiosInstance.get('/user/role', {
        headers: { Authorization: `Bearer ${token}` },
      });

      // Kiểm tra nếu người dùng có quyền tạo tài khoản
      if (roleResponse.data.role !== 'Admin') {
        setErrorMessage('You do not have permission to create an account.');
        return;
      }

      // Nếu có quyền, tiếp tục gửi yêu cầu tạo tài khoản
      setLoading(true);
      const response = await axiosInstance.post("/account/create", {
        username,
        role,
      });

      alert('Create Account successful:', response.data);
      setLoading(false);
      // Xử lý sau khi tạo tài khoản thành công (chuyển hướng hoặc lưu token)
    } catch (error) {
      setLoading(false);

      if (error.response) {
        // Nếu có lỗi từ server
        setErrorMessage(error.response.data?.message || 'Failed to create account.');
      } else {
        // Nếu không có phản hồi từ server
        setErrorMessage('Network error. Please try again later.');
      }
    }
  };

  return (
    <div className="login-container">
      <div className="login-left">
        <form onSubmit={handleSubmit}>
          <h2>Fashion Store Management!</h2>
          
          {/* Error message */}
          {errorMessage && <div className="error-message">{errorMessage}</div>}

          <div className="input-group">
            <label htmlFor="username">Employee ID_Card_Num</label>
            <input
              type="text"
              id="username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Username"
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
              placeholder="Role"
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
