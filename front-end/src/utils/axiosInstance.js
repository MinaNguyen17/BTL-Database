import axios from 'axios';

// Fallback to localhost if no environment variable is set
const BASE_URL = import.meta.env.VITE_BASE_URL;

// Create axios instance
const axiosInstance = axios.create({
  baseURL: BASE_URL,
});

// Add a request interceptor to automatically add the Bearer Token
axiosInstance.interceptors.request.use(
  (config) => {
    // Get the token from localStorage
    const token = localStorage.getItem('authToken');
    
    // If token exists, add it to the Authorization header
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    
    return config;
  },
  (error) => {
    // Handle request error
    return Promise.reject(error);
  }
);

// Function to set the authentication token
export const setAuthToken = (token) => {
  if (token) {
    // Save token to localStorage
    localStorage.setItem('authToken', token);
    // Optionally, you can also set the token in the default headers
    axiosInstance.defaults.headers.common['Authorization'] = `Bearer ${token}`;
  } else {
    // Remove token from localStorage
    localStorage.removeItem('authToken');
    // Remove the Authorization header
    delete axiosInstance.defaults.headers.common['Authorization'];
  }
};

// Export the configured axios instance and BASE_URL for reference
export { BASE_URL };
export default axiosInstance;