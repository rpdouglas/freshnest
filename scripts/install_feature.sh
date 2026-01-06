#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE INSTALLER
# Feature: Client Management Module
# Approach: Robust (Hook + Components + Page)
# ====================================================

echo "🚀 Installing Client Management Feature..."

# 1. Create Directories
mkdir -p src/hooks
mkdir -p src/pages
mkdir -p src/components/clients

# 2. Create the Custom Hook (Logic Layer)
echo "📝 Writing src/hooks/useClients.js..."
cat << 'EOF' > src/hooks/useClients.js
import { useState, useEffect } from 'react';
import { 
  collection, 
  query, 
  where, 
  onSnapshot, 
  addDoc, 
  serverTimestamp,
  orderBy 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useClients = () => {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    // Get the orgId from the token claims (stored in local state or refetch)
    // For now, we assume the user object is hydrated or we fetch the token result.
    // In a robust app, we'd use a generic AuthContext, but here we access the ID token.
    user.getIdTokenResult().then((idTokenResult) => {
      const orgId = idTokenResult.claims.orgId;

      if (!orgId) {
        setError("Organization ID missing from user profile.");
        setLoading(false);
        return;
      }

      // SECURITY: Subscribe ONLY to clients in this user's Org
      const q = query(
        collection(db, 'clients'),
        where('orgId', '==', orgId),
        orderBy('createdAt', 'desc')
      );

      const unsubscribe = onSnapshot(q, (snapshot) => {
        const clientData = snapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        setClients(clientData);
        setLoading(false);
      }, (err) => {
        console.error("Error fetching clients:", err);
        setError("Failed to load clients.");
        setLoading(false);
      });

      return () => unsubscribe();
    });
  }, []);

  const addClient = async (clientData) => {
    const user = auth.currentUser;
    if (!user) throw new Error("Not authenticated");

    const idTokenResult = await user.getIdTokenResult();
    const orgId = idTokenResult.claims.orgId;

    if (!orgId) throw new Error("No Organization ID found.");

    // SECURITY: Force attach orgId and server timestamp
    await addDoc(collection(db, 'clients'), {
      ...clientData,
      orgId, 
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    });
  };

  return { clients, loading, error, addClient };
};
EOF

# 3. Create Components (UI Layer)

echo "📝 Writing src/components/clients/ClientFormModal.jsx..."
cat << 'EOF' > src/components/clients/ClientFormModal.jsx
import React, { useState } from 'react';
import { X, Save, Loader } from 'lucide-react';

const ClientFormModal = ({ isOpen, onClose, onSave }) => {
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    address: ''
  });

  if (!isOpen) return null;

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      await onSave(formData);
      setFormData({ name: '', email: '', phone: '', address: '' }); // Reset
      onClose();
    } catch (error) {
      console.error(error);
      alert("Failed to save client. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
      <div className="bg-white rounded-xl shadow-xl w-full max-w-lg overflow-hidden">
        
        {/* Header */}
        <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
          <h3 className="font-bold text-lg text-slate-800">Add New Client</h3>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
            <X size={24} />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Client Name *</label>
            <input
              type="text"
              required
              className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
              value={formData.name}
              onChange={(e) => setFormData({...formData, name: e.target.value})}
            />
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">Email</label>
              <input
                type="email"
                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
                value={formData.email}
                onChange={(e) => setFormData({...formData, email: e.target.value})}
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">Phone</label>
              <input
                type="tel"
                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
                value={formData.phone}
                onChange={(e) => setFormData({...formData, phone: e.target.value})}
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Address</label>
            <textarea
              className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
              rows="3"
              value={formData.address}
              onChange={(e) => setFormData({...formData, address: e.target.value})}
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
              Save Client
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ClientFormModal;
EOF

echo "📝 Writing src/components/clients/ClientListMobile.jsx..."
cat << 'EOF' > src/components/clients/ClientListMobile.jsx
import React from 'react';
import { MapPin, Phone, Mail } from 'lucide-react';

const ClientListMobile = ({ clients }) => {
  if (clients.length === 0) {
    return (
      <div className="text-center py-10 bg-white rounded-xl border border-gray-100">
        <p className="text-gray-500">No clients found.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:hidden">
      {clients.map((client) => (
        <div key={client.id} className="bg-white p-4 rounded-xl shadow-sm border border-gray-100">
          <div className="flex justify-between items-start mb-2">
            <h3 className="font-bold text-slate-800 text-lg">{client.name}</h3>
          </div>
          
          <div className="space-y-2 text-sm text-slate-600">
            {client.address && (
              <div className="flex items-start gap-2">
                <MapPin size={16} className="text-brand-500 shrink-0 mt-0.5" />
                <span>{client.address}</span>
              </div>
            )}
            
            <div className="flex gap-3 mt-3 pt-3 border-t border-gray-50">
              {client.phone && (
                <a 
                  href={`tel:${client.phone}`}
                  className="flex-1 flex items-center justify-center gap-2 py-2 bg-green-50 text-green-700 rounded-lg font-medium text-xs active:bg-green-100"
                >
                  <Phone size={14} /> Call
                </a>
              )}
              {client.email && (
                <a 
                  href={`mailto:${client.email}`}
                  className="flex-1 flex items-center justify-center gap-2 py-2 bg-blue-50 text-blue-700 rounded-lg font-medium text-xs active:bg-blue-100"
                >
                  <Mail size={14} /> Email
                </a>
              )}
            </div>
          </div>
        </div>
      ))}
    </div>
  );
};

export default ClientListMobile;
EOF

echo "📝 Writing src/components/clients/ClientTableDesktop.jsx..."
cat << 'EOF' > src/components/clients/ClientTableDesktop.jsx
import React from 'react';
import { MapPin, Phone, Mail, MoreHorizontal } from 'lucide-react';

const ClientTableDesktop = ({ clients }) => {
  if (clients.length === 0) {
    return (
      <div className="hidden md:block bg-white p-12 text-center rounded-xl border border-gray-200">
        <p className="text-gray-500">No clients found. Add one to get started.</p>
      </div>
    );
  }

  return (
    <div className="hidden md:block bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <table className="w-full text-left border-collapse">
        <thead>
          <tr className="bg-gray-50 border-b border-gray-200 text-xs uppercase text-gray-500 font-semibold">
            <th className="px-6 py-4">Client Name</th>
            <th className="px-6 py-4">Contact Info</th>
            <th className="px-6 py-4">Address</th>
            <th className="px-6 py-4 text-right">Actions</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100">
          {clients.map((client) => (
            <tr key={client.id} className="hover:bg-gray-50 transition-colors">
              <td className="px-6 py-4">
                <div className="font-medium text-slate-900">{client.name}</div>
                <div className="text-xs text-slate-400">ID: {client.id.slice(0,8)}...</div>
              </td>
              <td className="px-6 py-4">
                <div className="flex flex-col gap-1 text-sm text-slate-600">
                  {client.phone && (
                    <div className="flex items-center gap-2">
                      <Phone size={14} className="text-slate-400" />
                      {client.phone}
                    </div>
                  )}
                  {client.email && (
                    <div className="flex items-center gap-2">
                      <Mail size={14} className="text-slate-400" />
                      {client.email}
                    </div>
                  )}
                </div>
              </td>
              <td className="px-6 py-4">
                <div className="flex items-start gap-2 text-sm text-slate-600 max-w-[200px]">
                  <MapPin size={14} className="text-slate-400 shrink-0 mt-0.5" />
                  <span className="truncate">{client.address}</span>
                </div>
              </td>
              <td className="px-6 py-4 text-right">
                <button className="text-slate-400 hover:text-brand-600 p-2">
                  <MoreHorizontal size={20} />
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ClientTableDesktop;
EOF

# 4. Create the Page Container
echo "📝 Writing src/pages/ClientsPage.jsx..."
cat << 'EOF' > src/pages/ClientsPage.jsx
import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useClients } from '../hooks/useClients';
import ClientListMobile from '../components/clients/ClientListMobile';
import ClientTableDesktop from '../components/clients/ClientTableDesktop';
import ClientFormModal from '../components/clients/ClientFormModal';

const ClientsPage = () => {
  const { clients, loading, error, addClient } = useClients();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  // Client-side filtering
  const filteredClients = clients.filter(c => 
    c.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    c.email?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
      {/* Header & Actions */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Clients</h1>
          <p className="text-slate-500 text-sm">Manage your residential and commercial customers</p>
        </div>
        
        <div className="flex gap-3">
          <div className="relative flex-1 md:w-64">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
            <input 
              type="text"
              placeholder="Search clients..."
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
            <span className="hidden md:inline">Add Client</span>
            <span className="md:hidden">Add</span>
          </button>
        </div>
      </div>

      {/* Content */}
      {loading ? (
        <div className="flex justify-center py-12">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-brand-600"></div>
        </div>
      ) : error ? (
        <div className="bg-red-50 text-red-600 p-4 rounded-lg border border-red-100">
          Error: {error}
        </div>
      ) : (
        <>
          <ClientListMobile clients={filteredClients} />
          <ClientTableDesktop clients={filteredClients} />
        </>
      )}

      {/* Modals */}
      <ClientFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={addClient}
      />
    </div>
  );
};

export default ClientsPage;
EOF

# 5. Update Navigation & Routing
echo "📝 Updating Routing and Navigation..."

# Overwriting App.jsx to add the route
cat << 'EOF' > src/App.jsx
import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import AppLayout from './components/layout/AppLayout';
import AuthGuard from './components/layout/AuthGuard';
import LoginPage from './features/auth/LoginPage';
import ClientsPage from './pages/ClientsPage';
import DebugClaims from './components/debug/DebugClaims';

// Placeholder Pages
const Dashboard = () => (
  <div>
    <h2 className="text-2xl font-bold mb-4">My Jobs Today</h2>
    <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
      <p className="text-gray-500">No jobs scheduled yet.</p>
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
          <Route path="schedule" element={<Schedule />} />
          <Route path="clients" element={<ClientsPage />} />
          {/* Catch-all redirects to home */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
EOF

# Updating Sidebar to highlight Clients
cat << 'EOF' > src/components/layout/Sidebar.jsx
import React from 'react';
import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Calendar, Users, Settings, LogOut } from 'lucide-react';

const Sidebar = () => {
  const navItems = [
    { icon: LayoutDashboard, label: 'Dashboard', path: '/' },
    { icon: Calendar, label: 'Schedule', path: '/schedule' },
    { icon: Users, label: 'Clients', path: '/clients' },
    { icon: Settings, label: 'Settings', path: '/settings' },
  ];

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
        <button className="flex items-center gap-3 px-4 py-2 text-slate-300 hover:text-white w-full">
          <LogOut size={20} />
          <span>Sign Out</span>
        </button>
      </div>
    </aside>
  );
};

export default Sidebar;
EOF

# Updating BottomNav to include Clients
cat << 'EOF' > src/components/layout/BottomNav.jsx
import React from 'react';
import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Calendar, Users, Menu } from 'lucide-react';

const BottomNav = () => {
  return (
    <nav className="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-6 py-3 flex justify-between items-center z-50">
      <NavLink 
        to="/" 
        className={({ isActive }) => `flex flex-col items-center gap-1 ${isActive ? 'text-brand-600' : 'text-gray-400'}`}
      >
        <LayoutDashboard size={24} />
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

echo "✅ SUCCESS! Client Management Module installed."