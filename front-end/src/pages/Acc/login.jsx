import React, { useState } from 'react';
import './login.css'; // You can adjust your CSS file name accordingly
import axiosInstance, { setAuthToken , setUserID } from '../../utils/axiosInstance';
import { useNavigate } from 'react-router-dom';


const LoginPage = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const navigate = useNavigate();

const handleSubmit = async (event) => {
  event.preventDefault(); // Prevent default form submission behavior

  const username = event.target.username.value; // Replace with your input handling logic
  const password = event.target.password.value;

  try {
    const response = await axiosInstance.post("/account/login", {
      username,
      password,
    });
    console.log('Login successful:', response.data);
    // Handle successful login (e.g., redirect or save token)
    setAuthToken(response.data.token);
    localStorage.setItem('UserID', response.data.ID_Card_Num);
    console.log(localStorage.getItem("UserID"))
    navigate('/order');
    
  } catch (error) {
    if (error.response) {
      // Server responded with a status code outside the range 2xx
      console.error('Login failed:', error.response.data || error.response.statusText);
      alert('Login failed: ' + (error.response.data?.message || 'Invalid credentials'));
    } else {
      // No response from the server or network error
      console.error('Network error:', error.message);
      alert('A network error occurred. Please try again later.');
    }
  }
};


  return (
    <div className="login-container">
      <div className="login-left">
        <form onSubmit={handleSubmit}>
        <h2>Fashion Store Management!</h2>
          <div className="input-group">
            <label htmlFor="username">Username</label>
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
            <label htmlFor="password">Password</label>
            <input
              type="password"
              id="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Password"
              required
            />
          </div>
          <div className="forgot-password">
            <a href="#">Forgot password?</a>
          </div>
          <button type="submit" className="btn-signin">Sign In</button>
        </form>
        {/* <div className="create-account">
          <p>Don't have an account? <a href="#">Create account</a></p>
        </div> */}
      </div>
      <div className="login-right">
        <img src="src/assets/images/l.avif" alt="Laptop Dashboard" className="laptop-image" />
      </div>
      
    </div>
  );
};

export default LoginPage;
