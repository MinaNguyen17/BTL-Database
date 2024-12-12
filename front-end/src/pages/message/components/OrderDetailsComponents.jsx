import React from 'react';
import { BsThreeDotsVertical } from 'react-icons/bs';

export const ProductItem = () => (
  <div className="flex items-center space-x-3">
    <img 
      src="https://images.unsplash.com/photo-1526947425960-945c6e72858f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80"
      alt="Lotion care"
      className="object-cover w-16 h-16 rounded-lg"
    />
    <div className="flex-1">
      <div className="font-semibold text-[15px]">Lotion care</div>
      <div className="text-sm font-normal text-gray-500">Variant: Stawberry</div>
      <div className="text-sm font-normal">1 Product</div>
    </div>
    <div className="text-right font-bold text-[15px]">$23.00</div>
  </div>
);

export const ProductSection = () => (
  <div className="p-4 rounded-lg border">
    <h3 className="mb-3 font-medium">Product</h3>
    <ProductItem />
    <div className="pt-3 mt-3 border-t">
      <ProductItem />
    </div>
  </div>
);

export const DeliverySection = () => (
  <div className="p-4 rounded-lg border">
    <h3 className="mb-3 font-medium">Delivery</h3>
    <div className="flex items-center space-x-3">
      <div className="flex justify-center items-center w-12 h-12 bg-gray-100 rounded-lg">
        <img 
          src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/2560px-Amazon_logo.svg.png" 
          alt="dpopexpress"
          className="object-contain w-8 h-8"
        />
      </div>
      <div className="flex-1">
        <div className="font-semibold text-[15px]">dpopexpress</div>
        <div className="text-sm font-normal text-gray-500">Lorem ipsum dolor</div>
      </div>
      <div className="text-right font-bold text-[15px]">$3.00</div>
    </div>
  </div>
);

export const AddressSection = () => (
  <div className="p-4 rounded-lg border">
    <h3 className="mb-3 font-medium">Address</h3>
    <p className="text-sm text-gray-600">2464 Royal Ln, Mesa, New Jersey 45463</p>
    <div className="overflow-hidden mt-2 rounded-lg">
      <img src="https://as1.ftcdn.net/v2/jpg/03/59/93/24/1000_F_359932491_LwOMJqKlLH0wGNqP4CPdd5TYV5JZcCeo.jpg" alt="Map" className="object-cover w-full h-24" />
    </div>
  </div>
);

export const PaymentRow = ({ label, amount }) => (
  <div className="flex justify-between text-sm font-normal">
    <span className='text-gray-500'>{label}</span>
    <span className="font-bold">${amount}</span>
  </div>
);

export const PaymentSection = () => (
  <div className="p-4 rounded-lg border">
    <h3 className="mb-3 font-medium">Payment</h3>
    <div className="space-y-2">
      <PaymentRow label="Subtotal (2 product)" amount="46.00" />
      <PaymentRow label="Delivery" amount="3.00" />
      <PaymentRow label="Tax" amount="1.00" />
      <div className="flex justify-between font-semibold text-[15px] pt-2 border-t">
        <span>Total</span>
        <span>$50.00</span>
      </div>
    </div>
  </div>
);

export const OrderDetails = () => (
  <div className="flex flex-col w-96 h-full bg-white border-l">
    <div className="flex-shrink-0 p-4 border-b">
      <div className="flex justify-between items-center">
        <h2 className="text-lg font-semibold">Detail Order</h2>
        <button className="text-gray-600 hover:text-gray-800">
          <BsThreeDotsVertical />
        </button>
      </div>
      <div className="flex justify-between mt-2 text-sm text-gray-600">
        <span>Order #1</span>
        <span>June 1, 2023, 08:22 AM</span>
      </div>
    </div>
    <div className="p-4 overflow-y-auto flex-1 [scrollbar-width:4px] [&::-webkit-scrollbar]:w-1 [&::-webkit-scrollbar-thumb]:bg-gray-300/50 [&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-track]:bg-transparent scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
      <div className="space-y-4">
        <ProductSection />
        <DeliverySection />
        <AddressSection />
        <PaymentSection />
      </div>
    </div>
  </div>
);
