import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import AppLayout from './components/layout/AppLayout';
import AuthGuard from './components/layout/AuthGuard';
import LoginPage from './features/auth/LoginPage';
import ClientsPage from './pages/ClientsPage';
import JobsPage from './pages/JobsPage';
import DebugClaims from './components/debug/DebugClaims';

// Placeholder Pages
const Dashboard = () => (
  <div>
    <h2 className="text-2xl font-bold mb-4">Dashboard</h2>
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
      <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
        <h3 className="text-gray-500 text-sm font-medium">Jobs Today</h3>
        <p className="text-2xl font-bold text-slate-800">0</p>
      </div>
    </div>
    <DebugClaims />
  </div>
);

const Schedule = () => <h2 className="text-2xl font-bold">Schedule View</h2>;

function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Public Route */}
        <Route path="/login" element={<LoginPage />} />

        {/* Protected Routes */}
        <Route path="/" element={
          <AuthGuard>
            <AppLayout />
          </AuthGuard>
        }>
          <Route index element={<Dashboard />} />
          <Route path="jobs" element={<JobsPage />} />
          <Route path="schedule" element={<Schedule />} />
          <Route path="clients" element={<ClientsPage />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
