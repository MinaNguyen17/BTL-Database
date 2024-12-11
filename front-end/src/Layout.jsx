import React from 'react';
import Sidebar from './components/layout/Sidebar';
import Headerbar from './components/layout/Header';
import { Outlet } from 'react-router-dom';

const Layout = () => {
  return (
    <div className="flex h-screen overflow-x-hidden">
      {/* Sidebar */}
      <Sidebar />

      {/* Main Content Area */}
      <div className="flex-1 min-w-screen w-screen ">
        {/* This is where the nested route content will render */}
        <Headerbar />
        
        <div className='mt-24 ml-64 overflow-y-auto'>

          <Outlet />
        </div>
      </div>
    </div>
  );
};

export default Layout;
