import React from 'react';
import { DollarSign, Briefcase, TrendingUp, CheckCircle } from 'lucide-react';
import KPICard from './KPICard';
import RevenueChart from './RevenueChart';

const AdminDashboard = ({ stats }) => {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-slate-900">Dashboard</h1>

      {/* KPI GRID */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <KPICard 
          title="Total Revenue" 
          value={`$${stats.totalRevenue.toFixed(2)}`} 
          icon={DollarSign}
          colorClass="bg-green-50 text-green-600"
        />
        <KPICard 
          title="Jobs Completed" 
          value={stats.jobsCompleted} 
          icon={CheckCircle}
          colorClass="bg-blue-50 text-blue-600"
        />
        <KPICard 
          title="Avg. Ticket" 
          value={`$${stats.avgTicket.toFixed(2)}`} 
          icon={TrendingUp}
          colorClass="bg-purple-50 text-purple-600"
        />
      </div>

      {/* CHART SECTION */}
      <RevenueChart data={stats.revenueByMonth} />

      {/* RECENT ACTIVITY */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <div className="px-6 py-4 border-b border-gray-100">
          <h3 className="font-bold text-slate-800">Recent Jobs</h3>
        </div>
        <div className="divide-y divide-gray-100">
          {stats.recentActivity.map(job => (
            <div key={job.id} className="px-6 py-3 flex justify-between items-center text-sm">
              <div>
                <span className="font-medium text-slate-900 capitalize">{job.serviceType}</span>
                <span className="text-slate-400 mx-2">•</span>
                <span className="text-slate-500">{job.status}</span>
              </div>
              <div className="font-medium text-slate-900">
                ${Number(job.price || 0).toFixed(2)}
              </div>
            </div>
          ))}
          {stats.recentActivity.length === 0 && (
            <div className="p-6 text-center text-slate-400">No activity yet.</div>
          )}
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;
