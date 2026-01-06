import React from 'react';
import { Outlet } from 'react-router-dom';
import Sidebar from './Sidebar';
import BottomNav from './BottomNav';

const AppLayout = () => {
  return (
    <div className="min-h-screen bg-gray-50 flex">
      <Sidebar />
      <main className="flex-1 md:ml-64 pb-20 md:pb-0">
        <div className="p-4 md:p-8 max-w-7xl mx-auto">
          {/* Mobile Header */}
          <header className="md:hidden flex justify-between items-center mb-6">
            <h1 className="text-xl font-bold text-brand-600">Fresh Nest</h1>
            <div className="w-8 h-8 bg-gray-200 rounded-full"></div>
          </header>
          <Outlet />
        </div>
      </main>
      <BottomNav />
    </div>
  );
};

export default AppLayout;
