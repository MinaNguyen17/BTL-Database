import {
  // eslint-disable-next-line
  RiSearchLine,
  RiNotification3Line,
  // eslint-disable-next-line
} from 'react-icons/ri';

import avatarImage from '../../assets/images/avatar.png'


function Header() {
  return (
    <header className="border-b p-6 fixed top-0 left-64 right-0 bg-white z-10">
          <div className="flex justify-between items-center">
            <h1 className="text-2xl font-semibold">  </h1>
            <div className="flex items-center gap-6">
              <div className="relative">
                <RiSearchLine className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                <input 
                  type="search" 
                  placeholder="Search Anything..."
                  className="pl-10 pr-4 py-2 border rounded-lg w-64"
                />
              </div>
              <RiNotification3Line className="text-2xl text-gray-600" />
              {/* <div className="w-10 h-10 bg-[#8B9B7E] rounded-full"></div> */}
              <img src={avatarImage} className='w-[48px]'/>
            </div>
          </div>
        </header>
  )
}

export default Header
