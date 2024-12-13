import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import {
  RiDashboardLine,
  RiFileListLine,
  RiExchangeLine,
  RiArchiveLine,
  RiUserLine,
  RiSettings4Line,
  RiLogoutBoxLine,
} from 'react-icons/ri';
import { accountService } from '../../services/accountService';

const navItems = [
    { icon: RiDashboardLine, label: 'Dashboard', active: false, href:'#' },
    { icon: RiFileListLine, label: 'Order Summary', active: false, href:'/order' },
    { icon: RiFileListLine, label: 'Message', active: false, href:'/message' },
    { icon: RiExchangeLine, label: 'Transaction', active: false, href:'/transaction' },
    { icon: RiArchiveLine, label: 'Inventory', active: false, href:'/inventory' },
    { icon: RiArchiveLine, label: 'Employee View', active: false, href: '/employeeview' },
    { icon: RiArchiveLine, label: 'Product Details', active: false, href: '/product-details' },
    { icon: RiArchiveLine, label: 'Product View', active: false, href: '/productview' },
    { icon: RiArchiveLine, label: 'Product Add 1', active: false, href: '/productadd1' },
    { icon: RiArchiveLine, label: 'Product Add 2', active: false, href: '/productadd2' },
    { icon: RiArchiveLine, label: 'Shift', active: false, href: '/shift' },
    { icon: RiArchiveLine, label: 'Add Shift', active: false, href: '/add-shift' },
];

function Sidebar() {
    const location = useLocation();
    const navigate = useNavigate();

    const supportItems = [
        // <Route path="/dashboard" element={<CreateAccount />} />
        { icon: RiUserLine, label: 'Create Account', onClick: () => navigate('/create-account') },
        { icon: RiUserLine, label: 'Account', onClick: () => navigate('/empInfo') },
        { icon: RiSettings4Line, label: 'Settings', onClick: () => {} },
        { 
            icon: RiLogoutBoxLine, 
            label: 'Logout', 
            onClick: () => {
                // Call logout service
                accountService.logout();
                // Navigate to login page
                navigate('/login');
            } 
        },
    ];

    return (
        <div className="flex overflow-y-auto fixed z-10 flex-col p-6 w-64 h-screen bg-white border-r">
            <div className="flex gap-2 items-center mb-12">
                <div className="w-6 h-6 bg-[#8B9B7E] rounded-full"></div>
                <span className="text-xl font-semibold">dpopstore</span>
            </div>
            
            <nav className="flex flex-col flex-1">
                <div className="space-y-6">
                    <div>
                        <div className="mb-4 text-sm text-gray-500">General</div>
                        <div className="space-y-2">
                            {navItems.map((item) => {
                                const isActive = location.pathname === item.href;
                                return (
                                    <Link
                                        to={item.href}
                                        key={item.label}
                                        className={`flex items-center no-underline hover:text-[#7a8a61] text-black gap-3 p-3 rounded-lg cursor-pointer ${
                                            isActive ? 'bg-[#8B9B7E] text-white' : 'hover:bg-gray-100'
                                        }`}
                                    >
                                        <item.icon className="text-xl" />
                                        <span>{item.label}</span>
                                    </Link>
                                );
                            })}
                        </div>
                    </div>

                    <div>
                        <div className="mb-4 text-sm text-gray-500">Support</div>
                        <div className="space-y-2">
                            {supportItems.map((item) => (
                                <div 
                                    key={item.label}
                                    onClick={item.onClick}
                                    className="flex gap-3 items-center p-3 rounded-lg cursor-pointer hover:bg-gray-100"
                                >
                                    <item.icon className="text-xl" />
                                    <span>{item.label}</span>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            </nav>
        </div>
    );
}

export default Sidebar;
