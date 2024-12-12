import { Link, useLocation } from 'react-router-dom';
import {
  RiDashboardLine,
  RiFileListLine,
  RiExchangeLine,
  RiArchiveLine,
  
  RiUserLine,
  RiSettings4Line,
  RiLogoutBoxLine,
} from 'react-icons/ri';


 const navItems = [
    { icon: RiDashboardLine, label: 'Dashboard', active: false, href:'#' },
    { icon: RiFileListLine, label: 'Order Summary', active: false, href:'/order' },
    { icon: RiFileListLine, label: 'Message', active: false, href:'/message' },
    { icon: RiExchangeLine, label: 'Transaction', active: false, href:'/transaction' },
    { icon: RiArchiveLine, label: 'Inventory', active: false, href:'#' },
    { icon: RiArchiveLine, label: 'Product View', active: false, href: '/productview' },
    { icon: RiArchiveLine, label: 'Product Add', active: false, href: '/productadd1' },
  ];
const supportItems = [
    { icon: RiUserLine, label: 'Account' },
    { icon: RiSettings4Line, label: 'Settings' },
    { icon: RiLogoutBoxLine, label: 'Logout' },
  ];
function Sidebar() {
     const location = useLocation();
  return (
    <div className="w-64 z-10 bg-white border-r p-6 flex flex-col fixed h-screen overflow-y-auto">
        <div className="flex items-center gap-2 mb-12">
          <div className="w-6 h-6 bg-[#8B9B7E] rounded-full"></div>
          <span className="text-xl font-semibold">dpopstore</span>
        </div>
        
        <nav className="flex-1 flex flex-col">
          <div className="space-y-6">
            <div>
              <div className="text-sm text-gray-500 mb-4">General</div>
              <div className="space-y-2">
                {navItems.map((item) => {
        const isActive = location.pathname === item.href; // Check if the link is active

        return (
          <Link
            to={item.href}
            key={item.label}
            className={`flex items-center no-underline  hover:text-[#7a8a61] text-black gap-3 p-3 rounded-lg cursor-pointer ${
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
              <div className="text-sm  text-gray-500 mb-4">Support</div>
              <div className="space-y-2">
                {supportItems.map((item) => (
                  <div 
                    key={item.label}
                    className="flex items-center gap-3 p-3 rounded-lg cursor-pointer hover:bg-gray-100"
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
  )
}

export default Sidebar
