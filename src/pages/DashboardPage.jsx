import React from 'react';
import { useDashboard } from '../hooks/useDashboard';
import { useClients } from '../hooks/useClients'; // ✨ Imported
import AdminDashboard from '../components/dashboard/AdminDashboard';
import StaffDashboard from '../components/dashboard/StaffDashboard';

const DashboardPage = () => {
  const { stats, role, loading: dashboardLoading, error } = useDashboard();
  const { clients, loading: clientsLoading } = useClients(); // ✨ Fetch Clients

  if (dashboardLoading || clientsLoading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-brand-600"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-4 bg-red-50 text-red-600 rounded-lg">
        Error loading dashboard: {error}
      </div>
    );
  }

  return role === 'admin' 
    ? <AdminDashboard stats={stats} /> 
    : <StaffDashboard jobs={stats.recentActivity} clients={clients} />; // ✨ Pass Clients
};

export default DashboardPage;
