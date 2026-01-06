#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE INSTALLER
# Feature: Job Management Module
# Approach: Robust (Relational Data + Lookup)
# ====================================================

echo "🚀 Installing Job Management Feature..."

# 1. Create Directories
mkdir -p src/hooks
mkdir -p src/pages
mkdir -p src/components/jobs

# 2. Create the Custom Hook (Logic Layer)
echo "📝 Writing src/hooks/useJobs.js..."
cat << 'EOF' > src/hooks/useJobs.js
import { useState, useEffect } from 'react';
import { 
  collection, 
  query, 
  where, 
  onSnapshot, 
  addDoc, 
  serverTimestamp,
  orderBy,
  Timestamp 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useJobs = () => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    user.getIdTokenResult().then((idTokenResult) => {
      const orgId = idTokenResult.claims.orgId;

      if (!orgId) {
        setError("Organization ID missing.");
        setLoading(false);
        return;
      }

      // SECURITY: Filter by orgId
      // Note: This requires a composite index (orgId + scheduledDate)
      const q = query(
        collection(db, 'jobs'),
        where('orgId', '==', orgId),
        orderBy('scheduledDate', 'asc')
      );

      const unsubscribe = onSnapshot(q, (snapshot) => {
        const jobData = snapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data(),
          // Convert Firestore Timestamp to JS Date for easier UI handling
          scheduledDate: doc.data().scheduledDate?.toDate()
        }));
        setJobs(jobData);
        setLoading(false);
      }, (err) => {
        console.error("Error fetching jobs:", err);
        setError("Failed to load jobs. (Check console for Index link)");
        setLoading(false);
      });

      return () => unsubscribe();
    });
  }, []);

  const addJob = async (jobData) => {
    const user = auth.currentUser;
    if (!user) throw new Error("Not authenticated");

    const idTokenResult = await user.getIdTokenResult();
    const orgId = idTokenResult.claims.orgId;

    if (!orgId) throw new Error("No Organization ID found.");

    // Convert string date (from input) to Firestore Timestamp
    const timestampDate = new Date(jobData.scheduledDate);

    await addDoc(collection(db, 'jobs'), {
      clientId: jobData.clientId,
      serviceType: jobData.serviceType,
      price: Number(jobData.price),
      notes: jobData.notes,
      status: 'scheduled', // Default status
      scheduledDate: Timestamp.fromDate(timestampDate),
      orgId, 
      createdAt: serverTimestamp(),
      createdBy: user.uid
    });
  };

  return { jobs, loading, error, addJob };
};
EOF

# 3. Create Components (UI Layer)

echo "📝 Writing src/components/jobs/JobFormModal.jsx..."
cat << 'EOF' > src/components/jobs/JobFormModal.jsx
import React, { useState } from 'react';
import { X, Save, Loader, Calendar, DollarSign } from 'lucide-react';

const JobFormModal = ({ isOpen, onClose, onSave, clients }) => {
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    clientId: '',
    scheduledDate: '',
    serviceType: 'standard',
    price: '',
    notes: ''
  });

  if (!isOpen) return null;

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.clientId) {
      alert("Please select a client.");
      return;
    }
    
    setLoading(true);
    try {
      await onSave(formData);
      // Reset form
      setFormData({
        clientId: '',
        scheduledDate: '',
        serviceType: 'standard',
        price: '',
        notes: ''
      });
      onClose();
    } catch (error) {
      console.error(error);
      alert("Failed to create job.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
      <div className="bg-white rounded-xl shadow-xl w-full max-w-lg overflow-hidden">
        
        {/* Header */}
        <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
          <h3 className="font-bold text-lg text-slate-800">Schedule New Job</h3>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
            <X size={24} />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          
          {/* Client Selector (The Relational Link) */}
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Select Client *</label>
            <select
              required
              className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none bg-white"
              value={formData.clientId}
              onChange={(e) => setFormData({...formData, clientId: e.target.value})}
            >
              <option value="">-- Choose a Client --</option>
              {clients.map(client => (
                <option key={client.id} value={client.id}>
                  {client.name}
                </option>
              ))}
            </select>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">Date & Time *</label>
              <div className="relative">
                <Calendar className="absolute left-3 top-2.5 text-slate-400" size={18} />
                <input
                  type="datetime-local"
                  required
                  className="w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
                  value={formData.scheduledDate}
                  onChange={(e) => setFormData({...formData, scheduledDate: e.target.value})}
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">Service Type</label>
              <select
                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none bg-white"
                value={formData.serviceType}
                onChange={(e) => setFormData({...formData, serviceType: e.target.value})}
              >
                <option value="standard">Standard Clean</option>
                <option value="deep">Deep Clean</option>
                <option value="move-in-out">Move In/Out</option>
                <option value="commercial">Commercial</option>
              </select>
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Price Estimate</label>
            <div className="relative">
              <DollarSign className="absolute left-3 top-2.5 text-slate-400" size={18} />
              <input
                type="number"
                min="0"
                step="0.01"
                placeholder="0.00"
                className="w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
                value={formData.price}
                onChange={(e) => setFormData({...formData, price: e.target.value})}
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Internal Notes</label>
            <textarea
              className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
              rows="3"
              placeholder="Gate code, pets, special instructions..."
              value={formData.notes}
              onChange={(e) => setFormData({...formData, notes: e.target.value})}
            ></textarea>
          </div>

          <div className="flex justify-end gap-3 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg font-medium"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-4 py-2 bg-brand-600 text-white rounded-lg font-medium hover:bg-brand-700 flex items-center gap-2 disabled:opacity-50"
            >
              {loading ? <Loader className="animate-spin" size={18} /> : <Save size={18} />}
              Schedule Job
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default JobFormModal;
EOF

echo "📝 Writing src/components/jobs/JobListMobile.jsx..."
cat << 'EOF' > src/components/jobs/JobListMobile.jsx
import React from 'react';
import { Calendar, Clock, DollarSign, MapPin } from 'lucide-react';
import { format } from 'date-fns';

const JobListMobile = ({ jobs, clients }) => {
  // Helper to find client name
  const getClientName = (id) => clients.find(c => c.id === id)?.name || 'Unknown Client';
  const getClientAddress = (id) => clients.find(c => c.id === id)?.address;

  if (jobs.length === 0) {
    return (
      <div className="text-center py-10 bg-white rounded-xl border border-gray-100">
        <p className="text-gray-500">No upcoming jobs.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:hidden">
      {jobs.map((job) => (
        <div key={job.id} className="bg-white p-4 rounded-xl shadow-sm border border-gray-100">
          <div className="flex justify-between items-start mb-2">
            <div>
              <h3 className="font-bold text-slate-800 text-lg">{getClientName(job.clientId)}</h3>
              <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-blue-50 text-blue-700 capitalize mt-1">
                {job.serviceType}
              </span>
            </div>
            <div className="text-right">
              <span className={`text-xs font-bold px-2 py-1 rounded-full ${
                job.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'
              }`}>
                {job.status}
              </span>
            </div>
          </div>
          
          <div className="space-y-2 text-sm text-slate-600 mt-3">
            <div className="flex items-center gap-2">
              <Calendar size={16} className="text-brand-500 shrink-0" />
              <span className="font-medium text-slate-900">
                {job.scheduledDate ? format(job.scheduledDate, 'MMM d, yyyy') : 'No Date'}
              </span>
            </div>
            <div className="flex items-center gap-2">
              <Clock size={16} className="text-brand-500 shrink-0" />
              <span>
                {job.scheduledDate ? format(job.scheduledDate, 'h:mm a') : 'TBD'}
              </span>
            </div>
            {getClientAddress(job.clientId) && (
               <div className="flex items-start gap-2">
                 <MapPin size={16} className="text-brand-500 shrink-0 mt-0.5" />
                 <span className="truncate">{getClientAddress(job.clientId)}</span>
               </div>
            )}
             {job.price > 0 && (
               <div className="flex items-center gap-2 text-slate-500">
                 <DollarSign size={16} className="text-slate-400 shrink-0" />
                 <span>${job.price}</span>
               </div>
            )}
          </div>
        </div>
      ))}
    </div>
  );
};

export default JobListMobile;
EOF

echo "📝 Writing src/components/jobs/JobTableDesktop.jsx..."
cat << 'EOF' > src/components/jobs/JobTableDesktop.jsx
import React from 'react';
import { MoreHorizontal, Calendar, Clock, MapPin } from 'lucide-react';
import { format } from 'date-fns';

const JobTableDesktop = ({ jobs, clients }) => {
  const getClient = (id) => clients.find(c => c.id === id) || {};

  if (jobs.length === 0) {
    return (
      <div className="hidden md:block bg-white p-12 text-center rounded-xl border border-gray-200">
        <p className="text-gray-500">No upcoming jobs.</p>
      </div>
    );
  }

  return (
    <div className="hidden md:block bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <table className="w-full text-left border-collapse">
        <thead>
          <tr className="bg-gray-50 border-b border-gray-200 text-xs uppercase text-gray-500 font-semibold">
            <th className="px-6 py-4">Scheduled Date</th>
            <th className="px-6 py-4">Client</th>
            <th className="px-6 py-4">Service</th>
            <th className="px-6 py-4">Status</th>
            <th className="px-6 py-4 text-right">Actions</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100">
          {jobs.map((job) => {
            const client = getClient(job.clientId);
            return (
              <tr key={job.id} className="hover:bg-gray-50 transition-colors">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-2 font-medium text-slate-900">
                    <Calendar size={16} className="text-brand-500" />
                    {job.scheduledDate ? format(job.scheduledDate, 'MMM d, yyyy') : 'TBD'}
                  </div>
                  <div className="flex items-center gap-2 text-xs text-slate-500 mt-1 pl-6">
                    <Clock size={12} />
                    {job.scheduledDate ? format(job.scheduledDate, 'h:mm a') : ''}
                  </div>
                </td>
                <td className="px-6 py-4">
                  <div className="font-medium text-slate-900">{client.name || 'Unknown'}</div>
                  <div className="flex items-center gap-1 text-xs text-slate-400 mt-0.5">
                    <MapPin size={12} />
                    <span className="truncate max-w-[150px]">{client.address || 'No address'}</span>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <span className="capitalize text-sm text-slate-700">{job.serviceType}</span>
                  {job.price > 0 && <div className="text-xs text-slate-400">${job.price}</div>}
                </td>
                <td className="px-6 py-4">
                  <span className={`text-xs font-bold px-2 py-1 rounded-full ${
                    job.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'
                  }`}>
                    {job.status.toUpperCase()}
                  </span>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="text-slate-400 hover:text-brand-600 p-2">
                    <MoreHorizontal size={20} />
                  </button>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};

export default JobTableDesktop;
EOF

# 4. Create the Page Container
echo "📝 Writing src/pages/JobsPage.jsx..."
cat << 'EOF' > src/pages/JobsPage.jsx
import React, { useState } from 'react';
import { Plus, Search, Filter } from 'lucide-react';
import { useJobs } from '../hooks/useJobs';
import { useClients } from '../hooks/useClients'; // Required for dropdown & joins
import JobListMobile from '../components/jobs/JobListMobile';
import JobTableDesktop from '../components/jobs/JobTableDesktop';
import JobFormModal from '../components/jobs/JobFormModal';

const JobsPage = () => {
  const { jobs, loading: jobsLoading, error: jobsError, addJob } = useJobs();
  const { clients, loading: clientsLoading } = useClients(); // Fetch clients to populate UI
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const loading = jobsLoading || clientsLoading;

  // Simple filtering
  const filteredJobs = jobs.filter(job => {
    // Find client name for search
    const clientName = clients.find(c => c.id === job.clientId)?.name?.toLowerCase() || '';
    return clientName.includes(searchTerm.toLowerCase());
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Job Management</h1>
          <p className="text-slate-500 text-sm">Schedule and track cleaning appointments</p>
        </div>
        
        <div className="flex gap-3">
          <div className="relative flex-1 md:w-64">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
            <input 
              type="text"
              placeholder="Search by client..."
              className="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
          <button 
            onClick={() => setIsModalOpen(true)}
            className="bg-brand-600 text-white px-4 py-2 rounded-lg font-semibold hover:bg-brand-700 flex items-center gap-2 shadow-sm whitespace-nowrap"
          >
            <Plus size={20} />
            <span className="hidden md:inline">New Job</span>
            <span className="md:hidden">New</span>
          </button>
        </div>
      </div>

      {/* Content */}
      {loading ? (
        <div className="flex justify-center py-12">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-brand-600"></div>
        </div>
      ) : jobsError ? (
        <div className="bg-red-50 text-red-600 p-4 rounded-lg border border-red-100">
          Error: {jobsError}
        </div>
      ) : (
        <>
          <JobListMobile jobs={filteredJobs} clients={clients} />
          <JobTableDesktop jobs={filteredJobs} clients={clients} />
        </>
      )}

      {/* Modals */}
      <JobFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={addJob}
        clients={clients} 
      />
    </div>
  );
};

export default JobsPage;
EOF

# 5. Update Navigation & Routing
echo "📝 Updating Navigation to include Jobs..."

# Sidebar: Add "Jobs" link
cat << 'EOF' > src/components/layout/Sidebar.jsx
import React from 'react';
import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Calendar, Users, Settings, LogOut, Briefcase } from 'lucide-react';
import { signOut } from 'firebase/auth';
import { auth } from '../../lib/firebase';

const Sidebar = () => {
  const navItems = [
    { icon: LayoutDashboard, label: 'Dashboard', path: '/' },
    { icon: Briefcase, label: 'Jobs', path: '/jobs' },
    { icon: Calendar, label: 'Schedule', path: '/schedule' },
    { icon: Users, label: 'Clients', path: '/clients' },
    { icon: Settings, label: 'Settings', path: '/settings' },
  ];

  const handleSignOut = async () => {
    try {
      await signOut(auth);
    } catch (error) {
      console.error("Error signing out:", error);
    }
  };

  return (
    <aside className="hidden md:flex flex-col w-64 bg-slate-800 text-white h-screen fixed left-0 top-0">
      <div className="p-6">
        <h1 className="text-2xl font-bold text-brand-500">Fresh Nest</h1>
        <p className="text-xs text-slate-400">Operations Manager</p>
      </div>
      
      <nav className="flex-1 px-4 space-y-2">
        {navItems.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            className={({ isActive }) =>
              `flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${
                isActive ? 'bg-brand-600 text-white' : 'text-slate-300 hover:bg-slate-700'
              }`
            }
          >
            <item.icon size={20} />
            <span>{item.label}</span>
          </NavLink>
        ))}
      </nav>

      <div className="p-4 border-t border-slate-700">
        <button 
          onClick={handleSignOut}
          className="flex items-center gap-3 px-4 py-2 text-slate-300 hover:text-white w-full hover:bg-slate-700 rounded-lg transition-colors"
        >
          <LogOut size={20} />
          <span>Sign Out</span>
        </button>
      </div>
    </aside>
  );
};

export default Sidebar;
EOF

# BottomNav: Update "Jobs" to point to /jobs
cat << 'EOF' > src/components/layout/BottomNav.jsx
import React from 'react';
import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Calendar, Users, Menu, Briefcase } from 'lucide-react';

const BottomNav = () => {
  return (
    <nav className="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-6 py-3 flex justify-between items-center z-50">
      <NavLink 
        to="/" 
        className={({ isActive }) => `flex flex-col items-center gap-1 ${isActive ? 'text-brand-600' : 'text-gray-400'}`}
      >
        <LayoutDashboard size={24} />
        <span className="text-xs">Dash</span>
      </NavLink>

      <NavLink 
        to="/jobs" 
        className={({ isActive }) => `flex flex-col items-center gap-1 ${isActive ? 'text-brand-600' : 'text-gray-400'}`}
      >
        <Briefcase size={24} />
        <span className="text-xs">Jobs</span>
      </NavLink>

      <NavLink 
        to="/schedule" 
        className={({ isActive }) => `flex flex-col items-center gap-1 ${isActive ? 'text-brand-600' : 'text-gray-400'}`}
      >
        <Calendar size={24} />
        <span className="text-xs">Schedule</span>
      </NavLink>

      <NavLink 
        to="/clients" 
        className={({ isActive }) => `flex flex-col items-center gap-1 ${isActive ? 'text-brand-600' : 'text-gray-400'}`}
      >
        <Users size={24} />
        <span className="text-xs">Clients</span>
      </NavLink>

      <button className="flex flex-col items-center gap-1 text-gray-400">
        <Menu size={24} />
        <span className="text-xs">More</span>
      </button>
    </nav>
  );
};

export default BottomNav;
EOF

# App.jsx: Add Route
cat << 'EOF' > src/App.jsx
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
EOF

echo "✅ SUCCESS! Job Management Module installed."