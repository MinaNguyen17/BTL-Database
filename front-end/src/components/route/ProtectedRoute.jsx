import React from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import axiosInstance from '../../utils/axiosInstance';

const ProtectedRoute = () => {
  // Check if user is authenticated by checking for token
  const isAuthenticated = () => {
    const token = localStorage.getItem('authToken');
    return !!token;
  };

  return isAuthenticated() ? <Outlet /> : <Navigate to="/login" replace />;
};

export default ProtectedRoute;
