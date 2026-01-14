#!/bin/bash

# ====================================================
# FRESH NEST: REVENUE DASHBOARD RESTORATION
# Feature: Analytics & Reporting (with Fixes)
# Approach: Client-Side Aggregation + Recharts
# ====================================================

echo "🚀 Restoring Revenue Dashboard..."

# 0. Install Dependencies
echo "📦 Installing recharts..."
npm install recharts

# 1. Create the Aggregation Hook
echo "📝 Creating src/hooks/useDashboard.js..."
cat << 'INNER_EOF' > src/hooks/useDashboard.js
import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, orderBy, doc, getDoc, limit 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';
import { format, subMonths, isSameMonth } from 'date-fns';

export const useDashboard = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState({
    totalRevenue: 0,
    jobsCompleted: 0,
    avgTicket: 0,
    revenueByMonth: [],
    recentActivity: []
  });
  const [role, setRole] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) return;

    const init = async () => {
      try {
        // 1. Get Role & Org
        const userDoc = await getDoc(doc(db, 'users', user.uid));
        if (!userDoc.exists()) throw new Error("User profile not found");
        
        const { orgId, role: userRole } = userDoc.data();
        setRole(userRole);

        if (!orgId) throw new Error("No Org ID");

        // 2. Define Query based on Role
        let q;
        if (userRole === 'admin') {
          // Admin: Get all jobs for calculation (Limit to 500 for MVP safety)
          q = query(
            collection(db, 'jobs'),
            where('orgId', '==', orgId),
            orderBy('scheduledDate', 'desc'),
            limit(500)
          );
        } else {
          // Staff: Only get their recent jobs
          q = query(
            collection(db, 'jobs'),
            where('orgId', '==', orgId),
            where('assignedTo', 'array-contains', user.uid),
            orderBy('scheduledDate', 'desc'),
            limit(10)
          );
        }

        // 3. Real-time Listener
        const unsubscribe = onSnapshot(q, (snapshot) => {
          const jobs = snapshot.docs.map(d => ({ 
            id: d.id, 
            ...d.data(),
            scheduledDate: d.data().scheduledDate?.toDate(),
            completedAt: d.data().completedAt?.toDate()
          }));

          if (userRole === 'admin') {
            processAdminStats(jobs);
          } else {
            processStaffStats(jobs);
          }
          setLoading(false);
        }, (err) => {
          console.error(err);
          setError("Failed to load dashboard data.");
          setLoading(false);
        });

        return unsubscribe;

      } catch (err) {
        console.error(err);
        setError(err.message);
        setLoading(false);
      }
    };

    const unsubPromise = init();
    return () => { unsubPromise && unsubPromise.then(fn => fn && fn()); };
  }, []);

  // --- Aggregation Logic (Admin) ---
  const processAdminStats = (jobs) => {
    const completedJobs = jobs.filter(j => j.status === 'completed');
    
    // KPI: Totals
    const totalRevenue = completedJobs.reduce((sum, job) => sum + (Number(job.price) || 0), 0);
    const jobsCompleted = completedJobs.length;
    const avgTicket = jobsCompleted > 0 ? totalRevenue / jobsCompleted : 0;

    // Chart: Last 6 Months
    const last6Months = Array.from({ length: 6 }).map((_, i) => {
      const d = subMonths(new Date(), i); 
      return {
        date: d,
        label: format(d, 'MMM'),
        revenue: 0
      };
    }).reverse();

    completedJobs.forEach(job => {
      if (!job.completedAt) return;
      const monthBucket = last6Months.find(m => isSameMonth(m.date, job.completedAt));
      if (monthBucket) {
        monthBucket.revenue += (Number(job.price) || 0);
      }
    });

    setStats({
      totalRevenue,
      jobsCompleted,
      avgTicket,
      revenueByMonth: last6Months,
      recentActivity: jobs.slice(0, 5) // Last 5 jobs regardless of status
    });
  };

  // --- Aggregation Logic (Staff) ---
  const processStaffStats = (jobs) => {
    setStats({
      recentActivity: jobs
    });
  };

  return { stats, role, loading, error };
};
INNER_EOF

# 2. Create Reusable KPI Card
echo "📝 Creating src/components/dashboard/KPICard.jsx..."
mkdir -p src/components/dashboard
cat << 'INNER_EOF' > src/components/dashboard/KPICard.jsx
import React from 'react';

const KPICard = ({ title, value, icon: Icon, colorClass = "bg-brand-50 text-brand-600" }) => {
  return (
    <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-start justify-between">
      <div>
        <p className="text-sm font-medium text-slate-500 mb-1">{title}</p>
        <h3 className="text-2xl font-bold text-slate-800">{value}</h3>
      </div>
      <div className={`p-3 rounded-lg ${colorClass}`}>
        <Icon size={24} />
      </div>
    </div>
  );
};

export default KPICard;
INNER_EOF

# 3. Create Revenue Chart (Responsive)
echo "📝 Creating src/components/dashboard/RevenueChart.jsx..."
cat << 'INNER_EOF' > src/components/dashboard/RevenueChart.jsx
import React from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const RevenueChart = ({ data }) => {
  if (!data || data.length === 0) return null;

  return (
    <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 h-96 flex flex-col">
      <h3 className="text-lg font-bold text-slate-800 mb-6">Revenue Trend</h3>
      
      {/* Mobile Scroll Wrapper */}
      <div className="flex-1 min-w-0 overflow-x-auto">
        <div className="min-w-[500px] h-full"> 
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
              <XAxis 
                dataKey="label" 
                axisLine={false} 
                tickLine={false} 
                tick={{ fill: '#64748b', fontSize: 12 }} 
                dy={10}
              />
              <YAxis 
                axisLine={false} 
                tickLine={false} 
                tick={{ fill: '#64748b', fontSize: 12 }}
                tickFormatter={(value) => `$${value}`}
              />
              <Tooltip 
                cursor={{ fill: '#f8fafc' }}
                contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                formatter={(value) => [`$${value.toFixed(2)}`, 'Revenue']}
              />
              <Bar 
                dataKey="revenue" 
                fill="#0ea5e9" 
                radius={[4, 4, 0, 0]} 
                barSize={40}
              />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
};

export default RevenueChart;
INNER_EOF

# 4. Create Staff Dashboard (With Client Name Fix)
echo "📝 Creating src/components/dashboard/StaffDashboard.jsx..."
cat << 'INNER_EOF' > src/components/dashboard/StaffDashboard.jsx
import React from 'react';
import { Calendar, MapPin, CheckCircle, User } from 'lucide-react';
import { format } from 'date-fns';

const StaffDashboard = ({ jobs, clients }) => {
  
  // Helper to find name from ID
  const getClientName = (id) => {
    if (!clients) return 'Loading...';
    const client = clients.find(c => c.id === id);
    return client ? client.name : 'Unknown Client';
  };

  return (
    <div className="space-y-6">
      <div className="bg-brand-600 text-white p-6 rounded-2xl shadow-lg">
        <h1 className="text-2xl font-bold">Welcome Back!</h1>
        <p className="text-brand-100 opacity-90">Here are your assigned jobs.</p>
      </div>

      <div className="space-y-4">
        <h2 className="font-bold text-slate-800 text-lg">Upcoming Jobs</h2>
        {jobs.length === 0 ? (
          <div className="bg-white p-8 text-center rounded-xl border border-gray-100 text-slate-500">
            No jobs assigned right now.
          </div>
        ) : (
          jobs.map(job => (
            <div key={job.id} className="bg-white p-4 rounded-xl shadow-sm border border-gray-100 flex items-start gap-4">
              <div className="bg-brand-50 p-3 rounded-lg text-brand-600 shrink-0">
                <Calendar size={20} />
              </div>
              <div>
                <div className="font-bold text-slate-900">
                  {job.scheduledDate ? format(job.scheduledDate, 'MMM d, h:mm a') : 'TBD'}
                </div>
                
                <div className="flex items-center gap-1 text-sm text-slate-600 mt-1">
                  <User size={14} />
                  {getClientName(job.clientId)}
                </div>

                <div className="mt-2">
                  <span className={`text-[10px] uppercase font-bold px-2 py-1 rounded-full ${
                    job.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-blue-50 text-blue-700'
                  }`}>
                    {job.status}
                  </span>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default StaffDashboard;
INNER_EOF

# 5. Create Admin Dashboard (Main View)
echo "📝 Creating src/components/dashboard/AdminDashboard.jsx..."
cat << 'INNER_EOF' > src/components/dashboard/AdminDashboard.jsx
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
INNER_EOF

# 6. Create Dashboard Page (With Client Fetching Fix)
echo "📝 Creating src/pages/DashboardPage.jsx..."
cat << 'INNER_EOF' > src/pages/DashboardPage.jsx
import React from 'react';
import { useDashboard } from '../hooks/useDashboard';
import { useClients } from '../hooks/useClients';
import AdminDashboard from '../components/dashboard/AdminDashboard';
import StaffDashboard from '../components/dashboard/StaffDashboard';

const DashboardPage = () => {
  const { stats, role, loading: dashboardLoading, error } = useDashboard();
  const { clients, loading: clientsLoading } = useClients();

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
    : <StaffDashboard jobs={stats.recentActivity} clients={clients} />;
};

export default DashboardPage;
INNER_EOF

# 7. Update App.jsx Routing
echo "📝 Updating src/App.jsx..."
cat << 'INNER_EOF' > src/App.jsx
import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import AppLayout from './components/layout/AppLayout';
import AuthGuard from './components/layout/AuthGuard';
import LoginPage from './features/auth/LoginPage';
import ClientsPage from './pages/ClientsPage';
import JobsPage from './pages/JobsPage';
import SchedulePage from './pages/SchedulePage';
import SettingsPage from './pages/SettingsPage';
import DashboardPage from './pages/DashboardPage';

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
          <Route index element={<DashboardPage />} />
          <Route path="jobs" element={<JobsPage />} />
          <Route path="schedule" element={<SchedulePage />} />
          <Route path="clients" element={<ClientsPage />} />
          <Route path="settings" element={<SettingsPage />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
INNER_EOF

echo "✅ SUCCESS! Revenue Dashboard Restored (with fixes)."
