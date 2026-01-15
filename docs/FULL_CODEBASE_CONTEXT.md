# FRESH NEST: CODEBASE DUMP
**Date:** Wed Jan 14 21:43:04 EST 2026
**Description:** Complete codebase context.

## FILE: package.json
```json
{
  "name": "fresh-nest",
  "private": true,
  "version": "0.2.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint .",
    "preview": "vite preview"
  },
  "dependencies": {
    "@react-google-maps/api": "^2.20.8",
    "@react-pdf/renderer": "^4.3.2",
    "clsx": "^2.1.1",
    "date-fns": "^4.1.0",
    "firebase": "^12.7.0",
    "firebase-admin": "^13.6.0",
    "lucide-react": "^0.562.0",
    "react": "^19.2.0",
    "react-dom": "^19.2.0",
    "react-router-dom": "^7.11.0",
    "recharts": "^3.6.0",
    "tailwind-merge": "^3.4.0",
    "uuid": "^13.0.0"
  },
  "devDependencies": {
    "@eslint/js": "^9.39.1",
    "@types/react": "^19.2.5",
    "@types/react-dom": "^19.2.3",
    "@vitejs/plugin-react": "^5.1.1",
    "autoprefixer": "^10.4.17",
    "eslint": "^9.39.1",
    "eslint-plugin-react-hooks": "^7.0.1",
    "eslint-plugin-react-refresh": "^0.4.24",
    "firebase-tools": "^15.1.0",
    "globals": "^16.5.0",
    "postcss": "^8.4.35",
    "tailwindcss": "^3.4.1",
    "vite": "^7.2.4"
  }
}

```
---

## FILE: vite.config.js
```js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { execSync } from 'child_process';
import pkg from './package.json';

// 1. Get Git Hash
let commitHash = 'unknown';
try {
  commitHash = execSync('git rev-parse --short HEAD').toString().trim();
} catch (e) {
  console.warn('Git hash not found (not a git repo?)');
}

// 2. Get Environment (from CI/CD or .env)
// Note: VITE_APP_ENV is injected by our GitHub Actions
const appEnv = process.env.VITE_APP_ENV || 'local';

// 3. Format Version String
// e.g. "v1.2.0 (dev)" or "v1.2.0" for prod
const displayVersion = appEnv === 'production' 
  ? pkg.version 
  : `${pkg.version}-${appEnv}`;

export default defineConfig({
  plugins: [react()],
  define: {
    // Inject these global constants
    __APP_VERSION__: JSON.stringify(displayVersion),
    __COMMIT_HASH__: JSON.stringify(commitHash),
    __BUILD_DATE__: JSON.stringify(new Date().toISOString().split('T')[0]),
    __ENV_NAME__: JSON.stringify(appEnv),
  }
})

```
---

## FILE: tailwind.config.js
```js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          500: '#0ea5e9', // Sky Blue (Primary)
          600: '#0284c7',
          900: '#0c4a6e',
        },
        slate: {
          800: '#1e293b', 
        }
      }
    },
  },
  plugins: [],
}

```
---

## FILE: firebase.json
```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "hosting": {
    "public": "dist",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}

```
---

## FILE: .firebaserc
```firebaserc
{
  "projects": {
    "default": "fresh-nest-dev",
    "dev": "fresh-nest-dev",
    "uat": "fresh-nest-uat",
    "prod": "fresh-nest-prod"
  }
}

```
---

## FILE: src/App.css
```css
#root {
  max-width: 1280px;
  margin: 0 auto;
  padding: 2rem;
  text-align: center;
}

.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.react:hover {
  filter: drop-shadow(0 0 2em #61dafbaa);
}

@keyframes logo-spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

@media (prefers-reduced-motion: no-preference) {
  a:nth-of-type(2) .logo {
    animation: logo-spin infinite 20s linear;
  }
}

.card {
  padding: 2em;
}

.read-the-docs {
  color: #888;
}

```
---

## FILE: src/App.jsx
```jsx
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

```
---

## FILE: src/assets/react.svg
```svg
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" role="img" class="iconify iconify--logos" width="35.93" height="32" preserveAspectRatio="xMidYMid meet" viewBox="0 0 256 228"><path fill="#00D8FF" d="M210.483 73.824a171.49 171.49 0 0 0-8.24-2.597c.465-1.9.893-3.777 1.273-5.621c6.238-30.281 2.16-54.676-11.769-62.708c-13.355-7.7-35.196.329-57.254 19.526a171.23 171.23 0 0 0-6.375 5.848a155.866 155.866 0 0 0-4.241-3.917C100.759 3.829 77.587-4.822 63.673 3.233C50.33 10.957 46.379 33.89 51.995 62.588a170.974 170.974 0 0 0 1.892 8.48c-3.28.932-6.445 1.924-9.474 2.98C17.309 83.498 0 98.307 0 113.668c0 15.865 18.582 31.778 46.812 41.427a145.52 145.52 0 0 0 6.921 2.165a167.467 167.467 0 0 0-2.01 9.138c-5.354 28.2-1.173 50.591 12.134 58.266c13.744 7.926 36.812-.22 59.273-19.855a145.567 145.567 0 0 0 5.342-4.923a168.064 168.064 0 0 0 6.92 6.314c21.758 18.722 43.246 26.282 56.54 18.586c13.731-7.949 18.194-32.003 12.4-61.268a145.016 145.016 0 0 0-1.535-6.842c1.62-.48 3.21-.974 4.76-1.488c29.348-9.723 48.443-25.443 48.443-41.52c0-15.417-17.868-30.326-45.517-39.844Zm-6.365 70.984c-1.4.463-2.836.91-4.3 1.345c-3.24-10.257-7.612-21.163-12.963-32.432c5.106-11 9.31-21.767 12.459-31.957c2.619.758 5.16 1.557 7.61 2.4c23.69 8.156 38.14 20.213 38.14 29.504c0 9.896-15.606 22.743-40.946 31.14Zm-10.514 20.834c2.562 12.94 2.927 24.64 1.23 33.787c-1.524 8.219-4.59 13.698-8.382 15.893c-8.067 4.67-25.32-1.4-43.927-17.412a156.726 156.726 0 0 1-6.437-5.87c7.214-7.889 14.423-17.06 21.459-27.246c12.376-1.098 24.068-2.894 34.671-5.345a134.17 134.17 0 0 1 1.386 6.193ZM87.276 214.515c-7.882 2.783-14.16 2.863-17.955.675c-8.075-4.657-11.432-22.636-6.853-46.752a156.923 156.923 0 0 1 1.869-8.499c10.486 2.32 22.093 3.988 34.498 4.994c7.084 9.967 14.501 19.128 21.976 27.15a134.668 134.668 0 0 1-4.877 4.492c-9.933 8.682-19.886 14.842-28.658 17.94ZM50.35 144.747c-12.483-4.267-22.792-9.812-29.858-15.863c-6.35-5.437-9.555-10.836-9.555-15.216c0-9.322 13.897-21.212 37.076-29.293c2.813-.98 5.757-1.905 8.812-2.773c3.204 10.42 7.406 21.315 12.477 32.332c-5.137 11.18-9.399 22.249-12.634 32.792a134.718 134.718 0 0 1-6.318-1.979Zm12.378-84.26c-4.811-24.587-1.616-43.134 6.425-47.789c8.564-4.958 27.502 2.111 47.463 19.835a144.318 144.318 0 0 1 3.841 3.545c-7.438 7.987-14.787 17.08-21.808 26.988c-12.04 1.116-23.565 2.908-34.161 5.309a160.342 160.342 0 0 1-1.76-7.887Zm110.427 27.268a347.8 347.8 0 0 0-7.785-12.803c8.168 1.033 15.994 2.404 23.343 4.08c-2.206 7.072-4.956 14.465-8.193 22.045a381.151 381.151 0 0 0-7.365-13.322Zm-45.032-43.861c5.044 5.465 10.096 11.566 15.065 18.186a322.04 322.04 0 0 0-30.257-.006c4.974-6.559 10.069-12.652 15.192-18.18ZM82.802 87.83a323.167 323.167 0 0 0-7.227 13.238c-3.184-7.553-5.909-14.98-8.134-22.152c7.304-1.634 15.093-2.97 23.209-3.984a321.524 321.524 0 0 0-7.848 12.897Zm8.081 65.352c-8.385-.936-16.291-2.203-23.593-3.793c2.26-7.3 5.045-14.885 8.298-22.6a321.187 321.187 0 0 0 7.257 13.246c2.594 4.48 5.28 8.868 8.038 13.147Zm37.542 31.03c-5.184-5.592-10.354-11.779-15.403-18.433c4.902.192 9.899.29 14.978.29c5.218 0 10.376-.117 15.453-.343c-4.985 6.774-10.018 12.97-15.028 18.486Zm52.198-57.817c3.422 7.8 6.306 15.345 8.596 22.52c-7.422 1.694-15.436 3.058-23.88 4.071a382.417 382.417 0 0 0 7.859-13.026a347.403 347.403 0 0 0 7.425-13.565Zm-16.898 8.101a358.557 358.557 0 0 1-12.281 19.815a329.4 329.4 0 0 1-23.444.823c-7.967 0-15.716-.248-23.178-.732a310.202 310.202 0 0 1-12.513-19.846h.001a307.41 307.41 0 0 1-10.923-20.627a310.278 310.278 0 0 1 10.89-20.637l-.001.001a307.318 307.318 0 0 1 12.413-19.761c7.613-.576 15.42-.876 23.31-.876H128c7.926 0 15.743.303 23.354.883a329.357 329.357 0 0 1 12.335 19.695a358.489 358.489 0 0 1 11.036 20.54a329.472 329.472 0 0 1-11 20.722Zm22.56-122.124c8.572 4.944 11.906 24.881 6.52 51.026c-.344 1.668-.73 3.367-1.15 5.09c-10.622-2.452-22.155-4.275-34.23-5.408c-7.034-10.017-14.323-19.124-21.64-27.008a160.789 160.789 0 0 1 5.888-5.4c18.9-16.447 36.564-22.941 44.612-18.3ZM128 90.808c12.625 0 22.86 10.235 22.86 22.86s-10.235 22.86-22.86 22.86s-22.86-10.235-22.86-22.86s10.235-22.86 22.86-22.86Z"></path></svg>
```
---

## FILE: src/components/clients/ClientFormModal.jsx
```jsx
import React, { useState } from 'react';
import { X, Save, Loader, MapPin } from 'lucide-react';
import { geocodeAddress } from '../../lib/maps';

const ClientFormModal = ({ isOpen, onClose, onSave }) => {
  const [loading, setLoading] = useState(false);
  const [geoStatus, setGeoStatus] = useState(null); // 'success', 'error', null
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
    setGeoStatus(null);

    try {
      // 1. Attempt Geocoding
      let coordinates = null;
      if (formData.address) {
        coordinates = await geocodeAddress(formData.address);
        if (!coordinates) {
          const confirmSave = window.confirm("⚠️ We couldn't find this address on the map. Save anyway?");
          if (!confirmSave) {
            setLoading(false);
            return;
          }
        }
      }

      // 2. Save Client with Coords
      await onSave({ ...formData, coordinates });
      
      // 3. Reset & Close
      setFormData({ name: '', email: '', phone: '', address: '' });
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
            <label className="block text-sm font-medium text-slate-700 mb-1">Address (For Map)</label>
            <div className="relative">
              <MapPin className="absolute left-3 top-2.5 text-slate-400" size={18} />
              <textarea
                className="w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
                rows="2"
                placeholder="123 Main St, City, Province"
                value={formData.address}
                onChange={(e) => setFormData({...formData, address: e.target.value})}
              ></textarea>
            </div>
            <p className="text-xs text-slate-500 mt-1">We will try to auto-locate this on the map.</p>
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

```
---

## FILE: src/components/clients/ClientListMobile.jsx
```jsx
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

```
---

## FILE: src/components/clients/ClientTableDesktop.jsx
```jsx
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

```
---

## FILE: src/components/common/ExportButton.jsx
```jsx
import React from 'react';
import { Download } from 'lucide-react';
import { generateCSV, downloadCSV } from '../../lib/csv';

const ExportButton = ({ data, filename, headers, role }) => {
  // Security: Render nothing if not Admin
  if (role !== 'admin') return null;

  const handleExport = () => {
    const csv = generateCSV(data, headers);
    downloadCSV(csv, `${filename}_${new Date().toISOString().split('T')[0]}.csv`);
  };

  return (
    <button
      onClick={handleExport}
      className="hidden md:flex items-center gap-2 px-4 py-2 border border-slate-300 text-slate-700 font-medium rounded-lg hover:bg-slate-50 transition-colors"
      title="Export to CSV"
    >
      <Download size={18} />
      <span>Export</span>
    </button>
  );
};

export default ExportButton;

```
---

## FILE: src/components/dashboard/AdminDashboard.jsx
```jsx
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

```
---

## FILE: src/components/dashboard/KPICard.jsx
```jsx
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

```
---

## FILE: src/components/dashboard/RevenueChart.jsx
```jsx
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

```
---

## FILE: src/components/dashboard/StaffDashboard.jsx
```jsx
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

```
---

## FILE: src/components/debug/DebugClaims.jsx
```jsx
import React, { useEffect, useState } from 'react';
// IMPORT FROM YOUR LIB, NOT THE SDK DIRECTLY
import { auth } from '../../lib/firebase'; 

const DebugClaims = () => {
  const [claims, setClaims] = useState(null);
  const [env, setEnv] = useState(import.meta.env.VITE_APP_ENV);

  useEffect(() => {
    const checkClaims = async () => {
      // Use the 'auth' instance we imported
      const user = auth.currentUser;
      if (user) {
        // Force refresh to get latest claims
        const tokenResult = await user.getIdTokenResult(true);
        setClaims(tokenResult.claims);
      }
    };

    // Check immediately and also set up a listener
    const unsubscribe = auth.onAuthStateChanged((user) => {
      if (user) {
        checkClaims();
      } else {
        setClaims(null);
      }
    });

    return () => unsubscribe();
  }, []);

  return (
    <div className="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded text-xs text-yellow-800 font-mono overflow-auto">
      <p className="mb-2"><strong>Environment:</strong> {env?.toUpperCase()}</p>
      {claims ? (
        <pre>{JSON.stringify(claims, null, 2)}</pre>
      ) : (
        <p>No User Signed In / No Claims Found</p>
      )}
    </div>
  );
};

export default DebugClaims;

```
---

## FILE: src/components/invoicing/InvoiceDocument.jsx
```jsx
import React from 'react';
import { Page, Text, View, Document, StyleSheet } from '@react-pdf/renderer';
import { format } from 'date-fns';

// Define styles
const styles = StyleSheet.create({
  page: {
    padding: 40,
    fontSize: 12,
    fontFamily: 'Helvetica',
    color: '#333'
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 40,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
    paddingBottom: 20
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#0ea5e9' // Brand Blue
  },
  section: {
    marginBottom: 20
  },
  label: {
    fontSize: 10,
    color: '#666',
    marginBottom: 4,
    textTransform: 'uppercase'
  },
  value: {
    fontSize: 12,
    marginBottom: 8
  },
  table: {
    marginTop: 40,
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderBottomColor: '#333',
    paddingBottom: 8
  },
  total: {
    marginTop: 20,
    textAlign: 'right',
    fontSize: 18,
    fontWeight: 'bold'
  },
  footer: {
    position: 'absolute',
    bottom: 30,
    left: 40,
    right: 40,
    fontSize: 10,
    textAlign: 'center',
    color: '#999'
  }
});

const InvoiceDocument = ({ job, client }) => {
  const invoiceNum = job.invoiceNumber || 'DRAFT';
  const date = job.invoicedAt ? format(job.invoicedAt, 'MMM d, yyyy') : format(new Date(), 'MMM d, yyyy');

  return (
    <Document>
      <Page size="A4" style={styles.page}>
        
        {/* HEADER */}
        <View style={styles.header}>
          <View>
            <Text style={styles.title}>INVOICE</Text>
            <Text style={styles.label}>#{invoiceNum}</Text>
          </View>
          <View style={{ alignItems: 'flex-end' }}>
            <Text style={{ fontSize: 16, fontWeight: 'bold' }}>Fresh Nest</Text>
            <Text style={styles.label}>Date: {date}</Text>
          </View>
        </View>

        {/* BILL TO */}
        <View style={styles.section}>
          <Text style={styles.label}>Bill To:</Text>
          <Text style={{ fontSize: 14, fontWeight: 'bold' }}>{client.name}</Text>
          <Text style={styles.value}>{client.email}</Text>
          <Text style={styles.value}>{client.address}</Text>
        </View>

        {/* DETAILS */}
        <View style={styles.table}>
          <Text style={{ width: '60%' }}>Description</Text>
          <Text style={{ width: '20%', textAlign: 'right' }}>Date</Text>
          <Text style={{ width: '20%', textAlign: 'right' }}>Amount</Text>
        </View>

        <View style={{ flexDirection: 'row', paddingTop: 10 }}>
          <Text style={{ width: '60%' }}>
            {job.serviceType.charAt(0).toUpperCase() + job.serviceType.slice(1)} Cleaning Service
          </Text>
          <Text style={{ width: '20%', textAlign: 'right' }}>
            {job.scheduledDate ? format(job.scheduledDate, 'MMM d') : ''}
          </Text>
          <Text style={{ width: '20%', textAlign: 'right' }}>
            ${job.price?.toFixed(2)}
          </Text>
        </View>

        {/* TOTAL */}
        <Text style={styles.total}>
          Total Due: ${job.price?.toFixed(2)}
        </Text>

        {/* FOOTER */}
        <Text style={styles.footer}>
          Thank you for choosing Fresh Nest! Please pay within 30 days.
        </Text>
      </Page>
    </Document>
  );
};

export default InvoiceDocument;

```
---

## FILE: src/components/invoicing/InvoiceHTMLPreview.jsx
```jsx
import React from 'react';
import { format } from 'date-fns';

const InvoiceHTMLPreview = ({ job, client }) => {
  const invoiceNum = job.invoiceNumber || 'DRAFT';
  const date = job.invoicedAt ? format(job.invoicedAt, 'MMM d, yyyy') : format(new Date(), 'MMM d, yyyy');

  return (
    <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-sm h-full overflow-y-auto">
      {/* Header */}
      <div className="flex justify-between items-start border-b border-gray-100 pb-4 mb-4">
        <div>
          <h2 className="text-xl font-bold text-brand-600">INVOICE</h2>
          <p className="text-slate-500 font-mono text-xs mt-1">#{invoiceNum}</p>
        </div>
        <div className="text-right">
          <h3 className="font-bold text-slate-800">Fresh Nest</h3>
          <p className="text-slate-500 text-xs">{date}</p>
        </div>
      </div>

      {/* Bill To */}
      <div className="mb-6">
        <h4 className="text-xs font-bold text-slate-400 uppercase mb-2">Bill To</h4>
        <div className="text-slate-800 font-medium">{client.name}</div>
        <div className="text-slate-600 text-xs">{client.email}</div>
        <div className="text-slate-600 text-xs mt-1 max-w-[200px]">{client.address}</div>
      </div>

      {/* Line Items */}
      <div className="mb-6">
        <div className="flex justify-between text-xs font-bold text-slate-400 border-b border-gray-100 pb-2 mb-2">
          <span>Description</span>
          <span>Amount</span>
        </div>
        
        <div className="flex justify-between items-start py-2">
          <div>
            <div className="font-medium text-slate-800 capitalize">
              {job.serviceType} Cleaning Service
            </div>
            <div className="text-xs text-slate-500">
              Date: {job.scheduledDate ? format(job.scheduledDate, 'MMM d, yyyy') : 'N/A'}
            </div>
          </div>
          <div className="font-medium text-slate-800">
            ${job.price?.toFixed(2)}
          </div>
        </div>
      </div>

      {/* Total */}
      <div className="flex justify-end border-t border-gray-200 pt-4 mb-8">
        <div className="text-right">
          <span className="text-slate-500 text-xs mr-4">Total Due:</span>
          <span className="text-xl font-bold text-brand-600">${job.price?.toFixed(2)}</span>
        </div>
      </div>

      {/* Footer */}
      <div className="text-center text-xs text-slate-400 mt-auto pt-8 border-t border-gray-50">
        <p>Thank you for choosing Fresh Nest!</p>
        <p>Please pay within 30 days.</p>
      </div>
    </div>
  );
};

export default InvoiceHTMLPreview;

```
---

## FILE: src/components/invoicing/InvoiceModal.jsx
```jsx
import React, { useEffect, useState } from 'react';
import { X, CheckCircle, Download, FileText } from 'lucide-react';
import { PDFViewer, PDFDownloadLink } from '@react-pdf/renderer';
import InvoiceDocument from './InvoiceDocument';
import InvoiceHTMLPreview from './InvoiceHTMLPreview';

const InvoiceModal = ({ isOpen, onClose, job, client, onMarkInvoiced }) => {
  const [isClientReady, setIsClientReady] = useState(false);
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    setIsClientReady(true);
    const checkMobile = () => setIsMobile(window.innerWidth < 768);
    checkMobile();
    window.addEventListener('resize', checkMobile);
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  if (!isOpen || !job || !client) return null;

  return (
    <div className="fixed inset-0 bg-black/80 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
      <div className="bg-white rounded-xl shadow-2xl w-full max-w-4xl h-[90vh] flex flex-col overflow-hidden">
        
        {/* Header */}
        <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
          <div className="flex items-center gap-3">
            <div className="bg-brand-100 p-2 rounded-lg text-brand-600">
              <FileText size={20} />
            </div>
            <div>
              <h3 className="font-bold text-lg text-slate-800">Invoice Preview</h3>
              <p className="text-xs text-slate-500">Client: {client.name}</p>
            </div>
          </div>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
            <X size={24} />
          </button>
        </div>

        {/* CONTENT AREA */}
        <div className="flex-1 bg-gray-100 p-4 overflow-hidden relative">
          {isClientReady ? (
            isMobile ? (
              // --- MOBILE VIEW (HTML Preview) ---
              <div className="h-full overflow-y-auto">
                <InvoiceHTMLPreview job={job} client={client} />
              </div>
            ) : (
              // --- DESKTOP VIEW (PDF Embed) ---
              <PDFViewer width="100%" height="100%" className="rounded-lg border border-gray-200 shadow-inner">
                <InvoiceDocument job={job} client={client} />
              </PDFViewer>
            )
          ) : (
            <div className="flex items-center justify-center h-full text-slate-400">
              Loading Preview...
            </div>
          )}
        </div>

        {/* Footer Controls */}
        <div className="px-6 py-4 border-t border-gray-100 bg-white flex flex-col md:flex-row justify-between items-center gap-4">
          <div className="text-sm text-slate-500 w-full md:w-auto text-center md:text-left">
            Status: {job.invoicedAt ? (
              <span className="text-green-600 font-medium flex items-center justify-center md:justify-start gap-1">
                <CheckCircle size={14} /> Invoiced ({job.invoiceNumber})
              </span>
            ) : (
              <span className="text-amber-600 font-medium">Draft (Not Sent)</span>
            )}
          </div>

          <div className="flex gap-3 w-full md:w-auto">
            {!job.invoicedAt && (
              <button
                onClick={() => onMarkInvoiced(job.id)}
                className="flex-1 md:flex-none px-4 py-2 text-slate-700 bg-gray-100 hover:bg-gray-200 rounded-lg font-medium flex items-center justify-center gap-2 transition-colors"
              >
                <CheckCircle size={18} />
                <span className="md:inline">Mark Invoiced</span>
              </button>
            )}

            {/* DOWNLOAD BUTTON (Visible on BOTH Mobile & Desktop) */}
            {isClientReady && (
              <PDFDownloadLink
                document={<InvoiceDocument job={job} client={client} />}
                fileName={`Invoice_${client.name.replace(/\s+/g, '_')}.pdf`}
                className="flex-1 md:flex-none px-6 py-2 bg-brand-600 text-white rounded-lg font-bold hover:bg-brand-700 flex items-center justify-center gap-2 transition-colors shadow-sm"
              >
                {({ loading }) => (
                  <>
                    <Download size={18} />
                    {loading ? 'Preparing...' : 'Download PDF'}
                  </>
                )}
              </PDFDownloadLink>
            )}
          </div>
        </div>

      </div>
    </div>
  );
};

export default InvoiceModal;

```
---

## FILE: src/components/jobs/JobCardMobile.jsx
```jsx
import React from 'react';
import { Calendar, Clock, DollarSign, MapPin, User, CheckCircle, Play, Loader, Edit, FileText } from 'lucide-react';
import { format } from 'date-fns';
import { useJobWorkflow } from '../../hooks/useJobWorkflow';

const JobCardMobile = ({ job, getClientName, getClientAddress, getAssignedStaffName, userRole, onEdit, onInvoice }) => {
  const { startJob, completeJob, canStart, canComplete, loading } = useJobWorkflow(job, userRole);

  const assignedName = getAssignedStaffName(job.assignedTo);
  const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;

  const getStatusColor = (s) => {
    switch(s) {
      case 'completed': return 'bg-green-100 text-green-700';
      case 'in_progress': return 'bg-blue-100 text-blue-700';
      case 'cancelled': return 'bg-red-100 text-red-700';
      default: return 'bg-yellow-100 text-yellow-700';
    }
  };

  return (
    <div className="bg-white p-4 rounded-xl shadow-sm border border-gray-100 relative">
      {/* Admin Edit Button */}
      {userRole === 'admin' && (
        <button 
          onClick={() => onEdit(job)}
          className="absolute top-4 right-4 p-1.5 bg-gray-50 rounded-full text-slate-400 hover:text-brand-600 hover:bg-brand-50"
        >
          <Edit size={16} />
        </button>
      )}

      <div className="flex justify-between items-start mb-2 pr-8">
        <div>
          <h3 className="font-bold text-slate-800 text-lg">{getClientName(job.clientId)}</h3>
          <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-slate-600 capitalize mt-1">
            {job.serviceType}
          </span>
        </div>
      </div>
      
      {/* Status Badge */}
      <div className="mb-3">
        <span className={`text-xs font-bold px-2 py-1 rounded-full uppercase ${getStatusColor(job.status)}`}>
          {job.status?.replace('_', ' ')}
        </span>
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
        
        <div className={`flex items-center gap-2 ${isUnassigned ? 'text-slate-400 italic' : 'text-slate-700 font-medium'}`}>
          <User size={16} className={isUnassigned ? "text-slate-300" : "text-brand-500"} />
          <span>{assignedName}</span>
        </div>

        {getClientAddress(job.clientId) && (
          <div className="flex items-start gap-2">
            <MapPin size={16} className="text-brand-500 shrink-0 mt-0.5" />
            <span className="truncate">{getClientAddress(job.clientId)}</span>
          </div>
        )}
        
        {userRole !== 'staff' && job.price > 0 && (
          <div className="flex items-center gap-2 text-slate-500">
            <DollarSign size={16} className="text-slate-400 shrink-0" />
            <span>${job.price}</span>
          </div>
        )}
      </div>

      {/* ADMIN INVOICE BUTTON (Completed Jobs Only) */}
      {userRole === 'admin' && job.status === 'completed' && (
        <button
          onClick={() => onInvoice(job)}
          className="w-full mt-3 px-4 py-2 bg-purple-50 text-purple-700 hover:bg-purple-100 rounded-lg font-medium flex items-center justify-center gap-2 border border-purple-100 transition-colors"
        >
          <FileText size={18} />
          {job.invoicedAt ? 'View Invoice' : 'Generate Invoice'}
        </button>
      )}

      {/* WORKFLOW BUTTONS */}
      {(canStart || canComplete) && (
        <div className="mt-4 pt-4 border-t border-gray-50 flex gap-2">
          {canStart && (
            <button 
              onClick={startJob}
              disabled={loading}
              className="flex-1 bg-brand-600 text-white py-2 rounded-lg font-bold flex items-center justify-center gap-2 hover:bg-brand-700 active:scale-95 transition-all"
            >
              {loading ? <Loader className="animate-spin" size={18} /> : <Play size={18} />}
              Start Job
            </button>
          )}
          
          {canComplete && (
            <button 
              onClick={completeJob}
              disabled={loading}
              className="flex-1 bg-green-600 text-white py-2 rounded-lg font-bold flex items-center justify-center gap-2 hover:bg-green-700 active:scale-95 transition-all"
            >
              {loading ? <Loader className="animate-spin" size={18} /> : <CheckCircle size={18} />}
              Complete Job
            </button>
          )}
        </div>
      )}
    </div>
  );
};

export default JobCardMobile;

```
---

## FILE: src/components/jobs/JobFormModal.jsx
```jsx
import React, { useState, useEffect } from 'react';
import { X, Save, Loader, Calendar, DollarSign, User } from 'lucide-react';
import { format } from 'date-fns';

const JobFormModal = ({ isOpen, onClose, onSave, clients, staff, initialData }) => {
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    clientId: '',
    assignedStaffId: '', 
    scheduledDate: '',
    serviceType: 'standard',
    price: '',
    notes: ''
  });

  // Populate form when initialData changes (Edit Mode)
  useEffect(() => {
    if (isOpen) {
      if (initialData) {
        // Edit Mode: Pre-fill
        // IMPORTANT: Format Date to 'yyyy-MM-ddThh:mm' for HTML input
        let dateStr = '';
        if (initialData.scheduledDate) {
          try {
            dateStr = format(initialData.scheduledDate, "yyyy-MM-dd'T'HH:mm");
          } catch (e) {
            console.error("Date parsing error", e);
          }
        }

        setFormData({
          clientId: initialData.clientId || '',
          assignedStaffId: initialData.assignedTo?.[0] || '',
          scheduledDate: dateStr,
          serviceType: initialData.serviceType || 'standard',
          price: initialData.price || '',
          notes: initialData.notes || ''
        });
      } else {
        // Create Mode: Reset
        setFormData({
          clientId: '',
          assignedStaffId: '',
          scheduledDate: '',
          serviceType: 'standard',
          price: '',
          notes: ''
        });
      }
    }
  }, [isOpen, initialData]);

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
      onClose();
    } catch (error) {
      console.error(error);
      alert("Failed to save job.");
    } finally {
      setLoading(false);
    }
  };

  const isEditMode = !!initialData;

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
      <div className="bg-white rounded-xl shadow-xl w-full max-w-lg overflow-hidden">
        
        {/* Header */}
        <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
          <h3 className="font-bold text-lg text-slate-800">
            {isEditMode ? 'Edit Job Details' : 'Schedule New Job'}
          </h3>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
            <X size={24} />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          
          {/* Client Selector */}
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

          {/* STAFF ASSIGNMENT */}
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Assign Staff</label>
            <div className="relative">
              <User className="absolute left-3 top-2.5 text-slate-400" size={18} />
              <select
                className="w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none bg-white"
                value={formData.assignedStaffId}
                onChange={(e) => setFormData({...formData, assignedStaffId: e.target.value})}
              >
                <option value="">-- Unassigned --</option>
                {staff.map(member => (
                  <option key={member.id} value={member.id}>
                    {member.fullName || member.email}
                  </option>
                ))}
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
              rows="2"
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
              {isEditMode ? 'Update Job' : 'Schedule Job'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default JobFormModal;

```
---

## FILE: src/components/jobs/JobListMobile.jsx
```jsx
import React from 'react';
import JobCardMobile from './JobCardMobile';

const JobListMobile = ({ jobs, clients, staff, userRole, onEdit, onInvoice }) => {
  const getClientName = (id) => clients.find(c => c.id === id)?.name || 'Unknown Client';
  const getClientAddress = (id) => clients.find(c => c.id === id)?.address;
  
  const getAssignedStaffName = (staffIds) => {
    if (!staffIds || staffIds.length === 0) return 'Unassigned';
    const member = staff.find(s => s.id === staffIds[0]);
    return member ? (member.fullName || member.email) : 'Unknown';
  };

  if (jobs.length === 0) {
    return (
      <div className="md:hidden text-center py-10 bg-white rounded-xl border border-gray-100">
        <p className="text-gray-500">No jobs found.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:hidden">
      {jobs.map((job) => (
        <JobCardMobile 
          key={job.id} 
          job={job}
          getClientName={getClientName}
          getClientAddress={getClientAddress}
          getAssignedStaffName={getAssignedStaffName}
          userRole={userRole}
          onEdit={onEdit}
          onInvoice={onInvoice} // <--- ADDED THIS PROP
        />
      ))}
    </div>
  );
};

export default JobListMobile;

```
---

## FILE: src/components/jobs/JobRowDesktop.jsx
```jsx
import React, { useState, useRef, useEffect } from 'react';
import { MoreHorizontal, Calendar, Clock, MapPin, User, Edit, Trash2, Play, CheckCircle, XCircle, FileText } from 'lucide-react';
import { format } from 'date-fns';
import { useJobWorkflow } from '../../hooks/useJobWorkflow';

const JobRowDesktop = ({ job, getClient, getAssignedStaffName, userRole, onEdit, onDelete, onInvoice }) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const menuRef = useRef(null);
  
  const { startJob, completeJob, cancelJob, canStart, canComplete, canCancel, loading } = useJobWorkflow(job, userRole);

  const client = getClient(job.clientId);
  const assignedName = getAssignedStaffName(job.assignedTo);
  const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;

  // Status Badge Logic
  const getStatusBadge = (s) => {
    const baseClasses = "text-xs font-bold px-2 py-1 rounded-full uppercase";
    switch(s) {
      case 'completed': return <span className={`${baseClasses} bg-green-100 text-green-700`}>{s}</span>;
      case 'in_progress': return <span className={`${baseClasses} bg-blue-100 text-blue-700`}>In Progress</span>;
      case 'cancelled': return <span className={`${baseClasses} bg-red-100 text-red-700`}>{s}</span>;
      default: return <span className={`${baseClasses} bg-yellow-100 text-yellow-700`}>{s}</span>;
    }
  };

  // Close menu on outside click
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (menuRef.current && !menuRef.current.contains(event.target)) {
        setIsMenuOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const handleAction = async (actionFn) => {
    await actionFn();
    setIsMenuOpen(false);
  };

  return (
    <tr className="hover:bg-gray-50 transition-colors relative">
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
        <div className={`flex items-center gap-2 text-sm ${isUnassigned ? 'text-slate-400 italic' : 'text-slate-700'}`}>
          <User size={14} />
          {assignedName}
        </div>
      </td>
      <td className="px-6 py-4">
        <span className="capitalize text-sm text-slate-700">{job.serviceType}</span>
        {userRole !== 'staff' && job.price > 0 && (
          <div className="text-xs text-slate-400">${job.price}</div>
        )}
      </td>
      <td className="px-6 py-4">
        {getStatusBadge(job.status)}
        {job.invoicedAt && userRole === 'admin' && (
          <div className="mt-1 text-[10px] bg-gray-100 text-gray-500 px-1.5 py-0.5 rounded inline-block">
            Invoiced
          </div>
        )}
      </td>
      
      {/* ACTIONS */}
      <td className="px-6 py-4 text-right relative">
        <button 
          onClick={(e) => {
            e.stopPropagation();
            setIsMenuOpen(!isMenuOpen);
          }}
          className={`p-2 rounded-full transition-colors ${isMenuOpen ? 'bg-brand-50 text-brand-600' : 'text-slate-400 hover:text-brand-600 hover:bg-gray-100'}`}
        >
          <MoreHorizontal size={20} />
        </button>

        {isMenuOpen && (
          <div 
            ref={menuRef}
            className="absolute right-8 top-8 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-50 overflow-hidden text-left animate-in fade-in zoom-in duration-200"
          >
            {/* WORKFLOW ACTIONS */}
            {canStart && (
              <button 
                onClick={() => handleAction(startJob)}
                disabled={loading}
                className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors font-medium"
              >
                <Play size={16} className="text-green-500" /> Start Job
              </button>
            )}
            
            {canComplete && (
              <button 
                onClick={() => handleAction(completeJob)}
                disabled={loading}
                className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors font-medium"
              >
                <CheckCircle size={16} className="text-blue-500" /> Complete Job
              </button>
            )}

            {/* ADMIN ACTIONS */}
            {userRole === 'admin' && (
              <>
                {/* INVOICE ACTION */}
                {job.status === 'completed' && (
                  <button 
                    onClick={() => { setIsMenuOpen(false); onInvoice(job); }}
                    className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-purple-50 flex items-center gap-2 transition-colors border-t border-gray-50 font-medium"
                  >
                    <FileText size={16} className="text-purple-500" /> 
                    {job.invoicedAt ? 'View Invoice' : 'Generate Invoice'}
                  </button>
                )}

                <button 
                  onClick={() => { setIsMenuOpen(false); onEdit(job); }}
                  className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors"
                >
                  <Edit size={16} className="text-slate-400" /> Edit Details
                </button>

                <div className="border-t border-gray-100">
                  {canCancel && (
                    <button 
                      onClick={() => handleAction(cancelJob)}
                      className="w-full px-4 py-3 text-sm text-amber-600 hover:bg-amber-50 flex items-center gap-2 transition-colors"
                    >
                      <XCircle size={16} /> Cancel Job
                    </button>
                  )}
                  <button 
                    onClick={() => { setIsMenuOpen(false); onDelete(job.id); }}
                    className="w-full px-4 py-3 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors"
                  >
                    <Trash2 size={16} /> Delete
                  </button>
                </div>
              </>
            )}
          </div>
        )}
      </td>
    </tr>
  );
};

export default JobRowDesktop;

```
---

## FILE: src/components/jobs/JobTableDesktop.jsx
```jsx
import React from 'react';
import JobRowDesktop from './JobRowDesktop';

const JobTableDesktop = ({ jobs, clients, staff, userRole, onEdit, onDelete, onInvoice }) => {
  const getClient = (id) => clients.find(c => c.id === id) || {};
  
  const getAssignedStaffName = (staffIds) => {
    if (!staffIds || staffIds.length === 0) return 'Unassigned';
    const member = staff.find(s => s.id === staffIds[0]);
    return member ? (member.fullName || member.email) : 'Unknown';
  };

  if (jobs.length === 0) {
    return (
      <div className="hidden md:block bg-white p-12 text-center rounded-xl border border-gray-200">
        <p className="text-gray-500">No jobs found.</p>
      </div>
    );
  }

  return (
    <div className="hidden md:block bg-white rounded-xl shadow-sm border border-gray-200 overflow-visible min-h-[300px]">
      <table className="w-full text-left border-collapse">
        <thead>
          <tr className="bg-gray-50 border-b border-gray-200 text-xs uppercase text-gray-500 font-semibold">
            <th className="px-6 py-4">Scheduled Date</th>
            <th className="px-6 py-4">Client</th>
            <th className="px-6 py-4">Assigned Staff</th>
            <th className="px-6 py-4">Service</th>
            <th className="px-6 py-4">Status</th>
            <th className="px-6 py-4 text-right">Actions</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100">
          {jobs.map((job) => (
            <JobRowDesktop 
              key={job.id} 
              job={job}
              getClient={getClient}
              getAssignedStaffName={getAssignedStaffName}
              userRole={userRole}
              onEdit={onEdit}
              onDelete={onDelete}
              onInvoice={onInvoice}
            />
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default JobTableDesktop;

```
---

## FILE: src/components/layout/AppLayout.jsx
```jsx
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

```
---

## FILE: src/components/layout/AuthGuard.jsx
```jsx
import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { onAuthStateChanged } from 'firebase/auth';
import { auth } from '../../lib/firebase';

const AuthGuard = ({ children }) => {
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      if (!currentUser) {
        navigate('/login');
      } else {
        setUser(currentUser);
      }
      setLoading(false);
    });

    return () => unsubscribe();
  }, [navigate]);

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-brand-600"></div>
      </div>
    );
  }

  return user ? children : null;
};

export default AuthGuard;
```
---

## FILE: src/components/layout/BottomNav.jsx
```jsx
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

```
---

## FILE: src/components/layout/Sidebar.jsx
```jsx
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

      <div className="p-4 border-t border-slate-700 space-y-4">
        <button 
          onClick={handleSignOut}
          className="flex items-center gap-3 px-4 py-2 text-slate-300 hover:text-white w-full hover:bg-slate-700 rounded-lg transition-colors"
        >
          <LogOut size={20} />
          <span>Sign Out</span>
        </button>

        {/* Version Footer */}
        <div className="px-4 text-[10px] text-slate-600 font-mono">
          <p>v{__APP_VERSION__}</p>
          <p>b{__COMMIT_HASH__} • {__BUILD_DATE__}</p>
        </div>
      </div>
    </aside>
  );
};

export default Sidebar;

```
---

## FILE: src/components/map/MapComponent.jsx
```jsx
import React, { useState, useCallback } from 'react';
import { GoogleMap, useJsApiLoader, Marker, InfoWindow } from '@react-google-maps/api';
import { format } from 'date-fns';

const containerStyle = {
  width: '100%',
  height: '500px',
  borderRadius: '0.75rem'
};

// Default center (e.g., New York) - overridden if jobs exist
const defaultCenter = {
  lat: 40.7128,
  lng: -74.0060
};

const MapComponent = ({ jobs, clients }) => {
  const { isLoaded } = useJsApiLoader({
    id: 'google-map-script',
    googleMapsApiKey: import.meta.env.VITE_GOOGLE_MAPS_API_KEY
  });

  const [map, setMap] = useState(null);
  const [selectedJob, setSelectedJob] = useState(null);

  const onLoad = useCallback(function callback(map) {
    // Fit bounds to show all markers
    const bounds = new window.google.maps.LatLngBounds();
    let hasPoints = false;

    validJobs.forEach(job => {
      const client = clients.find(c => c.id === job.clientId);
      if (client?.coordinates) {
        bounds.extend(client.coordinates);
        hasPoints = true;
      }
    });

    if (hasPoints) {
      map.fitBounds(bounds);
    } else {
      map.setCenter(defaultCenter);
      map.setZoom(10);
    }
    
    setMap(map);
  }, [jobs, clients]);

  const onUnmount = useCallback(function callback(map) {
    setMap(null);
  }, []);

  // Filter jobs that actually have valid client coordinates
  const validJobs = jobs.filter(job => {
    const client = clients.find(c => c.id === job.clientId);
    return client && client.coordinates && client.coordinates.lat;
  });

  if (!isLoaded) {
    return <div className="h-64 bg-gray-100 animate-pulse rounded-xl flex items-center justify-center text-gray-400">Loading Map...</div>;
  }

  return (
    <div className="rounded-xl overflow-hidden shadow-sm border border-gray-200">
      <GoogleMap
        mapContainerStyle={containerStyle}
        center={defaultCenter}
        zoom={10}
        onLoad={onLoad}
        onUnmount={onUnmount}
        options={{
          streetViewControl: false,
          mapTypeControl: false,
        }}
      >
        {validJobs.map(job => {
          const client = clients.find(c => c.id === job.clientId);
          
          return (
            <Marker
              key={job.id}
              position={client.coordinates}
              onClick={() => setSelectedJob({ job, client })}
              // Different icon colors based on status could go here
            />
          );
        })}

        {selectedJob && (
          <InfoWindow
            position={selectedJob.client.coordinates}
            onCloseClick={() => setSelectedJob(null)}
          >
            <div className="p-1">
              <h3 className="font-bold text-slate-800">{selectedJob.client.name}</h3>
              <p className="text-xs text-slate-500 mb-2">{selectedJob.client.address}</p>
              <div className="text-xs font-medium text-brand-600 bg-brand-50 px-2 py-1 rounded inline-block">
                {format(selectedJob.job.scheduledDate, 'h:mm a')} - {selectedJob.job.serviceType}
              </div>
            </div>
          </InfoWindow>
        )}
      </GoogleMap>
    </div>
  );
};

export default React.memo(MapComponent);

```
---

## FILE: src/components/schedule/DailyAgenda.jsx
```jsx
import React from 'react';
import { Clock, MapPin, DollarSign, User, AlertCircle } from 'lucide-react';
import { format } from 'date-fns';

const DailyAgenda = ({ jobs, clients, loading, selectedDate, userRole }) => {
  const getClient = (clientId) => clients.find(c => c.id === clientId) || {};

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center py-12">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-brand-600 mb-4"></div>
        <p className="text-slate-400 text-sm">Loading schedule...</p>
      </div>
    );
  }

  if (jobs.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center py-16 px-4 text-center">
        <div className="bg-slate-50 p-4 rounded-full mb-4">
          {/* Simple SVG icon inline for simplicity */}
          <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-slate-300">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
            <line x1="16" y1="2" x2="16" y2="6"></line>
            <line x1="8" y1="2" x2="8" y2="6"></line>
            <line x1="3" y1="10" x2="21" y2="10"></line>
          </svg>
        </div>
        <h3 className="text-lg font-bold text-slate-700">No jobs scheduled</h3>
        <p className="text-slate-500 text-sm mt-1">
          You have no jobs for {format(selectedDate, 'MMMM do')}.
        </p>
      </div>
    );
  }

  return (
    <div className="p-4 space-y-4 max-w-2xl mx-auto">
      {jobs.map((job) => {
        const client = getClient(job.clientId);
        return (
          <div key={job.id} className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden flex">
            {/* Time Strip */}
            <div className="w-16 bg-slate-50 flex flex-col items-center justify-center border-r border-gray-100 p-2">
              <span className="text-sm font-bold text-slate-700">
                {job.scheduledDate ? format(job.scheduledDate, 'h:mm') : '--'}
              </span>
              <span className="text-xs text-slate-400 uppercase">
                {job.scheduledDate ? format(job.scheduledDate, 'a') : '--'}
              </span>
            </div>

            {/* Content */}
            <div className="flex-1 p-4">
              <div className="flex justify-between items-start mb-1">
                <h4 className="font-bold text-slate-800">{client.name || 'Unknown Client'}</h4>
                <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold uppercase ${
                  job.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-brand-50 text-brand-700'
                }`}>
                  {job.status}
                </span>
              </div>
              
              <div className="space-y-1.5 mt-2">
                <div className="flex items-center gap-2 text-sm text-slate-600">
                  <User size={14} className="text-brand-400" />
                  <span className="capitalize">{job.serviceType} Clean</span>
                </div>
                
                {client.address && (
                  <div className="flex items-start gap-2 text-sm text-slate-600">
                    <MapPin size={14} className="text-brand-400 mt-0.5 shrink-0" />
                    <span className="truncate">{client.address}</span>
                  </div>
                )}

                {/* RBAC: Hide Price from Staff */}
                {userRole !== 'staff' && job.price > 0 && (
                  <div className="flex items-center gap-2 text-sm text-slate-500">
                    <DollarSign size={14} className="text-brand-400" />
                    <span>${job.price}</span>
                  </div>
                )}

                {job.notes && (
                  <div className="flex items-start gap-2 text-xs text-amber-600 bg-amber-50 p-2 rounded-lg mt-2">
                    <AlertCircle size={12} className="mt-0.5 shrink-0" />
                    <span>{job.notes}</span>
                  </div>
                )}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default DailyAgenda;

```
---

## FILE: src/components/schedule/DateStrip.jsx
```jsx
import React from 'react';
import { format, isSameDay, addDays, startOfWeek } from 'date-fns';
import { ChevronLeft, ChevronRight } from 'lucide-react';

const DateStrip = ({ selectedDate, onSelectDate }) => {
  // Always show the week surrounding the selected date
  // Start week on Monday (default US is Sunday, but operations usually prefer Mon)
  const weekStart = startOfWeek(selectedDate, { weekStartsOn: 1 });
  
  const days = Array.from({ length: 7 }).map((_, i) => addDays(weekStart, i));

  const handlePrevWeek = () => onSelectDate(addDays(selectedDate, -7));
  const handleNextWeek = () => onSelectDate(addDays(selectedDate, 7));

  return (
    <div className="bg-white border-b border-gray-200 shadow-sm">
      {/* Week Navigation Header */}
      <div className="flex items-center justify-between px-4 py-2 border-b border-gray-100">
        <button 
          onClick={handlePrevWeek}
          className="p-1 hover:bg-gray-100 rounded-full text-slate-500"
        >
          <ChevronLeft size={20} />
        </button>
        <h2 className="font-bold text-slate-800">
          {format(selectedDate, 'MMMM yyyy')}
        </h2>
        <button 
          onClick={handleNextWeek}
          className="p-1 hover:bg-gray-100 rounded-full text-slate-500"
        >
          <ChevronRight size={20} />
        </button>
      </div>

      {/* Horizontal Scrollable Days */}
      <div className="flex justify-between md:justify-center md:gap-8 px-2 py-3 overflow-x-auto no-scrollbar">
        {days.map((day) => {
          const isSelected = isSameDay(day, selectedDate);
          const isToday = isSameDay(day, new Date());

          return (
            <button
              key={day.toString()}
              onClick={() => onSelectDate(day)}
              className={`flex flex-col items-center justify-center min-w-[3rem] py-2 rounded-xl transition-all ${
                isSelected 
                  ? 'bg-brand-600 text-white shadow-md transform scale-105' 
                  : 'hover:bg-gray-50 text-slate-600'
              }`}
            >
              <span className={`text-xs font-medium uppercase mb-1 ${isSelected ? 'text-brand-100' : 'text-slate-400'}`}>
                {format(day, 'EEE')}
              </span>
              <span className={`text-lg font-bold ${isSelected ? 'text-white' : isToday ? 'text-brand-600' : 'text-slate-800'}`}>
                {format(day, 'd')}
              </span>
              {isToday && !isSelected && (
                <div className="w-1 h-1 bg-brand-500 rounded-full mt-1"></div>
              )}
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default DateStrip;

```
---

## FILE: src/components/settings/ProfileForm.jsx
```jsx
import React, { useState, useEffect } from 'react';
import { 
  Save, Bus, Car, DollarSign, Calendar, 
  Dumbbell, Languages, AlertCircle, CheckCircle, Loader 
} from 'lucide-react';
import { useProfile } from '../../hooks/useProfile';

const ProfileForm = () => {
  const { profile, loading, updateProfile } = useProfile();
  const [isSaving, setIsSaving] = useState(false);
  const [message, setMessage] = useState(null); // { type: 'success'|'error', text: '' }

  // Local Form State
  const [formData, setFormData] = useState({
    fullName: '',
    phone: '',
    language: 'en',
    transport: 'transit', // Default for Jasmine
    financialMode: 'unlimited',
    financialLimit: '',
    heavyLifting: false,
    blockedWindows: [],
    acceptedTerms: false
  });

  // Hydrate form from Firestore data
  useEffect(() => {
    if (profile) {
      setFormData({
        fullName: profile.fullName || '',
        phone: profile.profile?.phone || '',
        language: profile.profile?.language || 'en',
        transport: profile.profile?.transport || 'transit',
        financialMode: profile.financials?.mode || 'unlimited',
        financialLimit: profile.financials?.limit || '',
        heavyLifting: profile.constraints?.heavyLifting || false,
        blockedWindows: profile.constraints?.blockedWindows || [],
        acceptedTerms: profile.profile?.acceptedTermsVersion === 'v1.0'
      });
    }
  }, [profile]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage(null);
    setIsSaving(true);

    try {
      // 1. Construct Schema-Compliant Object
      const updates = {
        fullName: formData.fullName, // Root level for easy Auth display
        profile: {
          phone: formData.phone,
          language: formData.language,
          transport: formData.transport,
          // Sarah (Compliance): Audit Trail
          acceptedTermsVersion: formData.acceptedTerms ? 'v1.0' : null
        },
        financials: {
          mode: formData.financialMode,
          limit: formData.financialMode === 'cap' ? Number(formData.financialLimit) : null
        },
        constraints: {
          heavyLifting: formData.heavyLifting,
          blockedWindows: formData.blockedWindows
        }
      };

      await updateProfile(updates);
      setMessage({ type: 'success', text: 'Profile updated successfully!' });
      
      // Clear success message after 3s
      setTimeout(() => setMessage(null), 3000);
    } catch (err) {
      setMessage({ type: 'error', text: 'Failed to save profile. Try again.' });
    } finally {
      setIsSaving(false);
    }
  };

  const toggleWindow = (windowId) => {
    setFormData(prev => {
      const current = prev.blockedWindows;
      if (current.includes(windowId)) {
        return { ...prev, blockedWindows: current.filter(id => id !== windowId) };
      } else {
        return { ...prev, blockedWindows: [...current, windowId] };
      }
    });
  };

  if (loading) return <div className="p-8 text-center text-slate-400">Loading profile...</div>;

  return (
    <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      
      {/* Header */}
      <div className="px-6 py-4 border-b border-gray-100 bg-slate-50 flex justify-between items-center">
        <div>
          <h2 className="text-lg font-bold text-slate-800">My Worker Profile</h2>
          <p className="text-xs text-slate-500">Manage your capabilities & limits</p>
        </div>
        {/* Ahmed: Visual Language Toggle Placeholder */}
        <div className="flex gap-2">
          <button 
            type="button" 
            onClick={() => setFormData({...formData, language: 'en'})}
            className={`text-xs px-2 py-1 rounded font-bold ${formData.language === 'en' ? 'bg-slate-800 text-white' : 'bg-white text-slate-400 border'}`}
          >EN</button>
          <button 
            type="button" 
            onClick={() => setFormData({...formData, language: 'fr'})}
            className={`text-xs px-2 py-1 rounded font-bold ${formData.language === 'fr' ? 'bg-brand-600 text-white' : 'bg-white text-slate-400 border'}`}
          >FR</button>
        </div>
      </div>

      <div className="p-6 space-y-8">
        
        {/* SECTION 1: IDENTITY */}
        <div className="space-y-4">
          <label className="block text-sm font-bold text-slate-700 uppercase tracking-wide">
            Identity
          </label>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <span className="text-xs text-slate-500 mb-1 block">Full Name</span>
              <input 
                type="text" 
                required
                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 outline-none"
                value={formData.fullName}
                onChange={e => setFormData({...formData, fullName: e.target.value})}
              />
            </div>
            <div>
              <span className="text-xs text-slate-500 mb-1 block">Phone Number</span>
              <input 
                type="tel" 
                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 outline-none"
                placeholder="(555) 123-4567"
                value={formData.phone}
                onChange={e => setFormData({...formData, phone: e.target.value})}
              />
            </div>
          </div>
        </div>

        <hr className="border-slate-100" />

        {/* SECTION 2: TRANSPORT (Jasmine) */}
        <div>
          <label className="flex items-center gap-2 text-sm font-bold text-slate-700 uppercase tracking-wide mb-3">
            <Bus size={18} className="text-brand-500" /> Transport Mode
          </label>
          <div className="grid grid-cols-2 gap-4">
            <button
              type="button"
              onClick={() => setFormData({...formData, transport: 'transit'})}
              className={`p-4 rounded-xl border-2 flex flex-col items-center gap-2 transition-all ${
                formData.transport === 'transit' 
                  ? 'border-brand-500 bg-brand-50 text-brand-700' 
                  : 'border-slate-200 hover:border-slate-300 text-slate-500'
              }`}
            >
              <Bus size={32} />
              <span className="font-bold">Public Transit</span>
            </button>
            <button
              type="button"
              onClick={() => setFormData({...formData, transport: 'vehicle'})}
              className={`p-4 rounded-xl border-2 flex flex-col items-center gap-2 transition-all ${
                formData.transport === 'vehicle' 
                  ? 'border-brand-500 bg-brand-50 text-brand-700' 
                  : 'border-slate-200 hover:border-slate-300 text-slate-500'
              }`}
            >
              <Car size={32} />
              <span className="font-bold">Personal Vehicle</span>
            </button>
          </div>
          {formData.transport === 'transit' && (
            <p className="text-xs text-slate-500 mt-2 bg-slate-50 p-2 rounded">
              ℹ️ We will add 30-min travel buffers to your schedule automatically.
            </p>
          )}
        </div>

        <hr className="border-slate-100" />

        {/* SECTION 3: FINANCIALS (Carla) */}
        <div>
          <label className="flex items-center gap-2 text-sm font-bold text-slate-700 uppercase tracking-wide mb-3">
            <DollarSign size={18} className="text-green-600" /> Financial Safety
          </label>
          
          <div className="bg-orange-50 border border-orange-100 rounded-lg p-4 mb-4">
            <div className="flex items-start gap-3">
              <input 
                type="radio" 
                id="fin_cap"
                name="fin_mode"
                checked={formData.financialMode === 'cap'}
                onChange={() => setFormData({...formData, financialMode: 'cap'})}
                className="mt-1 w-4 h-4 text-brand-600"
              />
              <div className="flex-1">
                <label htmlFor="fin_cap" className="font-bold text-slate-800 block">
                  Strict Earning Cap (ODSP/Support)
                </label>
                <p className="text-xs text-slate-600 mb-2">
                  Stop assigning me work once I reach a monthly limit.
                </p>
                {formData.financialMode === 'cap' && (
                  <div className="relative max-w-[200px]">
                    <span className="absolute left-3 top-2.5 text-slate-500">$</span>
                    <input 
                      type="number" 
                      placeholder="1000.00"
                      className="w-full pl-7 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 outline-none"
                      value={formData.financialLimit}
                      onChange={e => setFormData({...formData, financialLimit: e.target.value})}
                    />
                  </div>
                )}
              </div>
            </div>
          </div>

          <div className="flex items-start gap-3 p-4 rounded-lg border border-slate-100">
            <input 
              type="radio" 
              id="fin_unlimited"
              name="fin_mode"
              checked={formData.financialMode === 'unlimited'}
              onChange={() => setFormData({...formData, financialMode: 'unlimited'})}
              className="mt-1 w-4 h-4 text-brand-600"
            />
            <div>
              <label htmlFor="fin_unlimited" className="font-bold text-slate-800 block">
                Unlimited Earnings
              </label>
              <p className="text-xs text-slate-500">I have no restrictions on income.</p>
            </div>
          </div>
        </div>

        <hr className="border-slate-100" />

        {/* SECTION 4: CONSTRAINTS (Mike) */}
        <div>
          <label className="flex items-center gap-2 text-sm font-bold text-slate-700 uppercase tracking-wide mb-3">
            <Calendar size={18} className="text-purple-600" /> Unavailability
          </label>
          <p className="text-xs text-slate-500 mb-3">Select recurring times you CANNOT work (e.g. meetings, appointments).</p>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            {[
              { id: 'tue_evening', label: 'Tue Evening', sub: '7pm - 10pm' },
              { id: 'thu_evening', label: 'Thu Evening', sub: '7pm - 10pm' },
              { id: 'sat_morning', label: 'Sat Morning', sub: '8am - 12pm' },
              { id: 'sun_allday',  label: 'Sunday', sub: 'All Day' },
            ].map(window => (
              <button
                key={window.id}
                type="button"
                onClick={() => toggleWindow(window.id)}
                className={`p-3 rounded-lg border text-left transition-all ${
                  formData.blockedWindows.includes(window.id)
                    ? 'bg-red-50 border-red-200' 
                    : 'bg-white border-slate-200 hover:border-slate-300'
                }`}
              >
                <div className="flex justify-between items-start">
                  <span className={`font-bold text-sm ${formData.blockedWindows.includes(window.id) ? 'text-red-700' : 'text-slate-700'}`}>
                    {window.label}
                  </span>
                  {formData.blockedWindows.includes(window.id) && <CheckCircle size={14} className="text-red-600" />}
                </div>
                <span className="text-xs text-slate-400 block mt-1">{window.sub}</span>
              </button>
            ))}
          </div>
        </div>

        {/* SECTION 5: CAPABILITIES */}
        <div className="flex items-center justify-between p-4 bg-slate-50 rounded-xl border border-slate-200">
          <div className="flex items-center gap-3">
            <div className="bg-white p-2 rounded-full border border-slate-200">
              <Dumbbell size={20} className="text-slate-600" />
            </div>
            <div>
              <span className="font-bold text-slate-800 block">Heavy Lifting OK?</span>
              <span className="text-xs text-slate-500">Can lift 50lbs+ (Deep Cleans)</span>
            </div>
          </div>
          <div className="relative inline-block w-12 mr-2 align-middle select-none transition duration-200 ease-in">
            <input 
              type="checkbox" 
              name="heavy" 
              id="heavy" 
              checked={formData.heavyLifting}
              onChange={e => setFormData({...formData, heavyLifting: e.target.checked})}
              className="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-4 appearance-none cursor-pointer checked:right-0 checked:border-green-400"
              style={{ right: formData.heavyLifting ? '0' : 'auto', left: formData.heavyLifting ? 'auto' : '0' }}
            />
            <label htmlFor="heavy" className={`toggle-label block overflow-hidden h-6 rounded-full cursor-pointer ${formData.heavyLifting ? 'bg-green-400' : 'bg-slate-300'}`}></label>
          </div>
        </div>

      </div>

      {/* FOOTER & ACTIONS */}
      <div className="p-6 bg-slate-50 border-t border-gray-100">
        
        <div className="mb-4 flex items-start gap-2">
          <input 
            type="checkbox" 
            id="terms" 
            required
            checked={formData.acceptedTerms}
            onChange={e => setFormData({...formData, acceptedTerms: e.target.checked})}
            className="mt-1 w-4 h-4 text-brand-600 rounded"
          />
          <label htmlFor="terms" className="text-xs text-slate-600 leading-tight">
            I confirm these details are accurate. I understand that falsifying my earning limits may result in schedule conflicts. <span className="font-bold text-brand-600">(Terms v1.0)</span>
          </label>
        </div>

        {message && (
          <div className={`mb-4 p-3 rounded-lg flex items-center gap-2 text-sm ${
            message.type === 'success' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
          }`}>
            {message.type === 'success' ? <CheckCircle size={16} /> : <AlertCircle size={16} />}
            {message.text}
          </div>
        )}

        <button 
          type="submit" 
          disabled={isSaving || !formData.acceptedTerms}
          className="w-full bg-brand-600 text-white py-3 rounded-xl font-bold hover:bg-brand-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 transition-all shadow-md active:scale-95"
        >
          {isSaving ? <Loader className="animate-spin" size={20} /> : <Save size={20} />}
          Save Profile
        </button>
      </div>
    </form>
  );
};

export default ProfileForm;

```
---

## FILE: src/features/auth/LoginPage.jsx
```jsx
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { createUserWithEmailAndPassword, signInWithEmailAndPassword } from 'firebase/auth';
import { auth } from '../../lib/firebase';
import { Lock, Mail, UserPlus, LogIn, AlertCircle } from 'lucide-react';

const LoginPage = () => {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleAuth = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      if (isLogin) {
        await signInWithEmailAndPassword(auth, email, password);
      } else {
        await createUserWithEmailAndPassword(auth, email, password);
      }
      navigate('/'); // Redirect to Dashboard on success
    } catch (err) {
      console.error(err);
      let msg = "An error occurred.";
      if (err.code === 'auth/invalid-credential') msg = "Invalid email or password.";
      if (err.code === 'auth/email-already-in-use') msg = "Email already in use.";
      if (err.code === 'auth/weak-password') msg = "Password should be at least 6 characters.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-brand-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl w-full max-w-md overflow-hidden">
        
        {/* Header */}
        <div className="bg-brand-600 p-8 text-center">
          <div className="mx-auto bg-white/20 w-16 h-16 rounded-full flex items-center justify-center mb-4 backdrop-blur-sm">
            <Lock className="text-white" size={32} />
          </div>
          <h1 className="text-2xl font-bold text-white">Fresh Nest</h1>
          <p className="text-brand-100">Operations Manager</p>
        </div>

        {/* Form */}
        <div className="p-8">
          <h2 className="text-xl font-bold text-slate-800 mb-6 text-center">
            {isLogin ? 'Welcome Back' : 'Create Account'}
          </h2>

          {error && (
            <div className="mb-4 p-3 bg-red-50 text-red-600 text-sm rounded-lg flex items-center gap-2">
              <AlertCircle size={16} />
              {error}
            </div>
          )}

          <form onSubmit={handleAuth} className="space-y-4">
            <div>
              <label className="block text-xs font-medium text-slate-500 mb-1 uppercase">Email Address</label>
              <div className="relative">
                <Mail className="absolute left-3 top-3 text-slate-400" size={20} />
                <input
                  type="email"
                  name="email"
                  id="email"
                  autoComplete="email"
                  required
                  className="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500"
                  placeholder="name@company.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-medium text-slate-500 mb-1 uppercase">Password</label>
              <div className="relative">
                <Lock className="absolute left-3 top-3 text-slate-400" size={20} />
                <input
                  type="password"
                  name="password"
                  id="password"
                  autoComplete={isLogin ? "current-password" : "new-password"}
                  required
                  className="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-brand-600 text-white py-3 rounded-lg font-semibold hover:bg-brand-700 transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
            >
              {loading ? 'Processing...' : (isLogin ? <><LogIn size={20} /> Sign In</> : <><UserPlus size={20} /> Create Account</>)}
            </button>
          </form>

          <div className="mt-6 text-center">
            <button
              onClick={() => setIsLogin(!isLogin)}
              className="text-sm text-slate-500 hover:text-brand-600 underline"
            >
              {isLogin ? "Don't have an account? Sign Up" : "Already have an account? Sign In"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
```
---

## FILE: src/hooks/useClients.js
```js
import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, addDoc, serverTimestamp, orderBy, doc, getDoc
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useClients = () => {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentOrgId, setCurrentOrgId] = useState(null);
  const [userRole, setUserRole] = useState(null); // Added role state

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setError("User profile not found.");
          setLoading(false);
          return;
        }

        const userData = userDoc.data();
        const orgId = userData.orgId;
        const role = userData.role;

        setCurrentOrgId(orgId);
        setUserRole(role); // Set Role

        if (!orgId) {
          setError("Organization ID missing.");
          setLoading(false);
          return;
        }

        const q = query(
          collection(db, 'clients'),
          where('orgId', '==', orgId),
          orderBy('createdAt', 'desc')
        );

        const unsubscribe = onSnapshot(q, (snapshot) => {
          const clientData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            // Extract lat/lng for flattening later if needed
            lat: doc.data().coordinates?.lat || '',
            lng: doc.data().coordinates?.lng || ''
          }));
          setClients(clientData);
          setLoading(false);
        }, (err) => {
          console.error("Error fetching clients:", err);
          setError("Failed to load clients.");
          setLoading(false);
        });

        return unsubscribe;

      } catch (err) {
        console.error(err);
        setError("Error initializing client list.");
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, []);

  const addClient = async (clientData) => {
    if (!currentOrgId) throw new Error("No Organization ID found.");
    await addDoc(collection(db, 'clients'), {
      ...clientData,
      orgId: currentOrgId, 
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    });
  };

  return { clients, loading, error, addClient, role: userRole };
};

```
---

## FILE: src/hooks/useDashboard.js
```js
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

```
---

## FILE: src/hooks/useJobWorkflow.js
```js
import { useState } from 'react';
import { doc, updateDoc, serverTimestamp } from 'firebase/firestore';
import { db, auth } from '../lib/firebase';

export const useJobWorkflow = (job, userRole) => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const userId = auth.currentUser?.uid;

  // --- RBAC PERMISSIONS ---
  const isAdmin = userRole === 'admin';
  const isStaff = userRole === 'staff';
  const isAssigned = job.assignedTo && job.assignedTo.includes(userId);

  // Permission Logic:
  // Admin can edit ANY job.
  // Staff can ONLY edit jobs assigned to them.
  const hasPermission = isAdmin || (isStaff && isAssigned);

  // --- STATUS ACTIONS ---
  
  const startJob = async () => {
    if (!hasPermission) return;
    setLoading(true);
    setError(null);
    try {
      const jobRef = doc(db, 'jobs', job.id);
      await updateDoc(jobRef, {
        status: 'in_progress',
        startedAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      });
    } catch (err) {
      console.error("Error starting job:", err);
      setError("Failed to start job.");
    } finally {
      setLoading(false);
    }
  };

  const completeJob = async () => {
    if (!hasPermission) return;
    setLoading(true);
    setError(null);
    try {
      const jobRef = doc(db, 'jobs', job.id);
      await updateDoc(jobRef, {
        status: 'completed',
        completedAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      });
    } catch (err) {
      console.error("Error completing job:", err);
      setError("Failed to complete job.");
    } finally {
      setLoading(false);
    }
  };

  const cancelJob = async () => {
    // Only Admin can cancel for now
    if (!isAdmin) return; 
    setLoading(true);
    setError(null);
    try {
      const jobRef = doc(db, 'jobs', job.id);
      await updateDoc(jobRef, {
        status: 'cancelled',
        updatedAt: serverTimestamp()
      });
    } catch (err) {
      console.error("Error cancelling job:", err);
      setError("Failed to cancel job.");
    } finally {
      setLoading(false);
    }
  };

  // --- UI FLAGS ---
  const canStart = hasPermission && job.status === 'scheduled';
  const canComplete = hasPermission && job.status === 'in_progress';
  const canCancel = isAdmin && job.status !== 'completed' && job.status !== 'cancelled';

  return {
    startJob,
    completeJob,
    cancelJob,
    canStart,
    canComplete,
    canCancel,
    loading,
    error
  };
};

```
---

## FILE: src/hooks/useJobs.js
```js
import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, addDoc, updateDoc, deleteDoc, 
  serverTimestamp, orderBy, Timestamp, doc, getDoc 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useJobs = () => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentOrgId, setCurrentOrgId] = useState(null);
  const [userRole, setUserRole] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setLoading(false);
          return;
        }

        const userData = userDoc.data();
        const orgId = userData.orgId;
        const role = userData.role;

        setCurrentOrgId(orgId);
        setUserRole(role);

        if (!orgId) {
          setError("Organization ID missing.");
          setLoading(false);
          return;
        }

        // Constraints
        let constraints = [
          where('orgId', '==', orgId),
          orderBy('scheduledDate', 'asc')
        ];

        if (role === 'staff') {
          constraints.push(where('assignedTo', 'array-contains', user.uid));
        }

        const q = query(collection(db, 'jobs'), ...constraints);

        return onSnapshot(q, (snapshot) => {
          const jobData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            scheduledDate: doc.data().scheduledDate?.toDate(),
            invoicedAt: doc.data().invoicedAt?.toDate()
          }));
          setJobs(jobData);
          setLoading(false);
        }, (err) => {
          console.error("Error fetching jobs:", err);
          setError("Failed to load jobs.");
          setLoading(false);
        });
      } catch (err) {
        console.error(err);
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, []);

  // --- MUTATIONS ---

  const addJob = async (jobData) => {
    if (!currentOrgId) throw new Error("No Org ID.");
    if (userRole !== 'admin') throw new Error("Unauthorized.");

    const timestampDate = new Date(jobData.scheduledDate);
    const assignedTo = jobData.assignedStaffId ? [jobData.assignedStaffId] : [];

    await addDoc(collection(db, 'jobs'), {
      clientId: jobData.clientId,
      serviceType: jobData.serviceType,
      price: Number(jobData.price),
      notes: jobData.notes,
      assignedTo: assignedTo,
      status: 'scheduled',
      scheduledDate: Timestamp.fromDate(timestampDate),
      orgId: currentOrgId, 
      createdAt: serverTimestamp(),
      createdBy: auth.currentUser.uid
    });
  };

  const updateJob = async (jobId, jobData) => {
    if (userRole !== 'admin') throw new Error("Unauthorized.");

    const timestampDate = new Date(jobData.scheduledDate);
    const assignedTo = jobData.assignedStaffId ? [jobData.assignedStaffId] : [];

    const jobRef = doc(db, 'jobs', jobId);
    await updateDoc(jobRef, {
      clientId: jobData.clientId,
      serviceType: jobData.serviceType,
      price: Number(jobData.price),
      notes: jobData.notes,
      assignedTo: assignedTo,
      scheduledDate: Timestamp.fromDate(timestampDate),
      updatedAt: serverTimestamp()
    });
  };

  const deleteJob = async (jobId) => {
    if (userRole !== 'admin') throw new Error("Unauthorized.");
    const jobRef = doc(db, 'jobs', jobId);
    await deleteDoc(jobRef);
  };

  const markAsInvoiced = async (jobId) => {
    if (userRole !== 'admin') throw new Error("Unauthorized.");
    
    // Simple ID gen: Year + Random 4 digits (e.g. 2026-4821)
    const invoiceNumber = `${new Date().getFullYear()}-${Math.floor(1000 + Math.random() * 9000)}`;
    
    const jobRef = doc(db, 'jobs', jobId);
    await updateDoc(jobRef, {
      invoicedAt: serverTimestamp(),
      invoiceNumber: invoiceNumber,
      updatedAt: serverTimestamp()
    });
  };

  return { jobs, loading, error, addJob, updateJob, deleteJob, markAsInvoiced, role: userRole };
};

```
---

## FILE: src/hooks/useProfile.js
```js
import { useState, useEffect } from 'react';
import { doc, onSnapshot, updateDoc, serverTimestamp } from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useProfile = () => {
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    // Direct User Doc Reference - Security by Design
    // We do not query collection; we bind strictly to the Auth UID.
    const userDocRef = doc(db, 'users', user.uid);

    const unsubscribe = onSnapshot(userDocRef, (docSnap) => {
      if (docSnap.exists()) {
        setProfile({ id: docSnap.id, ...docSnap.data() });
      } else {
        setError("Profile not found.");
      }
      setLoading(false);
    }, (err) => {
      console.error("Profile Fetch Error:", err);
      setError("Failed to load profile.");
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const updateProfile = async (updates) => {
    const user = auth.currentUser;
    if (!user) throw new Error("Not authenticated");

    setLoading(true);
    try {
      const userDocRef = doc(db, 'users', user.uid);
      
      // Safety: Always append audit fields
      const finalUpdates = {
        ...updates,
        updatedAt: serverTimestamp(),
      };

      await updateDoc(userDocRef, finalUpdates);
      return true;
    } catch (err) {
      console.error("Update Error:", err);
      setError("Failed to save changes.");
      throw err;
    } finally {
      setLoading(false);
    }
  };

  return { profile, loading, error, updateProfile };
};

```
---

## FILE: src/hooks/useSchedule.js
```js
import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, orderBy, Timestamp, doc, getDoc 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useSchedule = (startDate, endDate) => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [userRole, setUserRole] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user || !startDate || !endDate) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setLoading(false);
          return;
        }

        const userData = userDoc.data();
        const orgId = userData.orgId;
        const role = userData.role;
        setUserRole(role);

        if (!orgId) {
          setError("Organization ID missing.");
          setLoading(false);
          return;
        }

        // Base Constraints
        let constraints = [
          where('orgId', '==', orgId),
          where('scheduledDate', '>=', Timestamp.fromDate(startDate)),
          where('scheduledDate', '<=', Timestamp.fromDate(endDate)),
          orderBy('scheduledDate', 'asc')
        ];

        // RBAC: Staff Filter
        if (role === 'staff') {
          constraints.push(where('assignedTo', 'array-contains', user.uid));
        }

        const q = query(collection(db, 'jobs'), ...constraints);

        const unsubscribe = onSnapshot(q, (snapshot) => {
          const jobData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            scheduledDate: doc.data().scheduledDate?.toDate()
          }));
          setJobs(jobData);
          setLoading(false);
        }, (err) => {
          console.error("Error fetching schedule:", err);
          setError("Failed to load schedule.");
          setLoading(false);
        });

        return unsubscribe;
      } catch (err) {
        console.error(err);
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, [startDate, endDate]); 

  return { jobs, loading, error, role: userRole };
};

```
---

## FILE: src/hooks/useStaff.js
```js
import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, doc, getDoc 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useStaff = () => {
  const [staff, setStaff] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        // 1. Get Org ID from User Profile
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setLoading(false);
          return;
        }

        const orgId = userDoc.data().orgId;

        if (!orgId) {
          setError("No Organization found.");
          setLoading(false);
          return;
        }

        // 2. Fetch all users in this Org
        const q = query(
          collection(db, 'users'),
          where('orgId', '==', orgId)
        );

        const unsubscribe = onSnapshot(q, (snapshot) => {
          const staffData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
          }));
          setStaff(staffData);
          setLoading(false);
        }, (err) => {
          console.error("Error fetching staff:", err);
          setError("Failed to load staff list.");
          setLoading(false);
        });

        return unsubscribe;

      } catch (err) {
        console.error(err);
        setError("Error initializing staff list.");
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, []);

  return { staff, loading, error };
};

```
---

## FILE: src/index.css
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

html, body, #root {
  height: 100%;
}


```
---

## FILE: src/lib/csv.js
```js
import { format } from 'date-fns';

/**
 * Converts an array of objects to a CSV string.
 * Automatically handles escaping of special characters.
 */
export const generateCSV = (data, headers) => {
  if (!data || !data.length) return '';

  const processRow = (row) => {
    return headers.map(header => {
      let value = row[header.key];
      
      // Formatting Logic
      if (value === null || value === undefined) {
        value = '';
      } else if (value instanceof Date) {
        value = format(value, 'yyyy-MM-dd HH:mm:ss');
      } else if (typeof value === 'object') {
        // Flatten simple objects if needed, or stringify
        value = JSON.stringify(value);
      } else {
        value = String(value);
      }

      // Escape Logic: If value contains comma, newline, or quote, wrap in quotes
      if (value.includes(',') || value.includes('\n') || value.includes('"')) {
        value = `"${value.replace(/"/g, '""')}"`;
      }

      return value;
    }).join(',');
  };

  const csvRows = [
    headers.map(h => h.label).join(','), // Header Row
    ...data.map(processRow)              // Data Rows
  ];

  return csvRows.join('\n');
};

/**
 * Triggers a browser download of the CSV content
 */
export const downloadCSV = (csvContent, filename) => {
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  if (link.download !== undefined) {
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', filename);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
};

```
---

## FILE: src/lib/firebase.js
```js
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getFunctions } from "firebase/functions";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
  measurementId: import.meta.env.VITE_FIREBASE_MEASUREMENT_ID
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const functions = getFunctions(app);

// Initialize Analytics only in browser context
export const analytics = typeof window !== 'undefined' ? getAnalytics(app) : null;

```
---

## FILE: src/lib/maps.js
```js
// Utility to handle Google Maps Geocoding
const API_KEY = import.meta.env.VITE_GOOGLE_MAPS_API_KEY;

export const geocodeAddress = async (address) => {
  if (!address || !API_KEY) return null;

  try {
    // CORRECTED: No backslash before the backtick or ${
    const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(address)}&key=${API_KEY}`;
    const response = await fetch(url);
    const data = await response.json();

    if (data.status === 'OK' && data.results.length > 0) {
      const location = data.results[0].geometry.location;
      return {
        lat: location.lat,
        lng: location.lng
      };
    } else {
      console.warn("Geocoding failed:", data.status);
      return null;
    }
  } catch (error) {
    console.error("Geocoding error:", error);
    return null;
  }
};

```
---

## FILE: src/main.jsx
```jsx
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)

```
---

## FILE: src/pages/ClientsPage.jsx
```jsx
import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useClients } from '../hooks/useClients';
import ClientListMobile from '../components/clients/ClientListMobile';
import ClientTableDesktop from '../components/clients/ClientTableDesktop';
import ClientFormModal from '../components/clients/ClientFormModal';
import ExportButton from '../components/common/ExportButton';

const ClientsPage = () => {
  const { clients, loading, error, addClient, role } = useClients();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const filteredClients = clients.filter(c => 
    c.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    c.email?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const exportHeaders = [
    { key: 'name', label: 'Client Name' },
    { key: 'email', label: 'Email' },
    { key: 'phone', label: 'Phone' },
    { key: 'address', label: 'Address' },
    { key: 'lat', label: 'Latitude' },
    { key: 'lng', label: 'Longitude' }
  ];

  return (
    <div className="space-y-6">
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

          <ExportButton 
            role={role} 
            data={filteredClients} 
            filename="Clients" 
            headers={exportHeaders} 
          />

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

      <ClientFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={addClient}
      />
    </div>
  );
};

export default ClientsPage;

```
---

## FILE: src/pages/DashboardPage.jsx
```jsx
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

```
---

## FILE: src/pages/JobsPage.jsx
```jsx
import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useJobs } from '../hooks/useJobs';
import { useClients } from '../hooks/useClients';
import { useStaff } from '../hooks/useStaff';
import JobListMobile from '../components/jobs/JobListMobile';
import JobTableDesktop from '../components/jobs/JobTableDesktop';
import JobFormModal from '../components/jobs/JobFormModal';
import InvoiceModal from '../components/invoicing/InvoiceModal';
import ExportButton from '../components/common/ExportButton';

const JobsPage = () => {
  const { jobs, loading: jobsLoading, error: jobsError, addJob, updateJob, deleteJob, markAsInvoiced, role: userRole } = useJobs();
  const { clients, loading: clientsLoading } = useClients(); 
  const { staff, loading: staffLoading } = useStaff();

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingJobId, setEditingJobId] = useState(null);
  const [invoicingJobId, setInvoicingJobId] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  const loading = jobsLoading || clientsLoading || staffLoading;

  const filteredJobs = jobs.filter(job => {
    const clientName = clients.find(c => c.id === job.clientId)?.name?.toLowerCase() || '';
    return clientName.includes(searchTerm.toLowerCase());
  });

  // Prepare data for export (Flattening)
  const exportData = filteredJobs.map(job => {
    const client = clients.find(c => c.id === job.clientId);
    const assignedMember = job.assignedTo?.[0] ? staff.find(s => s.id === job.assignedTo[0]) : null;
    
    return {
      ...job,
      clientName: client ? client.name : 'Unknown',
      clientAddress: client ? client.address : '',
      assignedToName: assignedMember ? assignedMember.fullName : 'Unassigned',
      // Format timestamps for CSV
      scheduledDate: job.scheduledDate, 
      completedAt: job.completedAt
    };
  });

  const exportHeaders = [
    { key: 'invoiceNumber', label: 'Invoice #' },
    { key: 'clientName', label: 'Client' },
    { key: 'clientAddress', label: 'Address' },
    { key: 'serviceType', label: 'Service' },
    { key: 'price', label: 'Price' },
    { key: 'status', label: 'Status' },
    { key: 'scheduledDate', label: 'Scheduled' },
    { key: 'completedAt', label: 'Completed' },
    { key: 'assignedToName', label: 'Staff' }
  ];

  const editingJob = editingJobId ? jobs.find(j => j.id === editingJobId) : null;
  const invoicingJob = invoicingJobId ? jobs.find(j => j.id === invoicingJobId) : null;

  const handleCreateOpen = () => {
    setEditingJobId(null);
    setIsModalOpen(true);
  };

  const handleEditOpen = (job) => {
    setEditingJobId(job.id);
    setIsModalOpen(true);
  };

  const handleInvoiceOpen = (job) => {
    setInvoicingJobId(job.id);
  };

  const handleSave = async (formData) => {
    if (editingJobId) {
      await updateJob(editingJobId, formData);
    } else {
      await addJob(formData);
    }
  };

  const handleDelete = async (jobId) => {
    if (window.confirm("Are you sure you want to delete this job? This cannot be undone.")) {
      await deleteJob(jobId);
    }
  };

  const handleMarkInvoiced = async (jobId) => {
    await markAsInvoiced(jobId);
  };

  return (
    <div className="space-y-6">
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

          <ExportButton 
            role={userRole}
            data={exportData}
            filename="Jobs"
            headers={exportHeaders}
          />

          {userRole === 'admin' && (
            <button 
              onClick={handleCreateOpen}
              className="bg-brand-600 text-white px-4 py-2 rounded-lg font-semibold hover:bg-brand-700 flex items-center gap-2 shadow-sm whitespace-nowrap"
            >
              <Plus size={20} />
              <span className="hidden md:inline">New Job</span>
              <span className="md:hidden">New</span>
            </button>
          )}
        </div>
      </div>

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
          <JobListMobile 
            jobs={filteredJobs} 
            clients={clients} 
            staff={staff} 
            userRole={userRole} 
            onEdit={handleEditOpen}
            onInvoice={handleInvoiceOpen}
          />
          <JobTableDesktop 
            jobs={filteredJobs} 
            clients={clients} 
            staff={staff} 
            userRole={userRole} 
            onEdit={handleEditOpen}
            onDelete={handleDelete}
            onInvoice={handleInvoiceOpen}
          />
        </>
      )}

      <JobFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={handleSave} 
        clients={clients} 
        staff={staff}
        initialData={editingJob}
      />

      <InvoiceModal 
        isOpen={!!invoicingJob}
        onClose={() => setInvoicingJobId(null)}
        job={invoicingJob}
        client={invoicingJob ? clients.find(c => c.id === invoicingJob.clientId) : null}
        onMarkInvoiced={handleMarkInvoiced}
      />
    </div>
  );
};

export default JobsPage;

```
---

## FILE: src/pages/SchedulePage.jsx
```jsx
import React, { useState } from 'react';
import { startOfWeek, endOfWeek, isSameDay } from 'date-fns';
import { Map, List } from 'lucide-react';
import { useSchedule } from '../hooks/useSchedule';
import { useClients } from '../hooks/useClients';
import DateStrip from '../components/schedule/DateStrip';
import DailyAgenda from '../components/schedule/DailyAgenda';
import MapComponent from '../components/map/MapComponent';

const SchedulePage = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [viewMode, setViewMode] = useState('list'); // 'list' | 'map'

  const weekStart = startOfWeek(selectedDate, { weekStartsOn: 1 }); 
  const weekEnd = endOfWeek(selectedDate, { weekStartsOn: 1 });      

  const { jobs, loading: scheduleLoading, error, role: userRole } = useSchedule(weekStart, weekEnd);
  const { clients, loading: clientsLoading } = useClients();

  const todaysJobs = jobs.filter(job => 
    job.scheduledDate && isSameDay(job.scheduledDate, selectedDate)
  );

  return (
    <div className="bg-gray-50 min-h-full pb-20">
      <div className="sticky top-0 z-10 bg-white border-b border-gray-200">
        <DateStrip 
          selectedDate={selectedDate} 
          onSelectDate={setSelectedDate} 
        />
        
        {/* View Toggle Bar */}
        <div className="flex justify-center p-2 bg-gray-50 border-b border-gray-200">
          <div className="bg-white p-1 rounded-lg border border-gray-200 flex shadow-sm">
            <button
              onClick={() => setViewMode('list')}
              // CORRECTED: No backslashes here
              className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-sm font-medium transition-colors ${
                viewMode === 'list' ? 'bg-brand-50 text-brand-700' : 'text-slate-500 hover:text-slate-700'
              }`}
            >
              <List size={16} /> List
            </button>
            <button
              onClick={() => setViewMode('map')}
              // CORRECTED: No backslashes here
              className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-sm font-medium transition-colors ${
                viewMode === 'map' ? 'bg-brand-50 text-brand-700' : 'text-slate-500 hover:text-slate-700'
              }`}
            >
              <Map size={16} /> Map
            </button>
          </div>
        </div>
      </div>

      <main className="p-4 max-w-3xl mx-auto">
        {error && (
          <div className="p-4 mb-4 bg-red-50 text-red-600 rounded-lg text-sm text-center">
            {error}
          </div>
        )}

        {viewMode === 'list' ? (
          <DailyAgenda 
            jobs={todaysJobs} 
            clients={clients} 
            loading={scheduleLoading || clientsLoading} 
            selectedDate={selectedDate}
            userRole={userRole} 
          />
        ) : (
          <MapComponent 
            jobs={todaysJobs}
            clients={clients}
          />
        )}
      </main>
    </div>
  );
};

export default SchedulePage;

```
---

## FILE: src/pages/SettingsPage.jsx
```jsx
import React, { useState } from 'react';
import { Mail, User, Shield, Plus, Loader, UserCog, Building } from 'lucide-react';
import { useStaff } from '../hooks/useStaff';
import { useProfile } from '../hooks/useProfile'; // Check own role
import { auth, db } from '../lib/firebase';
import { collection, addDoc, serverTimestamp, doc, getDoc } from 'firebase/firestore';
import ProfileForm from '../components/settings/ProfileForm';

const SettingsPage = () => {
  const { profile } = useProfile(); // Get current user's role
  const { staff, loading: staffLoading } = useStaff();
  
  const [activeTab, setActiveTab] = useState('profile'); // 'profile' | 'team'
  const [inviteEmail, setInviteEmail] = useState('');
  const [inviteRole, setInviteRole] = useState('staff');
  const [inviteLoading, setInviteLoading] = useState(false);

  const isAdmin = profile?.role === 'admin';

  const handleInvite = async (e) => {
    e.preventDefault();
    setInviteLoading(true);
    try {
      const user = auth.currentUser;
      const orgId = profile.orgId; // Use profile orgId, redundant fetch removed for speed

      await addDoc(collection(db, 'invites'), {
        email: inviteEmail,
        role: inviteRole,
        orgId,
        status: 'pending',
        invitedBy: user.uid,
        createdAt: serverTimestamp()
      });

      alert(`Invite sent to ${inviteEmail}`);
      setInviteEmail('');
    } catch (error) {
      console.error(error);
      alert("Failed to send invite.");
    } finally {
      setInviteLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Settings</h1>
        <p className="text-slate-500 text-sm">Manage your profile and preferences</p>
      </div>

      {/* TAB NAVIGATION */}
      <div className="flex border-b border-gray-200">
        <button
          onClick={() => setActiveTab('profile')}
          className={`flex items-center gap-2 px-6 py-3 font-medium text-sm transition-colors border-b-2 ${
            activeTab === 'profile' 
              ? 'border-brand-600 text-brand-600' 
              : 'border-transparent text-slate-500 hover:text-slate-700'
          }`}
        >
          <UserCog size={18} />
          My Profile
        </button>
        
        {isAdmin && (
          <button
            onClick={() => setActiveTab('team')}
            className={`flex items-center gap-2 px-6 py-3 font-medium text-sm transition-colors border-b-2 ${
              activeTab === 'team' 
                ? 'border-brand-600 text-brand-600' 
                : 'border-transparent text-slate-500 hover:text-slate-700'
            }`}
          >
            <Building size={18} />
            Organization & Team
          </button>
        )}
      </div>

      {/* TAB CONTENT: MY PROFILE */}
      {activeTab === 'profile' && (
        <div className="max-w-2xl">
          <ProfileForm />
        </div>
      )}

      {/* TAB CONTENT: TEAM (Admin Only) */}
      {activeTab === 'team' && isAdmin && (
        <div className="space-y-6 animate-in fade-in duration-300">
          
          {/* Staff List Card */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
              <h3 className="font-bold text-slate-800 flex items-center gap-2">
                <User size={20} className="text-brand-500" />
                Team Members
              </h3>
            </div>
            
            <div className="divide-y divide-gray-100">
              {staffLoading ? (
                <div className="p-6 text-center text-slate-400">Loading staff...</div>
              ) : staff.map((member) => (
                <div key={member.id} className="p-4 flex items-center justify-between hover:bg-gray-50">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-brand-100 rounded-full flex items-center justify-center text-brand-600 font-bold">
                      {(member.email || '?')[0].toUpperCase()}
                    </div>
                    <div>
                      <p className="font-medium text-slate-900">{member.fullName || 'Unnamed User'}</p>
                      <p className="text-xs text-slate-500">{member.email}</p>
                    </div>
                  </div>
                  <span className={`px-2 py-1 rounded text-xs font-bold uppercase ${
                    member.role === 'admin' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700'
                  }`}>
                    {member.role}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Invite Form Card */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 bg-gray-50">
              <h3 className="font-bold text-slate-800 flex items-center gap-2">
                <Mail size={20} className="text-brand-500" />
                Invite New Member
              </h3>
            </div>
            <form onSubmit={handleInvite} className="p-6 flex flex-col md:flex-row gap-4 items-end">
              <div className="flex-1 w-full">
                <label className="block text-sm font-medium text-slate-700 mb-1">Email Address</label>
                <input 
                  type="email" 
                  required
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
                  placeholder="colleague@freshnest.com"
                  value={inviteEmail}
                  onChange={(e) => setInviteEmail(e.target.value)}
                />
              </div>
              <div className="w-full md:w-48">
                <label className="block text-sm font-medium text-slate-700 mb-1">Role</label>
                <select 
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none bg-white"
                  value={inviteRole}
                  onChange={(e) => setInviteRole(e.target.value)}
                >
                  <option value="staff">Staff</option>
                  <option value="admin">Admin</option>
                </select>
              </div>
              <button 
                type="submit" 
                disabled={inviteLoading}
                className="w-full md:w-auto px-6 py-2 bg-brand-600 text-white rounded-lg font-medium hover:bg-brand-700 disabled:opacity-50 flex items-center justify-center gap-2"
              >
                {inviteLoading ? <Loader className="animate-spin" size={18} /> : <Plus size={18} />}
                Send Invite
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default SettingsPage;

```
---

## FILE: docs/CHANGELOG.md
```md
# 📜 Changelog

## [v0.1.1] - 2026-01-14
### Added
* **Smart Profile:** A dedicated settings view for workers to manage constraints.
* **Financial Safety:** Input for Monthly Earning Caps (ODSP support).
* **Recovery Support:** Blocked Window selector for recurring unavailability.
* **Transport Mode:** Icon-based toggle for Public Transit vs Personal Vehicle.
* **Versioning:** Automated semantic versioning in CI/CD pipeline.

## [v0.1.0] - 2026-01-14
* **MVP Gold Master:** Core functionality (Jobs, Clients, Invoicing).

```
---

## FILE: docs/CONTEXT_DUMP.md
```md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Version:** v0.1.1
**Architecture:** Multi-Tenant SaaS.

## 🧠 The "Prime Directive"
We build for **Personas**. Safety > Efficiency.
* **Carla (ODSP):** Never allow over-earning.
* **Mike (Recovery):** Never schedule during meetings.
* **Ahmed (ESL):** Icons over Text.

## Documentation References
* **Schema:** See `docs/SCHEMA_REFERENCE.md`
* **Security:** See `docs/RBAC_MATRIX.md`

## Architecture Rules (STRICT)
1. **NO PLACEHOLDERS:** Complete files only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security:** Use `useProfile` hook to fetch user data. Do NOT use Auth Tokens.
5. **Logic:** * **Profile:** Managed via `ProfileForm.jsx`.
   * **Jobs:** Managed via `useJobs` / `useJobWorkflow`.

## Schema (Implemented)
- **users/{userId}**: 
    - `financials`: { mode: 'cap' | 'unlimited', limit: number }
    - `constraints`: { blockedWindows: ['tue_evening', ...] }
    - `profile`: { transport: 'transit' | 'vehicle' }
- **jobs/{jobId}**: { status, price, scheduledDate, assignedTo: [] }

```
---

## FILE: docs/DEVOPS_MANUAL.md
```md
# ☁️ DevOps & Infrastructure Manual

## 1. CI/CD Architecture
We use **GitHub Actions** for "Full Stack" deployments.
* **Workflows:** `.github/workflows/`
* **Triggers:** `dev` (Dev), `release/*` (UAT), `main` (Prod).

## 2. Environment Management
Scripts in `/scripts` handle data seeding. Always pass the env arg (e.g., `node scripts/init-org.cjs uat`).

## 3. GitHub Secrets (Required)
| Secret Name | Content |
| :--- | :--- |
| `FIREBASE_SERVICE_ACCOUNT_[ENV]` | JSON key for Firebase Admin |
| `ENV_FILE_[ENV]` | Full contents of `.env` |

## 4. Google Maps Setup (New Project)
If creating a new environment (e.g., Staging), you MUST:
1.  **GCP Console:** Enable "Maps JavaScript API" and "Geocoding API".
2.  **Billing:** Link the project to your Billing Account (Critical).
3.  **Credentials:** Create an API Key.
4.  **Secrets:** Add `VITE_GOOGLE_MAPS_API_KEY=...` to the `ENV_FILE_[ENV]` GitHub Secret.

## 5. Troubleshooting
**"Billing Not Setup" on Map:**
* Go to GCP Console -> Billing -> Link the project to your account.

**"Missing Permissions" in CI/CD:**
* Grant `firebase-adminsdk` Service Account "Editor" or "Cloud Datastore User" roles.

```
---

## FILE: docs/PERSONAS.md
```md
# 👥 Fresh Nest Personas (Technical Constraints)

These are not just user stories. These are **System Constraints**. Every feature must be validated against these realities.

## 1. Carla - The "Financial Anchor" (ODSP)
* **Context:** Single mother, relies on Ontario Disability Support Program (ODSP).
* **Hard Constraint:** **Earnings Cap.** She *cannot* earn more than her allowable limit (e.g., $1,000/mo) without triggering a clawback mechanism that destabilizes her housing.
* **Tech Requirement:** * `user.financials.limit`: Hard integer limit.
    * **Pre-Claim Check:** System must block a shift claim if `(currentMonthEarnings + shiftPrice) > limit`.
    * **Visuals:** "Safe to Earn" progress bar.

## 2. Jasmine - The "Transit Rider"
* **Context:** No vehicle. Relies on Cornwall Transit.
* **Hard Constraint:** **Travel Time Buffers.** She cannot teleport. A 1:00 PM job across town after a 12:00 PM job is physically impossible.
* **Tech Requirement:**
    * `user.constraints.transport`: 'transit'.
    * **Conflict Engine:** Auto-calculate travel time via Google Maps Transit API (future) or enforce 60-min buffers between sites.

## 3. Mike - The "Recovery Worker"
* **Context:** Re-entering workforce. Attends mandatory support meetings (e.g., AA) every Tuesday at 7 PM.
* **Hard Constraint:** **Blocked Windows.**
* **Tech Requirement:**
    * `user.constraints.blockedWindows`: Array of recurring time slots.
    * **Visibility Filter:** Shifts overlapping these windows must be strictly hidden from his view.

## 4. Ahmed - The "Newcomer" (ESL)
* **Context:** Recent immigrant. High work ethic, low English literacy.
* **Hard Constraint:** **Cognitive Load.** Text-heavy instructions result in errors.
* **Tech Requirement:**
    * **Icon-First UI:** Tasks must use visual icons (Mop, Key, Trash).
    * **Language Toggle:** One-tap switch between English/French/Arabic.

## 5. Brenda - The "Visual Verifier"
* **Context:** Detail-oriented, anxious about "he said/she said" disputes.
* **Hard Constraint:** **Trust.** Needs proof she did the job right.
* **Tech Requirement:**
    * **Photo Uploads:** Mandatory "Before" and "After" photos for specific high-value items (e.g., Stove).
    * **Metadata:** Photos must be timestamped and geo-tagged.

## 6. Sarah - The "Owner" (Compliance)
* **Context:** Business owner. Terrified of labor board audits and liability.
* **Hard Constraint:** **Audit Trail.**
* **Tech Requirement:**
    * **Version Control:** `acceptedTermsVersion` stored on every user profile.
    * **Rate Snapshots:** Every shift record must freeze the pay rate at the time of claim.


```
---

## FILE: docs/PROJECT_STATUS.md
```md
# 📌 Project Status: Fresh Nest (Worker Support Platform)

**Current Phase:** Phase 1 - Safety Logic & Enforcement
**Current Version:** v0.1.1 (Smart Profile Live)
**Context:** Cornwall, Ontario Socioeconomic Deployment
**Last Updated:** $(date +%Y-%m-%d)

> **Mission:** To transform the cleaning industry into a system of stability for marginalized workers while maintaining enterprise-grade reliability.

## ✅ Completed (Sprint 1: The Smart Profile)
* **User Schema V2:** Added `financials`, `constraints`, and `transport` objects.
* **Profile Wizard:** Mobile-first, icon-based form for staff self-declaration.
* **Audit Trail:** Mandatory `acceptedTermsVersion` tracking.
* **Localization Prep:** Visual language toggle in settings.

## 🎯 Current Sprint: The Guardian Logic (Sprint 2)
Now that we know the constraints, we must enforce them.

* [ ] **Financial Guardrails (Carla):**
    * Logic: `currentEarnings + jobPrice > cap` = **Disable Claim**.
    * UI: Visual "Earnings Bar" on Dashboard.
* [ ] **Conflict Engine (Mike):**
    * Logic: Filter out jobs overlapping with `blockedWindows`.
* [ ] **Transport Buffers (Jasmine):**
    * Logic: If `transport === 'transit'`, add 30min buffer between shifts.

## 📋 Product Backlog (Master Plan 9)

### Phase 2: Field Operations
* **Visual Interface:** Replace text-heavy lists with Icon-based tasks (Mop, Toilet).
* **Job Evidence:** Photo uploads to specific sub-collections.
* **Inventory Reports:** Specific inputs for Airbnb supplies.

### Phase 3: Support & Scale
* **Crisis Protocol:** "SOS" button logic.
* **Impact Dashboard:** Report on "Hours created for ODSP workers".

---

## 🗄️ Database Schema Snapshot (Target State)

### `users/{userId}`
* `profile`: { name, language, transport, acceptedTermsVersion }
* `financials`: { mode: 'cap', limit: number, currentMonthAccrued: number }
* `constraints`: { heavyLifting: boolean, blockedWindows: array }
* `role`: 'admin' | 'staff'
* `orgId`: string

### `jobs/{jobId}`
* `status`: 'open' | 'claimed' | 'completed'
* `price`: number
* `scheduledDate`: timestamp
* `requirements`: { photoEvidence: array }


```
---

## FILE: docs/PROMPT_APPROVAL.md
```md
# ✅ AI Approval & Execution Prompt (v9.0 Persona-Aware)

**Instructions:**
Use this prompt **after** the AI has presented the 3 Architectural Options. This signals approval for the **Recommended (Robust)** approach and enforces strict **Persona & Compliance** standards.

---

### **Prompt Template**

**Decision:** I approve the **Recommended (Robust) Approach**. Proceed with implementation.

**Strict Technical Constraints (The "Fresh Nest" Standard):**
1.  **React & Accessibility:** * Use functional components with **Icon-First Design** (Lucide React).
    * Ensure all text is wrapped for future **Localization (i18n)**.
    * **Mobile First:** Tailwind classes must be `block md:flex`.
2.  **Firebase & Security (CRITICAL):**
    * **NO AUTH TOKENS:** Do NOT use `idTokenResult` or `request.auth.token` for logic. Fetch the **User Profile** from Firestore.
    * **Privacy Map:** Adhere to strict visibility rules. (e.g., Financials are private to the user + Admin).
    * **Writes:** ALL `addDoc`/`updateDoc` calls must include `orgId` and `updatedAt` (serverTimestamp).
3.  **Code Quality:** No "placeholder" code. Complete files only.

**Persona & Compliance Checks (Mandatory):**
* **The "Ahmed" Check (Learner):** Is the UI simple enough? Did we rely too much on dense text?
* **The "Carla" Check (Financial):** Does this feature respect the **Earnings Cap** logic? (Never allow work that exceeds the limit).
* **The "Sarah" Check (Admin):** Is there an Audit Trail? (Who changed what and when?).

**Output Requirements:**

1.  **The "One-Shot" Installer:**
    * Provide a single bash script named `scripts/install_feature.sh`.
    * This script must use `cat << 'EOF' > path/to/file` to safely create/overwrite files.
    * *Note:* Escape special characters (`$`) in the bash script correctly.

2.  **QA Checklist (Manual Testing):**
    * Provide 3-5 specific tests.
    * **Mandatory:** Include a **"Persona Audit"** (e.g., "Log in as a Worker with a $500 cap -> Verify 'Claim' button is disabled if job > cap").
    * **Mandatory:** Include a **"Data Integrity"** test (e.g., "Verify Firestore Contract Ledger has the rate snapshot").

3.  **Firestore Indexes:**
    * Explicitly state if `firestore.indexes.json` needs an update.

4.  **Git Documentation:**
    * Provide a **Git Commit Comment Block** at the end.
    * Format: `feat: [summary]`, Description: Bullet points of changes.

*Please generate the installation script, test checklist, and git docs now.*

```
---

## FILE: docs/PROMPT_FEATURE_COMPLETION.md
```md
# ✅ Feature Completion & Release Protocol

**Instructions:**
1.  When you have finished testing a feature in DEV and are ready to merge.
2.  Copy the **Prompt Template** below.
3.  Fill in the `[ ... ]` brackets.
4.  Paste it into the AI Chat.

---

### **Prompt Template**

**Action:** Close Feature & Prepare Release
**Feature Name:** [INSERT FEATURE NAME, e.g., Job Assignment]
**Current Branch:** [INSERT BRANCH NAME, e.g., feature/job-assignment]

**Context:**
I have successfully implemented and tested this feature in the DEV environment. It is ready to be merged into `main` and documented.

**Your Task:**
Please generate a single "Close-Out Script" (`scripts/close_feature.sh`) that performs the following actions:

1.  **Documentation Updates:**
    * Update `docs/PROJECT_STATUS.md`: Move the feature from "In Progress" to "Completed".
    * Update `docs/CONTEXT_DUMP.md`: If the schema or architecture changed, update the definitions to match the new reality.
    * *Note:* Use `cat << 'EOF'` to overwrite these files with the updated content.

2.  **Git Workflow:**
    * Stage and Commit any remaining changes.
    * Switch to `main`.
    * Pull the latest `main`.
    * Merge the feature branch.
    * Push `main` to origin.
    * Delete the local feature branch.

3.  **Deployment (UAT):**
    * Run the build script (to increment the version number).
    * Deploy the `main` branch to the **UAT** environment (`firebase deploy --only hosting:uat,firestore:rules`).

**Output Requirement:**
Provide the complete, executable bash script. Do not execute it yourself; just provide the code.

```
---

## FILE: docs/PROMPT_FEATURE_REQUEST.md
```md
# 📝 AI Feature Request Prompt (Persona-Driven Mode)

**Instructions:**
1.  Run `scripts/generate-context.sh` to copy your current codebase to your clipboard.
2.  Paste the output into the **[PASTE_CODEBASE_HERE]** section at the bottom.
3.  Fill in the feature details in the bracketed sections `[ ... ]`.
4.  Send the *entire* text below to the AI.

---

### **Prompt Template**

**Role:** You are the **Worker Support Architect** for "Fresh Nest," a platform designed to stabilize the cleaning industry in Cornwall, Ontario.
**Task:** Analyze the codebase and design a feature that balances **Technical Robustness** with **Human Constraints**.

**Feature Request:** [INSERT FEATURE NAME]

**Context:**
I need to add a module that allows [WHO] to [DO WHAT].
*Current State:* [Briefly describe relevant existing code.]

**Core Requirements:**

1.  **👥 The Persona Check (CRITICAL):**
    * **Review:** Read `docs/PERSONAS.md`.
    * **Validation:** specific check against:
        * **Carla (ODSP):** Does this affect financial eligibility?
        * **Ahmed (ESL):** Is the UI text-heavy or Icon-based?
        * **Jasmine (Transit):** Does this respect travel buffers?
        * **Sarah (Compliance):** Does this generate an audit trail?

2.  **Data & Schema:**
    * **Audit Trail:** If this involves money or contracts, we MUST record a snapshot (e.g., `rateSnapshot`, `acceptedTermsVersion`).
    * **Reference:** Check `docs/SCHEMA_REFERENCE.md`.

3.  **UI (Accessibility & Field First):**
    * **Mobile:** Design for a 375px screen with "Fat Finger" touch targets.
    * **Cognitive Load:** Use **Icons** (Lucide) over text labels where possible.
    * **Parity:** Is this feature *required* in the field? If so, it must be Mobile-First.

4.  **Security & RBAC:**
    * **Constraint:** **NEVER** use `auth.token`. Always fetch `users/{uid}` profile.
    * **Permissions:** Check `docs/RBAC_MATRIX.md`.

**🛑 STOP & THINK: Architectural Options**
Before writing any code, please propose **3 Distinct Approaches**:

1.  **The "High-Safety" Approach:** Prioritizes validation, audit trails, and strict constraints (Best for Master Plan 9).
2.  **The "Low-Friction" Approach:** Prioritizes speed and UI simplicity (Best for simple CRUD).
3.  **The "Automation" Approach:** Uses Cloud Functions to handle logic server-side.

**Your Task:**
1.  **Analyze Context:** Read `docs/PERSONAS.md` and `docs/CONTEXT_DUMP.md`.
2.  **Persona Impact Statement:** Write 1-2 sentences on how this feature helps/protects a specific persona (e.g., "This helps Brenda trust the system by uploading photos").
3.  **Compare Options:** Briefly describe the 3 approaches above.
4.  **Recommendation:** Recommend the best approach for **Safety & Stability**.
5.  **Specifications:** List exact **Schema Changes**, **New Dependencies**, and **New Files**.
6.  **WAIT** for my confirmation before generating any code.

---

**Codebase Context:**
[PASTE_CODEBASE_HERE]

```
---

## FILE: docs/PROMPT_INITIALIZATION.md
```md
# 🤖 AI Session Initialization Prompt

**Instructions:**
1.  Run `scripts/generate-context.sh` to copy your current codebase.
2.  Paste the **Codebase Context** into the bottom of this prompt.
3.  Send the *entire* block below to your AI assistant.

---

**Role:** You are the Senior Lead Developer and Architect for "Fresh Nest," a React + Firebase SaaS application.

**Input:** I am providing the full codebase context below.

**Your Goal:** Ingest this context to completely understand our:
* **Tech Stack:** React (Vite), Tailwind CSS, Firebase (Auth, Firestore, Functions).
* **Architecture:** Multi-Tenant SaaS.
* **CRITICAL ARCHITECTURE RULE:** We do **NOT** rely on Custom Claims for `orgId` in the frontend. We fetch the Firestore Profile.

**Critical Rules for Interaction:**
1.  **NO Placeholders:** Never use `// ... rest of code`. Provide **COMPLETE FILES**.
2.  **Mobile First:** All UI must be fully responsive.
3.  **Icons:** Use `lucide-react`.
4.  **Security & Data:**
    * **NEVER** use `idTokenResult.claims.orgId`. Fetch the user profile from DB.
    * Every query MUST filter by `.where("orgId", "==", user.orgId)`.
    * Every write must include `orgId`.
5.  **Quality:**
    * All buttons/inputs must be functional.
    * Adhere to HTML best practices.

**Codebase Context:**
[PASTE_FULL_CODEBASE_CONTEXT_HERE]

**Reply "Context Received. Ready for instructions." if you understand.**

```
---

## FILE: docs/RBAC_MATRIX.md
```md
# 🛡️ Role-Based Access Control (RBAC) Matrix

**Roles:** `admin` (Owner), `staff` (Worker)
**Enforcement:** 1. **Frontend:** UI Hiding via `useJobWorkflow` / `userRole`.
2. **Backend:** Firestore Security Rules (checks `resource.data.orgId`).

| Feature | Action | Admin | Staff | Notes |
| :--- | :--- | :---: | :---: | :--- |
| **Dashboard** | View KPIs | ✅ | ❌ | Revenue, Avg Ticket, Total Jobs. |
| | View Charts | ✅ | ❌ | Monthly Revenue Trends. |
| | View "My Jobs"| ✅ | ✅ | Staff see their assigned list. |
| **Clients** | View List | ✅ | ✅ | Staff see all clients in Org. |
| | Create/Edit | ✅ | ❌ | |
| **Jobs** | View List | ✅ | ⚠️ | Staff only see *assigned* jobs. |
| | Create Job | ✅ | ❌ | |
| | Edit Details | ✅ | ❌ | Price, Notes, Service Type. |
| | Start Job | ✅ | ✅ | Only if assigned (Staff). |
| | Complete Job | ✅ | ✅ | Only if assigned (Staff). |
| | Cancel Job | ✅ | ❌ | |
| | Delete Job | ✅ | ❌ | |
| **Invoicing** | Generate | ✅ | ❌ | |
| **Data Export** | Download CSV | ✅ | ❌ | Prevent data theft. |
| **Settings** | Invite User | ✅ | ❌ | |
| **Financials**| See Prices | ✅ | ❌ | Hidden in UI for Staff. |

```
---

## FILE: docs/SCHEMA_REFERENCE.md
```md
# 🗄️ Firestore Schema & Business Logic

## `users/{userId}`
* **profile** (map):
  * `name` (string)
  * `language` (string): 'en', 'fr', etc. (For Ahmed)
  * `transport` (string): 'transit' | 'vehicle' (For Jasmine)
  * `acceptedTermsVersion` (string): e.g., "v1.0_2025" (For Sarah)
* **financials** (map):
  * `mode`: 'cap' | 'unlimited'
  * `limit` (number): Monthly hard cap (For Carla)
  * `currentMonthAccrued` (number): Real-time counter.
* **constraints** (map):
  * `blockedWindows` (array): Time slots (For Mike)
  * `heavyLifting` (boolean)
* **role** (string): 'admin' | 'staff' | 'care_coordinator'
* **orgId** (string)

## `jobs/{jobId}` (aka Shifts)
* **status**: 'open' | 'claimed' | 'completed' | 'cancelled'
* **contractLedger** (map): (Financial Audit Trail)
  * `claimedBy`: userId
  * `claimedAt`: timestamp
  * `rateSnapshot`: number (Hourly/Fixed rate at time of claim)
* **requirements** (map):
  * `photos`: array of URLs (For Brenda)
* **time**:
  * `start`: timestamp
  * `end`: timestamp
* **location**:
  * `address`: string
  * `coordinates`: { lat, lng }

## `clients/{clientId}`
* **Standard fields**: name, address, etc.


```
---

## FILE: docs/SOP_SOURCE_CONTROL.md
```md
# 🛡️ Source Control & CI/CD Protocol

## 1. The Environment Pipeline

| Environment | URL | Trigger Branch | Deployed By |
| :--- | :--- | :--- | :--- |
| **DEV** | `fresh-nest-dev` | `dev` | **Auto** (Push to dev) |
| **UAT** | `fresh-nest-uat` | `release/*` | **Script** (`release_to_uat.sh`) |
| **PROD** | `fresh-nest-prod` | `main` | **Script** (`promote_to_prod.sh`) |

## 2. Daily Workflow
1.  **Start:** `git checkout main` -> `git pull` -> `./scripts/start-feature.sh`
2.  **Work:** Commit often to `feature/...`
3.  **Test Cloud:** Run `./scripts/merge_to_dev.sh` to deploy to Dev.
4.  **Finish:** Run `./scripts/close_feature.sh` (or merge PR) to close.

## 3. Releases
* **To UAT:** Run `./scripts/release_to_uat.sh`
* **To Prod:** Run `./scripts/promote_to_prod.sh` (Must be on release branch)

## 4. Emergency Fixes (Hotfix)
1.  Branch from `main`: `git checkout -b fix/critical-bug main`
2.  Fix and Commit.
3.  Merge to `main` and `dev`.

```
---

## FILE: scripts/close_feature.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE CLOSE-OUT
# Feature: Invoicing & PDF Generation
# ====================================================

echo "🏁 Initiating Close-Out for: Invoicing..."

# 1. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 4 - Revenue & Reporting
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding.
* **Jobs:** Scheduling, CRUD, Workflow, Maps.
* **Invoicing:** PDF Generation, Status Tracking (Invoiced/Draft).
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Revenue Dashboard:** Visual charts for Earnings (Daily/Monthly).
* [ ] **Data Export:** CSV export for accounting.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: 
    - `status`: 'scheduled'|'in_progress'|'completed'|'cancelled'
    - `invoiceNumber`: String
    - `invoicedAt`: Timestamp
    - `price`: Number
* `clients/{clientId}`: { name, address, coordinates, ... }
INNER_EOF

# 2. Update Context Dump (Schema Update)
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **jobs/{jobId}**: 
    - `assignedTo`: [userId]
    - `status`: 'scheduled' | 'in_progress' | 'completed' | 'cancelled'
    - `invoiceNumber`: String (e.g. "2026-1023")
    - `invoicedAt`: Timestamp
    - `price`: Number
- **clients/{clientId}**: { coordinates: { lat, lng }, ... }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId`.** Fetch `users/{uid}`.
   - All queries must filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **State Management:**
   - Prefer deriving state from lists (e.g. `jobs.find(id)`) over storing object snapshots to prevent stale data.
INNER_EOF

# 3. Commit Final Changes
echo "🌿 Committing Documentation..."
git add .
git commit -m "feat: complete invoicing module and update docs"

# 4. Cut Release (Triggers UAT)
VERSION="v0.5.0-invoicing-$(date +%s)"
echo "🚀 Cutting Release Branch: release/$VERSION"

git checkout -b "release/$VERSION"
git push origin "release/$VERSION"

echo "✅ Release Pushed to GitHub!"
echo "👉 Action: 'Deploy to UAT' should be running now."

# 5. Merge to Dev & Cleanup
echo "🔄 Syncing Dev Branch..."
git checkout dev
git pull origin dev
git merge "feature/invoicing"
git push origin dev

# 6. Delete Local Feature Branch
echo "🗑️  Deleting local feature branch..."
git branch -d feature/invoicing

echo "🎉 SUCCESS! Feature Closed."
echo "   - UAT is deploying (release/$VERSION)"

```
---

## FILE: scripts/create_staff_user.cjs
```cjs
const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

// --- ARGS HANDLING ---
// Usage: node scripts/create_staff_user.cjs [env]
const env = process.argv[2] || 'dev';
const keyFilename = env === 'dev' ? 'service-account.json' : `service-account-${env}.json`;
const keyPath = path.join(__dirname, keyFilename);

// --- CONFIGURATION ---
const ADMIN_EMAIL = "rpdouglas@gmail.com"; 
const STAFF_EMAIL = "staff@freshnest.com"; 
const STAFF_PASSWORD = "password123";
// ---------------------

if (!fs.existsSync(keyPath)) {
  console.error(`❌ ERROR: Could not find key file: ${keyFilename}`);
  process.exit(1);
}

const serviceAccount = require(keyPath);
console.log(`🌍 Environment: ${env.toUpperCase()}`);

if (!admin.apps.length) {
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}
const db = admin.firestore();
const auth = admin.auth();

async function createStaff() {
  try {
    console.log(`🔍 Finding Admin Org for: ${ADMIN_EMAIL}...`);
    
    // 1. Find Admin to get the correct Org ID
    let adminUser;
    try {
      adminUser = await auth.getUserByEmail(ADMIN_EMAIL);
    } catch (e) {
      console.error(`❌ Admin user ${ADMIN_EMAIL} not found in Auth! Run init-org.cjs first.`);
      return;
    }

    const adminProfile = await db.collection('users').doc(adminUser.uid).get();
    if (!adminProfile.exists) {
      console.error(`❌ Admin profile not found in Firestore.`);
      return;
    }

    const orgId = adminProfile.data().orgId;
    console.log(`✅ Found Org ID: ${orgId}`);

    // 2. Create/Get Staff User
    console.log(`👤 Creating/Updating Staff User: ${STAFF_EMAIL}...`);
    let staffUser;
    try {
      staffUser = await auth.getUserByEmail(STAFF_EMAIL);
      console.log(`   User already exists (UID: ${staffUser.uid})`);
    } catch {
      staffUser = await auth.createUser({ 
        email: STAFF_EMAIL, 
        password: STAFF_PASSWORD,
        emailVerified: true
      });
      console.log(`   Created new Auth User (UID: ${staffUser.uid})`);
    }

    // 3. Write Profile linked to Admin's Org
    await db.collection('users').doc(staffUser.uid).set({
      email: STAFF_EMAIL,
      fullName: "UAT Staffer",
      role: "staff", 
      orgId: orgId,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log(`\n🎉 SUCCESS! Staff created in ${env.toUpperCase()}`);
    console.log(`👉 Login: ${STAFF_EMAIL} / ${STAFF_PASSWORD}`);

  } catch (error) {
    console.error("❌ Error:", error.message);
  }
}

createStaff();

```
---

## FILE: scripts/debug_orgs.cjs
```cjs
const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json'); // Uses DEV key

const ADMIN_EMAIL = "rpdouglas@gmail.com";
const STAFF_EMAIL = "staff@freshnest.com";

if (!admin.apps.length) {
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}
const db = admin.firestore();
const auth = admin.auth();

async function debug() {
  console.log("🔍 Comparing Org IDs...");

  // 1. Check Admin
  try {
    const adminAuth = await auth.getUserByEmail(ADMIN_EMAIL);
    const adminDoc = await db.collection('users').doc(adminAuth.uid).get();
    
    if (!adminDoc.exists) {
      console.log(`❌ Admin Profile MISSING in Firestore!`);
    } else {
      console.log(`✅ Admin (${ADMIN_EMAIL}):`);
      console.log(`   - UID: ${adminAuth.uid}`);
      console.log(`   - OrgID: ${adminDoc.data().orgId}`);
      console.log(`   - Role:  ${adminDoc.data().role}`);
    }
  } catch (e) { console.error("Error fetching Admin:", e.message); }

  console.log("------------------------------------------------");

  // 2. Check Staff
  try {
    const staffAuth = await auth.getUserByEmail(STAFF_EMAIL);
    const staffDoc = await db.collection('users').doc(staffAuth.uid).get();

    if (!staffDoc.exists) {
      console.log(`❌ Staff Profile MISSING in Firestore!`);
    } else {
      console.log(`✅ Staff (${STAFF_EMAIL}):`);
      console.log(`   - UID: ${staffAuth.uid}`);
      console.log(`   - OrgID: ${staffDoc.data().orgId}`);
      console.log(`   - Role:  ${staffDoc.data().role}`);
    }
  } catch (e) { console.error("Error fetching Staff:", e.message); }
}

debug();

```
---

## FILE: scripts/finalize_mvp_docs.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: FINAL MVP DOCUMENTATION SYNC
# Goal: Mark project as v1.0.0 and document Export
# ====================================================

echo "📚 Finalizing Documentation for v1.0.0 Release..."

# 1. Update Root README (Feature Complete)
echo "📝 Updating README.md..."
cat << 'INNER_EOF' > README.md
# 🧹 Fresh Nest

**Fresh Nest** is a Lean SaaS Field Service Management (FSM) platform built for cleaning businesses.
It features Multi-Tenancy, Role-Based Access Control, Geolocation, Financial Analytics, and Data Export.

## 🚀 Quick Start

1. **Install Dependencies:**
   \`npm install\`

2. **Environment Setup:**
   Ensure you have \`.env.development\` with valid Firebase & Google Maps Keys.

3. **Run Local Dev:**
   \`npm run dev\`

## 📂 Documentation Index

* **[Project Status](./docs/PROJECT_STATUS.md):** Current phase and roadmap.
* **[DevOps Manual](./docs/DEVOPS_MANUAL.md):** CI/CD, Secrets, and Infrastructure.
* **[Context Dump](./docs/CONTEXT_DUMP.md):** High-level architecture rules for AI.
* **[RBAC Matrix](./docs/RBAC_MATRIX.md):** Security permissions reference.
* **[Schema Reference](./docs/SCHEMA_REFERENCE.md):** Firestore data model & Business Logic.

## 🏗️ Architecture
* **Frontend:** React + Vite + Tailwind CSS
* **Backend:** Firebase (Auth, Firestore, Functions)
* **Maps:** Google Maps Javascript API
* **Invoicing:** @react-pdf/renderer (Client-side)
* **Analytics:** Recharts (Client-side aggregation)
* **Export:** Custom CSV Utility (No heavy dependencies)
INNER_EOF

# 2. Update Project Status (The Big Milestone)
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** ✅ MVP Complete (Maintenance Mode)
**Last Updated:** $(date +%Y-%m-%d)
**Latest Version:** v1.0.0

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding.
* **Jobs:** Scheduling, CRUD, Workflow, Maps.
* **Invoicing:** PDF Generation, Mobile Parity.
* **Dashboard:** Admin KPIs, Revenue Charts, Staff Restrictions.
* **Data Export:** CSV downloads for Clients and Jobs (Admin only).
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 Future Roadmap (Post-MVP)
* [ ] **Email Notifications:** Send invoices via SendGrid/Postmark.
* [ ] **Client Portal:** Allow clients to book their own slots.
* [ ] **Subscription Billing:** Stripe integration for SaaS fees.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: { invoiceNumber, invoicedAt, price, status, ... }
* `clients/{clientId}`: { name, address, coordinates, ... }
INNER_EOF

# 3. Update RBAC Matrix (Add Export)
echo "📝 Updating docs/RBAC_MATRIX.md..."
cat << 'INNER_EOF' > docs/RBAC_MATRIX.md
# 🛡️ Role-Based Access Control (RBAC) Matrix

**Roles:** `admin` (Owner), `staff` (Worker)
**Enforcement:** 1. **Frontend:** UI Hiding via `useJobWorkflow` / `userRole`.
2. **Backend:** Firestore Security Rules (checks `resource.data.orgId`).

| Feature | Action | Admin | Staff | Notes |
| :--- | :--- | :---: | :---: | :--- |
| **Dashboard** | View KPIs | ✅ | ❌ | Revenue, Avg Ticket, Total Jobs. |
| | View Charts | ✅ | ❌ | Monthly Revenue Trends. |
| | View "My Jobs"| ✅ | ✅ | Staff see their assigned list. |
| **Clients** | View List | ✅ | ✅ | Staff see all clients in Org. |
| | Create/Edit | ✅ | ❌ | |
| **Jobs** | View List | ✅ | ⚠️ | Staff only see *assigned* jobs. |
| | Create Job | ✅ | ❌ | |
| | Edit Details | ✅ | ❌ | Price, Notes, Service Type. |
| | Start Job | ✅ | ✅ | Only if assigned (Staff). |
| | Complete Job | ✅ | ✅ | Only if assigned (Staff). |
| | Cancel Job | ✅ | ❌ | |
| | Delete Job | ✅ | ❌ | |
| **Invoicing** | Generate | ✅ | ❌ | |
| **Data Export** | Download CSV | ✅ | ❌ | Prevent data theft. |
| **Settings** | Invite User | ✅ | ❌ | |
| **Financials**| See Prices | ✅ | ❌ | Hidden in UI for Staff. |
INNER_EOF

# 4. Update Context Dump (Add CSV Rule)
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.

## Documentation References
* **Schema:** See `docs/SCHEMA_REFERENCE.md`
* **Security/RBAC:** See `docs/RBAC_MATRIX.md`
* **DevOps:** See `docs/DEVOPS_MANUAL.md`

## Architecture Rules (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId`.** Fetch `users/{uid}`.
   - All queries must filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **State Management:**
   - Prefer deriving state from lists (e.g. `jobs.find(id)`) over storing object snapshots.
6. **Analytics & Export:**
   - **Charts:** Use `recharts` (Client-side aggregation).
   - **CSV Export:** Use `src/lib/csv.js` (Custom utility). Do NOT install `papaparse`.
   - **PDF:** Use `@react-pdf/renderer` inside `InvoiceModal`.
INNER_EOF

# 5. Update Changelog
echo "📝 Updating docs/CHANGELOG.md..."
cat << 'INNER_EOF' > docs/CHANGELOG.md
# 📜 Changelog

## [v1.0.0] - 2026-01-14 (MVP Gold Master)
### Added
* **Data Export:** Admins can now export Client and Job lists to CSV using a custom robust utility.
* **Security:** Role-based restrictions applied to Export buttons (Admin only).
* **Mobile Parity:** Export buttons hidden on mobile to preserve UI density.

## [v0.6.0] - 2026-01-14
### Added
* **Revenue Dashboard:** Admin view with Total Revenue, Jobs Completed, and Avg Ticket KPIs.
* **Visualizations:** Monthly Revenue Bar Chart using `recharts`.
* **Staff Dashboard:** Restricted view showing only assigned upcoming jobs.

## [v0.5.1] - 2026-01-12
### Fixed
* **Mobile Invoicing:** Added responsive HTML preview for mobile devices.

## [v0.5.0] - 2026-01-12
### Added
* **Invoicing Module:** Client-side PDF generation.
INNER_EOF

# 6. Commit Updates
echo "🌿 Committing Documentation Suite..."
git add README.md docs/
git commit -m "docs: finalize v1.0.0 mvp documentation"
git push origin main

echo "🎉 Documentation Updated. Fresh Nest is officially v1.0.0!"

```
---

## FILE: scripts/finalize_phase5_docs.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: DOCUMENTATION SYNCHRONIZATION
# Goal: Update all docs to reflect Phase 5 Completion
# ====================================================

echo "📚 Synchronizing Documentation Suite..."

# 1. Create Root README.md (The Front Door)
echo "📝 Creating README.md..."
cat << 'INNER_EOF' > README.md
# 🧹 Fresh Nest

**Fresh Nest** is a Lean SaaS Field Service Management (FSM) platform built for cleaning businesses.
It features Multi-Tenancy, Role-Based Access Control, Geolocation, and Financial Analytics.

## 🚀 Quick Start

1. **Install Dependencies:**
   \`npm install\`

2. **Environment Setup:**
   Ensure you have \`.env.development\` with valid Firebase & Google Maps Keys.

3. **Run Local Dev:**
   \`npm run dev\`

## 📂 Documentation Index

* **[Project Status](./docs/PROJECT_STATUS.md):** Current phase and roadmap.
* **[DevOps Manual](./docs/DEVOPS_MANUAL.md):** CI/CD, Secrets, and Infrastructure.
* **[Context Dump](./docs/CONTEXT_DUMP.md):** High-level architecture rules for AI.
* **[RBAC Matrix](./docs/RBAC_MATRIX.md):** Security permissions reference.
* **[Schema Reference](./docs/SCHEMA_REFERENCE.md):** Firestore data model & Business Logic.

## 🏗️ Architecture
* **Frontend:** React + Vite + Tailwind CSS
* **Backend:** Firebase (Auth, Firestore, Functions)
* **Maps:** Google Maps Javascript API
* **Invoicing:** @react-pdf/renderer (Client-side)
* **Analytics:** Recharts (Client-side aggregation)
INNER_EOF

# 2. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 6 - Data Export & Polish
**Last Updated:** $(date +%Y-%m-%d)
**Latest Version:** v0.6.0 (Revenue Dashboard)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding.
* **Jobs:** Scheduling, CRUD, Workflow, Maps.
* **Invoicing:** PDF Generation, Mobile Parity.
* **Dashboard:** Admin KPIs, Revenue Charts, Staff Restrictions.
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Data Export:** CSV export for accounting (Quickbooks/Xero support).
* [ ] **Final Polish:** UX consistency check.
INNER_EOF

# 3. Update RBAC Matrix (Add Dashboard Rules)
echo "📝 Updating docs/RBAC_MATRIX.md..."
cat << 'INNER_EOF' > docs/RBAC_MATRIX.md
# 🛡️ Role-Based Access Control (RBAC) Matrix

**Roles:** `admin` (Owner), `staff` (Worker)
**Enforcement:** 1. **Frontend:** UI Hiding via `useJobWorkflow` / `userRole`.
2. **Backend:** Firestore Security Rules (checks `resource.data.orgId`).

| Feature | Action | Admin | Staff | Notes |
| :--- | :--- | :---: | :---: | :--- |
| **Dashboard** | View KPIs | ✅ | ❌ | Revenue, Avg Ticket, Total Jobs. |
| | View Charts | ✅ | ❌ | Monthly Revenue Trends. |
| | View "My Jobs"| ✅ | ✅ | Staff see their assigned list. |
| **Clients** | View List | ✅ | ✅ | Staff see all clients in Org. |
| | Create/Edit | ✅ | ❌ | |
| **Jobs** | View List | ✅ | ⚠️ | Staff only see *assigned* jobs. |
| | Create Job | ✅ | ❌ | |
| | Edit Details | ✅ | ❌ | Price, Notes, Service Type. |
| | Start Job | ✅ | ✅ | Only if assigned (Staff). |
| | Complete Job | ✅ | ✅ | Only if assigned (Staff). |
| | Cancel Job | ✅ | ❌ | |
| | Delete Job | ✅ | ❌ | |
| **Invoicing** | Generate | ✅ | ❌ | |
| **Settings** | Invite User | ✅ | ❌ | |
| **Financials**| See Prices | ✅ | ❌ | Hidden in UI for Staff. |
INNER_EOF

# 4. Update Schema Reference (Add Business Logic)
echo "📝 Updating docs/SCHEMA_REFERENCE.md..."
cat << 'INNER_EOF' > docs/SCHEMA_REFERENCE.md
# 🗄️ Firestore Schema & Business Logic

## 🧠 Business Logic & Calculations

### 1. Revenue Calculation
* **Definition:** Sum of `price` for all jobs where `status === 'completed'`.
* **Constraint:** Jobs that are 'scheduled' or 'in_progress' do NOT count towards revenue.
* **Aggregation:** Performed Client-Side in `useDashboard.js`.

### 2. Job Completion
* **Trigger:** User clicks "Complete Job".
* **Update:** Sets `status: 'completed'` AND `completedAt: serverTimestamp()`.
* **Note:** `completedAt` is used for Monthly Grouping in charts.

---

## 📂 Collection Reference

### `organizations/{orgId}`
* **name** (string): Display name.
* **settings** (map): `{ currency, geoFenceRadius }`.
* **plan** (string): Subscription tier.

### `users/{userId}`
* **email** (string)
* **fullName** (string)
* **orgId** (string): **CRITICAL**. Links user to tenant.
* **role** (string): `'admin'` | `'staff'`.

### `clients/{clientId}`
* **orgId** (string)
* **name** (string)
* **email** (string)
* **phone** (string)
* **address** (string): Text address.
* **coordinates** (map): `{ lat: number, lng: number }`. Used for Maps.

### `jobs/{jobId}`
* **orgId** (string)
* **clientId** (string): Ref to `clients`.
* **assignedTo** (array): List of `userId` strings.
* **status** (string): `'scheduled'` | `'in_progress'` | `'completed'` | `'cancelled'`.
* **serviceType** (string): `'standard'` | `'deep'` | etc.
* **price** (number): Estimated cost.
* **scheduledDate** (timestamp): When the job is.
* **startedAt** (timestamp): When status changed to in_progress.
* **completedAt** (timestamp): Used for Revenue Reports.
* **invoiceNumber** (string): Generated ID (e.g., "2026-4821").
* **invoicedAt** (timestamp): When PDF was generated.
INNER_EOF

# 5. Update Changelog
echo "📝 Updating docs/CHANGELOG.md..."
cat << 'INNER_EOF' > docs/CHANGELOG.md
# 📜 Changelog

## [v0.6.0] - 2026-01-14
### Added
* **Revenue Dashboard:** Admin view with Total Revenue, Jobs Completed, and Avg Ticket KPIs.
* **Visualizations:** Monthly Revenue Bar Chart using `recharts` with horizontal scrolling for mobile.
* **Staff Dashboard:** Restricted view showing only assigned upcoming jobs.
* **Security:** Implemented Client-Side role checks to prevent data leaks.

## [v0.5.1] - 2026-01-12
### Fixed
* **Mobile Invoicing:** Added responsive HTML preview for mobile devices to bypass PDF iframe limitations.
* **UI:** Added "Generate Invoice" button to Mobile Job Card.

## [v0.5.0] - 2026-01-12
### Added
* **Invoicing Module:** Client-side PDF generation using `@react-pdf/renderer`.
* **Tracking:** `invoicedAt` and `invoiceNumber` fields added to Job Schema.
INNER_EOF

# 6. Commit Updates
echo "🌿 Committing Documentation Suite..."
git add README.md docs/
git commit -m "docs: finalize phase 5 revenue dashboard documentation"
git push origin main

echo "✅ Documentation Suite Updated."

```
---

## FILE: scripts/generate-context.sh
```sh
#!/bin/bash

# ==========================================
# 🚀 FRESH NEST: DEEP CONTEXT GENERATOR
# ==========================================

OUTPUT_FILE="docs/FULL_CODEBASE_CONTEXT.md"

echo "🔄 Generating Context Dump..."
echo "# FRESH NEST: CODEBASE DUMP" > "$OUTPUT_FILE"
echo "**Date:** $(date)" >> "$OUTPUT_FILE"
echo "**Description:** Complete codebase context." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

ingest_file() {
    local filepath="$1"
    
    # SECURITY CHECK: Skip if file matches sensitive patterns
    if [[ "$filepath" == *".env"* ]] || [[ "$filepath" == *"service-account"* ]] || [[ "$filepath" == *".DS_Store"* ]]; then
        return
    fi

    if [ -f "$filepath" ]; then
        echo "Processing: $filepath"
        
        # Markdown Header for the file
        echo "## FILE: $filepath" >> "$OUTPUT_FILE"
        echo "\`\`\`${filepath##*.}" >> "$OUTPUT_FILE" # Use extension for syntax highlighting
        
        # Cat the content
        cat "$filepath" >> "$OUTPUT_FILE"
        
        echo "" >> "$OUTPUT_FILE"
        echo "\`\`\`" >> "$OUTPUT_FILE"
        echo "---" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    fi
}

# Root Configs
ingest_file "package.json"
ingest_file "vite.config.js"
ingest_file "tailwind.config.js"
ingest_file "firebase.json"
ingest_file ".firebaserc"

# Source Code
find src -type f -not -path "*/.*" | sort | while read file; do ingest_file "$file"; done

# Documentation
find docs -type f -name "*.md" -not -name "FULL_CODEBASE_CONTEXT.md" | sort | while read file; do ingest_file "$file"; done

# Scripts
find scripts -type f \( -name "*.js" -o -name "*.cjs" -o -name "*.sh" \) | sort | while read file; do ingest_file "$file"; done

# CI/CD Workflows
find .github/workflows -type f -name "*.yml" | sort | while read file; do ingest_file "$file"; done

echo "✅ Context Generated at: $OUTPUT_FILE"

```
---

## FILE: scripts/init-org.cjs
```cjs
const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// --- ARGS HANDLING ---
// Usage: node scripts/init-org.cjs [env]
// Example: node scripts/init-org.cjs uat
const env = process.argv[2] || 'dev';
const keyFilename = env === 'dev' ? 'service-account.json' : `service-account-${env}.json`;
const keyPath = path.join(__dirname, keyFilename);

// --- CONFIGURATION ---
const TARGET_EMAIL = "rpdouglas@gmail.com"; 
const ORG_NAME = "Fresh Nest (HQ)";
// ---------------------

if (!fs.existsSync(keyPath)) {
  console.error(`❌ ERROR: Could not find key file: ${keyFilename}`);
  console.error(`   Please download it from Firebase Console -> Project Settings -> Service Accounts`);
  console.error(`   and save it to the 'scripts/' folder.`);
  process.exit(1);
}

const serviceAccount = require(keyPath);

console.log(`🌍 Environment: ${env.toUpperCase()}`);
console.log(`🔑 Using Key: ${keyFilename}`);

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const db = admin.firestore();
const auth = admin.auth();

async function bootstrap() {
  try {
    console.log(`🚀 Starting bootstrap for: ${TARGET_EMAIL}`);

    // 1. Ensure Auth User Exists
    let user;
    try {
      user = await auth.getUserByEmail(TARGET_EMAIL);
      console.log(`✅ Found Existing Auth User: ${user.uid}`);
    } catch (e) {
      console.log(`👤 User not found in Auth. Creating new user...`);
      user = await auth.createUser({
        email: TARGET_EMAIL,
        password: 'password123', // Default password for new envs
        emailVerified: true
      });
      console.log(`✅ Created New Auth User: ${user.uid}`);
    }

    // 2. Create the Organization
    const orgRef = await db.collection('organizations').add({
      name: ORG_NAME,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      plan: 'enterprise',
      settings: {
        currency: 'USD',
        geoFenceRadius: 500
      }
    });
    console.log(`✅ Created Organization: ${orgRef.id} (${ORG_NAME})`);

    // 3. Create/Update User Profile
    await db.collection('users').doc(user.uid).set({
      email: user.email,
      orgId: orgRef.id,
      role: 'admin',
      fullName: 'Rob Douglas',
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
    console.log(`✅ Created/Updated Firestore Profile`);

    // 4. Set Custom Claims (Legacy support, though we use Profile now)
    await auth.setCustomUserClaims(user.uid, {
      orgId: orgRef.id,
      role: 'admin'
    });
    console.log(`✅ Claims set!`);

    console.log("\n🎉 SUCCESS! You can now log in to " + env.toUpperCase());
    console.log("👉 Login: " + TARGET_EMAIL);
    console.log("👉 Pass:  password123 (if newly created) or your existing pass");

  } catch (error) {
    console.error("❌ Error during bootstrap:", error);
  }
}

bootstrap();

```
---

## FILE: scripts/inject_personas.sh
```sh
#!/bin/bash

echo "👥 Injecting Persona-Based Documentation..."

# 1. Create PERSONAS.md (The Source of Truth for Human Constraints)
echo "📝 Creating docs/PERSONAS.md..."
cat << 'INNER_EOF' > docs/PERSONAS.md
# 👥 Fresh Nest Personas (Technical Constraints)

These are not just user stories. These are **System Constraints**. Every feature must be validated against these realities.

## 1. Carla - The "Financial Anchor" (ODSP)
* **Context:** Single mother, relies on Ontario Disability Support Program (ODSP).
* **Hard Constraint:** **Earnings Cap.** She *cannot* earn more than her allowable limit (e.g., $1,000/mo) without triggering a clawback mechanism that destabilizes her housing.
* **Tech Requirement:** * `user.financials.limit`: Hard integer limit.
    * **Pre-Claim Check:** System must block a shift claim if `(currentMonthEarnings + shiftPrice) > limit`.
    * **Visuals:** "Safe to Earn" progress bar.

## 2. Jasmine - The "Transit Rider"
* **Context:** No vehicle. Relies on Cornwall Transit.
* **Hard Constraint:** **Travel Time Buffers.** She cannot teleport. A 1:00 PM job across town after a 12:00 PM job is physically impossible.
* **Tech Requirement:**
    * `user.constraints.transport`: 'transit'.
    * **Conflict Engine:** Auto-calculate travel time via Google Maps Transit API (future) or enforce 60-min buffers between sites.

## 3. Mike - The "Recovery Worker"
* **Context:** Re-entering workforce. Attends mandatory support meetings (e.g., AA) every Tuesday at 7 PM.
* **Hard Constraint:** **Blocked Windows.**
* **Tech Requirement:**
    * `user.constraints.blockedWindows`: Array of recurring time slots.
    * **Visibility Filter:** Shifts overlapping these windows must be strictly hidden from his view.

## 4. Ahmed - The "Newcomer" (ESL)
* **Context:** Recent immigrant. High work ethic, low English literacy.
* **Hard Constraint:** **Cognitive Load.** Text-heavy instructions result in errors.
* **Tech Requirement:**
    * **Icon-First UI:** Tasks must use visual icons (Mop, Key, Trash).
    * **Language Toggle:** One-tap switch between English/French/Arabic.

## 5. Brenda - The "Visual Verifier"
* **Context:** Detail-oriented, anxious about "he said/she said" disputes.
* **Hard Constraint:** **Trust.** Needs proof she did the job right.
* **Tech Requirement:**
    * **Photo Uploads:** Mandatory "Before" and "After" photos for specific high-value items (e.g., Stove).
    * **Metadata:** Photos must be timestamped and geo-tagged.

## 6. Sarah - The "Owner" (Compliance)
* **Context:** Business owner. Terrified of labor board audits and liability.
* **Hard Constraint:** **Audit Trail.**
* **Tech Requirement:**
    * **Version Control:** `acceptedTermsVersion` stored on every user profile.
    * **Rate Snapshots:** Every shift record must freeze the pay rate at the time of claim.

INNER_EOF

# 2. Update CONTEXT_DUMP to reference Personas
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Location:** Cornwall, Ontario, Canada
**Mission:** Worker Support Platform (Safety First).

## 🧠 The "Prime Directive"
We build for **Personas**, not just Users. 
* Before building a feature, check **`docs/PERSONAS.md`**.
* **Safety > Efficiency.** It is better to block a shift claim than to let Carla lose her benefits.

## Documentation References
* **Personas:** See `docs/PERSONAS.md` (CRITICAL)
* **Schema:** See `docs/SCHEMA_REFERENCE.md`
* **Security:** See `docs/RBAC_MATRIX.md`

## Architecture Rules (STRICT)
1. **NO PLACEHOLDERS:** Complete files only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security:** Use Profile-based RBAC (`users/{uid}`).
5. **Logic:** Client-side aggregation for Dashboards is acceptable for MVP.
INNER_EOF

# 3. Update SCHEMA_REFERENCE to match Master Plan 9
echo "📝 Updating docs/SCHEMA_REFERENCE.md..."
cat << 'INNER_EOF' > docs/SCHEMA_REFERENCE.md
# 🗄️ Firestore Schema & Business Logic

## `users/{userId}`
* **profile** (map):
  * `name` (string)
  * `language` (string): 'en', 'fr', etc. (For Ahmed)
  * `transport` (string): 'transit' | 'vehicle' (For Jasmine)
  * `acceptedTermsVersion` (string): e.g., "v1.0_2025" (For Sarah)
* **financials** (map):
  * `mode`: 'cap' | 'unlimited'
  * `limit` (number): Monthly hard cap (For Carla)
  * `currentMonthAccrued` (number): Real-time counter.
* **constraints** (map):
  * `blockedWindows` (array): Time slots (For Mike)
  * `heavyLifting` (boolean)
* **role** (string): 'admin' | 'staff' | 'care_coordinator'
* **orgId** (string)

## `jobs/{jobId}` (aka Shifts)
* **status**: 'open' | 'claimed' | 'completed' | 'cancelled'
* **contractLedger** (map): (Financial Audit Trail)
  * `claimedBy`: userId
  * `claimedAt`: timestamp
  * `rateSnapshot`: number (Hourly/Fixed rate at time of claim)
* **requirements** (map):
  * `photos`: array of URLs (For Brenda)
* **time**:
  * `start`: timestamp
  * `end`: timestamp
* **location**:
  * `address`: string
  * `coordinates`: { lat, lng }

## `clients/{clientId}`
* **Standard fields**: name, address, etc.

INNER_EOF

echo "✅ Persona System Injected into Documentation."

```
---

## FILE: scripts/install_feature.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: DATA EXPORT INSTALLER
# Feature: CSV Export for Admins
# Approach: Custom "Robust" Utility (No heavy libs)
# ====================================================

echo "🚀 Installing Data Export Feature..."

# 1. Create the CSV Utility
# Handles escaping (quotes, newlines, commas) to prevent corrupt files
echo "📝 Creating src/lib/csv.js..."
mkdir -p src/lib
cat << 'INNER_EOF' > src/lib/csv.js
import { format } from 'date-fns';

/**
 * Converts an array of objects to a CSV string.
 * Automatically handles escaping of special characters.
 */
export const generateCSV = (data, headers) => {
  if (!data || !data.length) return '';

  const processRow = (row) => {
    return headers.map(header => {
      let value = row[header.key];
      
      // Formatting Logic
      if (value === null || value === undefined) {
        value = '';
      } else if (value instanceof Date) {
        value = format(value, 'yyyy-MM-dd HH:mm:ss');
      } else if (typeof value === 'object') {
        // Flatten simple objects if needed, or stringify
        value = JSON.stringify(value);
      } else {
        value = String(value);
      }

      // Escape Logic: If value contains comma, newline, or quote, wrap in quotes
      if (value.includes(',') || value.includes('\n') || value.includes('"')) {
        value = `"${value.replace(/"/g, '""')}"`;
      }

      return value;
    }).join(',');
  };

  const csvRows = [
    headers.map(h => h.label).join(','), // Header Row
    ...data.map(processRow)              // Data Rows
  ];

  return csvRows.join('\n');
};

/**
 * Triggers a browser download of the CSV content
 */
export const downloadCSV = (csvContent, filename) => {
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  if (link.download !== undefined) {
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', filename);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
};
INNER_EOF

# 2. Create Reusable Export Button Component
# Logic: Checks role, prepares data, handles download
echo "📝 Creating src/components/common/ExportButton.jsx..."
mkdir -p src/components/common
cat << 'INNER_EOF' > src/components/common/ExportButton.jsx
import React from 'react';
import { Download } from 'lucide-react';
import { generateCSV, downloadCSV } from '../../lib/csv';

const ExportButton = ({ data, filename, headers, role }) => {
  // Security: Render nothing if not Admin
  if (role !== 'admin') return null;

  const handleExport = () => {
    const csv = generateCSV(data, headers);
    downloadCSV(csv, `${filename}_${new Date().toISOString().split('T')[0]}.csv`);
  };

  return (
    <button
      onClick={handleExport}
      className="hidden md:flex items-center gap-2 px-4 py-2 border border-slate-300 text-slate-700 font-medium rounded-lg hover:bg-slate-50 transition-colors"
      title="Export to CSV"
    >
      <Download size={18} />
      <span>Export</span>
    </button>
  );
};

export default ExportButton;
INNER_EOF

# 3. Update useClients to return Role
# We need to know if the user is an Admin inside ClientsPage
echo "📝 Updating src/hooks/useClients.js..."
cat << 'INNER_EOF' > src/hooks/useClients.js
import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, addDoc, serverTimestamp, orderBy, doc, getDoc
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useClients = () => {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentOrgId, setCurrentOrgId] = useState(null);
  const [userRole, setUserRole] = useState(null); // Added role state

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setError("User profile not found.");
          setLoading(false);
          return;
        }

        const userData = userDoc.data();
        const orgId = userData.orgId;
        const role = userData.role;

        setCurrentOrgId(orgId);
        setUserRole(role); // Set Role

        if (!orgId) {
          setError("Organization ID missing.");
          setLoading(false);
          return;
        }

        const q = query(
          collection(db, 'clients'),
          where('orgId', '==', orgId),
          orderBy('createdAt', 'desc')
        );

        const unsubscribe = onSnapshot(q, (snapshot) => {
          const clientData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            // Extract lat/lng for flattening later if needed
            lat: doc.data().coordinates?.lat || '',
            lng: doc.data().coordinates?.lng || ''
          }));
          setClients(clientData);
          setLoading(false);
        }, (err) => {
          console.error("Error fetching clients:", err);
          setError("Failed to load clients.");
          setLoading(false);
        });

        return unsubscribe;

      } catch (err) {
        console.error(err);
        setError("Error initializing client list.");
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, []);

  const addClient = async (clientData) => {
    if (!currentOrgId) throw new Error("No Organization ID found.");
    await addDoc(collection(db, 'clients'), {
      ...clientData,
      orgId: currentOrgId, 
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    });
  };

  return { clients, loading, error, addClient, role: userRole };
};
INNER_EOF

# 4. Integrate Export Button into ClientsPage
echo "📝 Updating src/pages/ClientsPage.jsx..."
cat << 'INNER_EOF' > src/pages/ClientsPage.jsx
import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useClients } from '../hooks/useClients';
import ClientListMobile from '../components/clients/ClientListMobile';
import ClientTableDesktop from '../components/clients/ClientTableDesktop';
import ClientFormModal from '../components/clients/ClientFormModal';
import ExportButton from '../components/common/ExportButton';

const ClientsPage = () => {
  const { clients, loading, error, addClient, role } = useClients();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const filteredClients = clients.filter(c => 
    c.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    c.email?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const exportHeaders = [
    { key: 'name', label: 'Client Name' },
    { key: 'email', label: 'Email' },
    { key: 'phone', label: 'Phone' },
    { key: 'address', label: 'Address' },
    { key: 'lat', label: 'Latitude' },
    { key: 'lng', label: 'Longitude' }
  ];

  return (
    <div className="space-y-6">
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

          <ExportButton 
            role={role} 
            data={filteredClients} 
            filename="Clients" 
            headers={exportHeaders} 
          />

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

      <ClientFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={addClient}
      />
    </div>
  );
};

export default ClientsPage;
INNER_EOF

# 5. Integrate Export Button into JobsPage
echo "📝 Updating src/pages/JobsPage.jsx..."
cat << 'INNER_EOF' > src/pages/JobsPage.jsx
import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useJobs } from '../hooks/useJobs';
import { useClients } from '../hooks/useClients';
import { useStaff } from '../hooks/useStaff';
import JobListMobile from '../components/jobs/JobListMobile';
import JobTableDesktop from '../components/jobs/JobTableDesktop';
import JobFormModal from '../components/jobs/JobFormModal';
import InvoiceModal from '../components/invoicing/InvoiceModal';
import ExportButton from '../components/common/ExportButton';

const JobsPage = () => {
  const { jobs, loading: jobsLoading, error: jobsError, addJob, updateJob, deleteJob, markAsInvoiced, role: userRole } = useJobs();
  const { clients, loading: clientsLoading } = useClients(); 
  const { staff, loading: staffLoading } = useStaff();

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingJobId, setEditingJobId] = useState(null);
  const [invoicingJobId, setInvoicingJobId] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  const loading = jobsLoading || clientsLoading || staffLoading;

  const filteredJobs = jobs.filter(job => {
    const clientName = clients.find(c => c.id === job.clientId)?.name?.toLowerCase() || '';
    return clientName.includes(searchTerm.toLowerCase());
  });

  // Prepare data for export (Flattening)
  const exportData = filteredJobs.map(job => {
    const client = clients.find(c => c.id === job.clientId);
    const assignedMember = job.assignedTo?.[0] ? staff.find(s => s.id === job.assignedTo[0]) : null;
    
    return {
      ...job,
      clientName: client ? client.name : 'Unknown',
      clientAddress: client ? client.address : '',
      assignedToName: assignedMember ? assignedMember.fullName : 'Unassigned',
      // Format timestamps for CSV
      scheduledDate: job.scheduledDate, 
      completedAt: job.completedAt
    };
  });

  const exportHeaders = [
    { key: 'invoiceNumber', label: 'Invoice #' },
    { key: 'clientName', label: 'Client' },
    { key: 'clientAddress', label: 'Address' },
    { key: 'serviceType', label: 'Service' },
    { key: 'price', label: 'Price' },
    { key: 'status', label: 'Status' },
    { key: 'scheduledDate', label: 'Scheduled' },
    { key: 'completedAt', label: 'Completed' },
    { key: 'assignedToName', label: 'Staff' }
  ];

  const editingJob = editingJobId ? jobs.find(j => j.id === editingJobId) : null;
  const invoicingJob = invoicingJobId ? jobs.find(j => j.id === invoicingJobId) : null;

  const handleCreateOpen = () => {
    setEditingJobId(null);
    setIsModalOpen(true);
  };

  const handleEditOpen = (job) => {
    setEditingJobId(job.id);
    setIsModalOpen(true);
  };

  const handleInvoiceOpen = (job) => {
    setInvoicingJobId(job.id);
  };

  const handleSave = async (formData) => {
    if (editingJobId) {
      await updateJob(editingJobId, formData);
    } else {
      await addJob(formData);
    }
  };

  const handleDelete = async (jobId) => {
    if (window.confirm("Are you sure you want to delete this job? This cannot be undone.")) {
      await deleteJob(jobId);
    }
  };

  const handleMarkInvoiced = async (jobId) => {
    await markAsInvoiced(jobId);
  };

  return (
    <div className="space-y-6">
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

          <ExportButton 
            role={userRole}
            data={exportData}
            filename="Jobs"
            headers={exportHeaders}
          />

          {userRole === 'admin' && (
            <button 
              onClick={handleCreateOpen}
              className="bg-brand-600 text-white px-4 py-2 rounded-lg font-semibold hover:bg-brand-700 flex items-center gap-2 shadow-sm whitespace-nowrap"
            >
              <Plus size={20} />
              <span className="hidden md:inline">New Job</span>
              <span className="md:hidden">New</span>
            </button>
          )}
        </div>
      </div>

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
          <JobListMobile 
            jobs={filteredJobs} 
            clients={clients} 
            staff={staff} 
            userRole={userRole} 
            onEdit={handleEditOpen}
            onInvoice={handleInvoiceOpen}
          />
          <JobTableDesktop 
            jobs={filteredJobs} 
            clients={clients} 
            staff={staff} 
            userRole={userRole} 
            onEdit={handleEditOpen}
            onDelete={handleDelete}
            onInvoice={handleInvoiceOpen}
          />
        </>
      )}

      <JobFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={handleSave} 
        clients={clients} 
        staff={staff}
        initialData={editingJob}
      />

      <InvoiceModal 
        isOpen={!!invoicingJob}
        onClose={() => setInvoicingJobId(null)}
        job={invoicingJob}
        client={invoicingJob ? clients.find(c => c.id === invoicingJob.clientId) : null}
        onMarkInvoiced={handleMarkInvoiced}
      />
    </div>
  );
};

export default JobsPage;
INNER_EOF

echo "✅ SUCCESS! Data Export feature installed."

```
---

## FILE: scripts/merge_to_dev.sh
```sh
#!/bin/bash
# Merges current feature into 'dev' and pushes to GitHub to trigger CI

current_branch=$(git branch --show-current)

if [ "$current_branch" == "dev" ] || [ "$current_branch" == "main" ]; then
  echo "❌ You are on $current_branch. Please checkout a feature branch first."
  exit 1
fi

echo "🚀 Merging $current_branch into dev..."

# 1. Switch to dev and pull latest
git checkout dev
git pull origin dev

# 2. Merge Feature
git merge "$current_branch"

# 3. Push to GitHub (TRIGGERS GITHUB ACTION for DEV)
git push origin dev

# 4. Return to feature branch
git checkout "$current_branch"

echo "✅ Merged and Pushed! GitHub Action is naw deploying to Fresh-Nest-Dev."
echo "👉 Check status here: https://github.com/rpdouglas/fresh-nest/actions"

```
---

## FILE: scripts/promote_to_prod.sh
```sh
#!/bin/bash

# Stop on error
set -e

# 1. Validation: Must be on a Release Branch
current_branch=$(git branch --show-current)

if [[ "$current_branch" != release/* ]]; then
  echo "❌ ERROR: You must be on a 'release/...' branch to promote to Prod."
  echo "   Current branch: $current_branch"
  echo "   Use: git checkout release/vX.X.X"
  exit 1
fi

# Extract Version from Branch Name (e.g., release/v0.1.1 -> v0.1.1)
VERSION_TAG=${current_branch#release/}

echo "🚀 Promoting Release $VERSION_TAG to Production..."

# 2. Safety Check: Clean Working Directory
if [ -n "$(git status --porcelain)" ]; then 
  echo "❌ ERROR: Your working directory is not clean. Commit or stash changes first."
  exit 1
fi

# 3. Switch to Main and Update
echo "🔄 Switching to main..."
git checkout main
git pull origin main

# 4. Merge the Release Branch
echo "🔀 Merging $current_branch into main..."
git merge --no-ff "$current_branch" -m "chore(release): promote $VERSION_TAG to production"

# 5. Create Immutable Git Tag
echo "🏷️  Tagging release: $VERSION_TAG"
# Delete tag if exists locally (edge case) to prevent collision
if git rev-parse "$VERSION_TAG" >/dev/null 2>&1; then
    echo "   (Tag exists locally, replacing...)"
    git tag -d "$VERSION_TAG"
fi
git tag -a "$VERSION_TAG" -m "Production Release $VERSION_TAG"

# 6. Push to Main (Triggers PROD Action)
echo "⬆️  Pushing code and tags to GitHub..."
git push origin main
git push origin "$VERSION_TAG"

# 7. Cleanup
echo "🧹 Cleaning up local release branch..."
git branch -d "$current_branch"

echo ""
echo "✅ SUCCESS! Production Deployment Triggered."
echo "👉 GitHub Action 'Deploy to PROD' is running."
echo "👉 Release Tag: $VERSION_TAG created."

```
---

## FILE: scripts/release_to_uat.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: RELEASE MANAGER (With Version Bump)
# Goal: Bump version, tag it, and push to UAT
# ====================================================

# 1. Sync Dev
echo "🔄 Syncing Dev Branch..."
git checkout dev
git pull origin dev

# 2. Prompt for Version Bump
echo ""
echo "📊 Current Version: $(node -p "require('./package.json').version")"
echo "Select release type:"
echo "  1) Patch (0.1.0 -> 0.1.1) - Bug fixes"
echo "  2) Minor (0.1.0 -> 0.2.0) - New features"
echo "  3) Major (0.1.0 -> 1.0.0) - Breaking changes"
echo "  4) No Bump (Just redeploy current)"
read -p "Enter choice [1-4]: " choice

case $choice in
  1) npm version patch --no-git-tag-version ;;
  2) npm version minor --no-git-tag-version ;;
  3) npm version major --no-git-tag-version ;;
  4) echo "⚠️  Skipping version bump." ;;
  *) echo "❌ Invalid choice"; exit 1 ;;
esac

# 3. Read New Version
NEW_VERSION=$(node -p "require('./package.json').version")
BRANCH_NAME="release/v$NEW_VERSION"

echo ""
echo "🚀 Preparing Release: $BRANCH_NAME"

# 4. Commit the Version Bump (if changed)
if [ "$choice" != "4" ]; then
  git add package.json package-lock.json
  git commit -m "chore: bump version to $NEW_VERSION"
  git push origin dev
fi

# 5. Cut and Push Release Branch
git checkout -b "$BRANCH_NAME"
git push origin "$BRANCH_NAME"

echo ""
echo "✅ Release $NEW_VERSION Pushed!"
echo "👉 GitHub Action is now deploying to UAT."
echo "👉 Action: Merge this PR into 'main' later to deploy to PROD."

```
---

## FILE: scripts/reset-password.cjs
```cjs
const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json');

// --- CONFIGURATION ---
const TARGET_EMAIL = "rpdouglas@gmail.com";
const NEW_PASSWORD = "password123"; 
// ---------------------

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const auth = admin.auth();

async function resetPassword() {
  try {
    console.log(`🔍 Looking for user: ${TARGET_EMAIL}...`);
    const user = await auth.getUserByEmail(TARGET_EMAIL);
    
    console.log(`👤 Found UID: ${user.uid}`);
    console.log(`🔐 Setting new password...`);

    await auth.updateUser(user.uid, {
      password: NEW_PASSWORD
    });

    console.log(`✅ SUCCESS! Password updated to: ${NEW_PASSWORD}`);
    console.log(`👉 You can now log in immediately.`);

  } catch (error) {
    console.error("❌ Error resetting password:", error.message);
  }
}

resetPassword();

```
---

## FILE: scripts/restore_dashboard.sh
```sh
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

```
---

## FILE: scripts/start-feature.sh
```sh
#!/bin/bash

# ==========================================
# 🚀 FRESH NEST: FEATURE BRANCH STARTER
# ==========================================

# 1. Ensure we are on main and up to date
echo "🔄 Switching to main and syncing with remote..."
git checkout main
git pull origin main

if [ $? -ne 0 ]; then
    echo "❌ Error: Could not sync with main. Please check your internet or git status."
    exit 1
fi

# 2. Prompt for the feature name
echo ""
echo "📝 Enter a short description for this feature (e.g. 'Client List Page')"
read -p "Feature Name: " raw_input

# 3. Sanitize the input (Lower case, spaces to hyphens)
# Example: "Client List Page" -> "client-list-page"
clean_name=$(echo "$raw_input" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

# 4. Create and switch to the new branch
branch_name="feature/$clean_name"
echo ""
echo "🌿 Creating new branch: $branch_name"
git checkout -b "$branch_name"

echo ""
echo "✅ Ready to code! You are now on branch: $branch_name"

```
---

## FILE: scripts/sync_indexes.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: FIRESTORE INDEX SYNCHRONIZER
# Goal: Pull indexes from DEV (Source of Truth) and promote them.
# ====================================================

# 1. Pull from DEV
echo "⬇️  Fetching Indexes from 'fresh-nest-dev'..."
npx firebase firestore:indexes --project fresh-nest-dev > firestore.indexes.json

if [ $? -eq 0 ]; then
  echo "✅ Indexes saved to firestore.indexes.json"
else
  echo "❌ Failed to fetch indexes. Check your internet or permissions."
  exit 1
fi

# 2. Review (Optional Pause)
echo ""
echo "👀 Content of firestore.indexes.json (First 10 lines):"
head -n 10 firestore.indexes.json
echo "..."
echo ""

# 3. Deploy to UAT
echo "🚀 Deploying Indexes to UAT (fresh-nest-uat)..."
npx firebase deploy --only firestore:indexes --project fresh-nest-uat

# 4. Deploy to PROD (Optional - Uncomment to auto-deploy to prod)
# echo "🚀 Deploying Indexes to PROD (fresh-nest-prod)..."
# npx firebase deploy --only firestore:indexes --project fresh-nest-prod

# 5. Commit to Git
echo "🌿 Committing updated index definitions..."
git add firestore.indexes.json
git commit -m "chore: sync firestore indexes from dev cloud"

echo "🎉 Indexes Synced!"

```
---

## FILE: scripts/update_status_masterplan9.sh
```sh
#!/bin/bash

echo "🔄 Realigning Roadmap to Master Plan 9 (Cornwall Context)..."

cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest (Worker Support Platform)

**Current Phase:** Phase 1 - Identity, Safety & Compliance
**Current Version:** v1.0.0 (Core Infrastructure Live)
**Context:** Cornwall, Ontario Socioeconomic Deployment
**Last Updated:** $(date +%Y-%m-%d)

> **Mission:** To transform the cleaning industry into a system of stability for marginalized workers while maintaining enterprise-grade reliability.

## 🎯 Current Sprint: The "Smart Profile" (Sprint 1)
We are upgrading the User Schema to support the complex realities of our workforce (ODSP limits, Transit reliance, Single parenthood).

* [ ] **User Schema Expansion:**
    * Add `financials.limit` (for "Carla" - ODSP).
    * Add `constraints.transport` (for "Jasmine" - Bus routes).
    * Add `constraints.blockedWindows` (for "Mike" - AA Meetings).
* [ ] **Profile Wizard:**
    * Self-onboarding flow for staff to set their own constraints.
    * **Legal:** Mandatory `acceptedTermsVersion` checkbox[cite: 117].
* [ ] **Localization Base:**
    * Prepare app for English/French toggle (for "Ahmed").

## 📋 Product Backlog (Master Plan 9)

### Phase 1: Safety & Constraints
* **The Conflict Engine:** Logic to auto-hide shifts that conflict with school runs (Emily) or recovery meetings (Mike)[cite: 46].
* **Financial Guardrails:** Hard system lock if `Current Earnings + Shift Price > ODSP Cap`[cite: 53].

### Phase 2: Field Operations
* **Visual Interface:** Replace text-heavy lists with Icon-based tasks (Mop, Toilet) for ESL accessibility[cite: 68].
* **Job Evidence:** Photo uploads to specific sub-collections for client verification (Brenda)[cite: 93].
* **Inventory Reports:** specific inputs for Airbnb supplies (Sophie)[cite: 102].

### Phase 3: Support & Scale
* **Crisis Protocol:** "SOS" button logic to swap shifts instantly[cite: 38].
* **Impact Dashboard:** Report on "Hours created for ODSP workers" for City Hall contracts (Sarah)[cite: 80].

---

## ✅ Version History

### v1.0.0 - Infrastructure Core (Completed)
* **Architecture:** Multi-Tenant SaaS (Firebase/React).
* **Security:** Role-Based Access Control (Admin/Staff).
* **Financials:** Admin Revenue Dashboard (Recharts).
* **DevOps:** CI/CD Pipelines (Dev/UAT/Prod).

---

## 🗄️ Database Schema Snapshot (Target State)

### `users/{userId}` [cite: 180]
* `profile`: { name, language, transport, acceptedTermsVersion }
* `financials`: { mode: 'cap', limit: number, currentMonthAccrued: number }
* `constraints`: { heavyLifting: boolean, blockedWindows: array }
* `stats`: { reliabilityScore: number }

### `shifts/{shiftId}` [cite: 205]
* `status`: 'open' | 'claimed' | 'completed'
* `contractLedger`: { claimedBy, claimedAt, rateSnapshot }
* `requirements`: { photoEvidence: array }

INNER_EOF

echo "✅ Project Status updated to Master Plan 9."

```
---

## FILE: .github/workflows/deploy-dev.yml
```yml
name: Deploy to DEV

on:
  push:
    branches:
      - dev

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      # 1. Inject Secrets
      - name: Create .env and Key Files
        run: |
          echo "${{ secrets.ENV_FILE_DEV }}" > .env
          echo '${{ secrets.FIREBASE_SERVICE_ACCOUNT_DEV }}' > service-account.json

      # 2. Build App
      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'development'

      # 3. Full Deployment (Hosting + Firestore)
      - name: Deploy to Firebase
        run: npx firebase deploy --project fresh-nest-dev --non-interactive
        env:
          GOOGLE_APPLICATION_CREDENTIALS: 'service-account.json'

```
---

## FILE: .github/workflows/deploy-prod.yml
```yml
name: Deploy to PROD

on:
  push:
    branches:
      - main

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      # 1. Inject Secrets
      - name: Create .env and Key Files
        run: |
          echo "${{ secrets.ENV_FILE_PROD }}" > .env
          echo '${{ secrets.FIREBASE_SERVICE_ACCOUNT_PROD }}' > service-account.json

      # 2. Build App
      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'production'

      # 3. Full Deployment (Hosting + Firestore)
      - name: Deploy to Firebase
        run: npx firebase deploy --project fresh-nest-prod --non-interactive
        env:
          GOOGLE_APPLICATION_CREDENTIALS: 'service-account.json'

```
---

## FILE: .github/workflows/deploy-uat.yml
```yml
name: Deploy to UAT

on:
  push:
    branches:
      - 'release/**'

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      # 1. Inject Secrets
      - name: Create .env and Key Files
        run: |
          echo "${{ secrets.ENV_FILE_UAT }}" > .env
          echo '${{ secrets.FIREBASE_SERVICE_ACCOUNT_UAT }}' > service-account.json

      # 2. Build App
      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'uat'

      # 3. Full Deployment (Hosting + Firestore)
      - name: Deploy to Firebase
        run: npx firebase deploy --project fresh-nest-uat --non-interactive
        env:
          GOOGLE_APPLICATION_CREDENTIALS: 'service-account.json'

```
---

