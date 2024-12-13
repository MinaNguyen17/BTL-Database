import axiosInstance, { setAuthToken, setUserID } from '../utils/axiosInstance';

// Service for account-related API calls
export const accountService = {
  // User login
  login: async (credentials) => {
    try {
      const response = await axiosInstance.post('/account/login', {
        username: credentials.username,
        password: credentials.password
      });

      // Check if login was successful and token exists
      if (response.data && response.data.token) {
        // Set the auth token in localStorage and headers
        localStorage.setItem('authToken', response.data.token);
        setAuthToken(response.data.token);
        setUserID(response.data.ID_Card_Num);
        
        
        // Return user data or login status
        return {
          success: true,
          user: response.data.user || null,
          token: response.data.token
        };
      } else {
        // Specific error for no token
        return {
          success: false,
          error: 'Authentication failed. No token received.'
        };
      }
    } catch (error) {
      // Detailed error handling
      console.error('Login Error:', error);

      // Check for specific error types
      if (error.response) {
        // The request was made and the server responded with a status code
        switch (error.response.status) {
          case 401:
            return {
              success: false,
              error: 'Invalid username or password. Please try again.'
            };
          case 403:
            return {
              success: false,
              error: 'Access denied. You do not have permission to log in.'
            };
          case 404:
            return {
              success: false,
              error: 'User not found. Please check your credentials.'
            };
          case 500:
            return {
              success: false,
              error: 'Server error. Please try again later.'
            };
          default:
            return {
              success: false,
              error: error.response.data?.message || 'Login failed. Please try again.'
            };
        }
      } else if (error.request) {
        // The request was made but no response was received
        return {
          success: false,
          error: 'No response from server. Please check your network connection.'
        };
      } else {
        // Something happened in setting up the request
        return {
          success: false,
          error: 'An unexpected error occurred. Please try again.'
        };
      }
    }
  },

  // Logout function
  logout: () => {
    // Remove token from localStorage
    localStorage.removeItem('authToken');
    
    // Remove token from axios headers
    setAuthToken(null);

    
    // Optional: You can add a server-side logout call if needed
    // For example:
    // return axiosInstance.post('/account/logout');
  },

  // Get all accounts (admin only)
  getAllAccounts: async () => {
    try {
      const response = await axiosInstance.get('/account/all');
      return response.data;
    } catch (error) {
      console.error('Error fetching accounts:', error);
      throw error;
    }
  },

  // Change user password
  changePassword: async (passwordData) => {
    try {
      const response = await axiosInstance.post('/account/changePassword', passwordData);
      return response.data;
    } catch (error) {
      console.error('Error changing password:', error);
      throw error;
    }
  },

  // Get account by ID (admin only)
  getAccountById: async (id) => {
    try {
      const response = await axiosInstance.get(`/account/get/${id}`);
      return response.data;
    } catch (error) {
      console.error(`Error fetching account with ID ${id}:`, error);
      throw error;
    }
  },

  // Create new account (admin only)
  createAccount: async (accountData) => {
    try {
      const response = await axiosInstance.post('/account/create', accountData);
      return response.data;
    } catch (error) {
      console.error('Error creating account:', error);
      throw error;
    }
  }
};
