# FRESH NEST: CODEBASE DUMP
**Date:** Mon Jan 12 15:18:15 EST 2026
**Description:** Complete codebase context.

## FILE: package.json
```json
{
  "name": "fresh-nest",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint .",
    "preview": "vite preview"
  },
  "dependencies": {
    "clsx": "^2.1.1",
    "date-fns": "^4.1.0",
    "firebase": "^12.7.0",
    "firebase-admin": "^13.6.0",
    "lucide-react": "^0.562.0",
    "react": "^19.2.0",
    "react-dom": "^19.2.0",
    "react-router-dom": "^7.11.0",
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

// Get the current git commit hash
let commitHash = '';
try {
  commitHash = execSync('git rev-parse --short HEAD').toString().trim();
} catch (e) {
  commitHash = 'dev';
}

// Get version from package.json
import pkg from './package.json';

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  define: {
    __APP_VERSION__: JSON.stringify(pkg.version),
    __COMMIT_HASH__: JSON.stringify(commitHash),
    __BUILD_DATE__: JSON.stringify(new Date().toISOString().split('T')[0]),
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
import SettingsPage from './pages/SettingsPage'; // ✨ Imported
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
          <Route path="schedule" element={<SchedulePage />} />
          <Route path="clients" element={<ClientsPage />} />
          <Route path="settings" element={<SettingsPage />} /> {/* ✨ Added Route */}
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

## FILE: src/components/jobs/JobCardMobile.jsx
```jsx
import React from 'react';
import { Calendar, Clock, DollarSign, MapPin, User, CheckCircle, Play, Loader } from 'lucide-react';
import { format } from 'date-fns';
import { useJobWorkflow } from '../../hooks/useJobWorkflow';

const JobCardMobile = ({ job, getClientName, getClientAddress, getAssignedStaffName, userRole }) => {
  const { startJob, completeJob, canStart, canComplete, loading } = useJobWorkflow(job, userRole);

  const assignedName = getAssignedStaffName(job.assignedTo);
  const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;

  // Status Badge Helper
  const getStatusColor = (s) => {
    switch(s) {
      case 'completed': return 'bg-green-100 text-green-700';
      case 'in_progress': return 'bg-blue-100 text-blue-700';
      case 'cancelled': return 'bg-red-100 text-red-700';
      default: return 'bg-yellow-100 text-yellow-700';
    }
  };

  return (
    <div className="bg-white p-4 rounded-xl shadow-sm border border-gray-100">
      <div className="flex justify-between items-start mb-2">
        <div>
          <h3 className="font-bold text-slate-800 text-lg">{getClientName(job.clientId)}</h3>
          <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-slate-600 capitalize mt-1">
            {job.serviceType}
          </span>
        </div>
        <div className="text-right">
          <span className={`text-xs font-bold px-2 py-1 rounded-full uppercase ${getStatusColor(job.status)}`}>
            {job.status?.replace('_', ' ')}
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
        
        {/* RBAC: Hide Price if Staff */}
        {userRole !== 'staff' && job.price > 0 && (
          <div className="flex items-center gap-2 text-slate-500">
            <DollarSign size={16} className="text-slate-400 shrink-0" />
            <span>${job.price}</span>
          </div>
        )}
      </div>

      {/* ACTION BUTTONS */}
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
import React, { useState } from 'react';
import { X, Save, Loader, Calendar, DollarSign, User } from 'lucide-react';

const JobFormModal = ({ isOpen, onClose, onSave, clients, staff }) => {
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    clientId: '',
    assignedStaffId: '', // Single select for UI
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
        assignedStaffId: '',
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

          {/* STAFF ASSIGNMENT (New) */}
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
              Schedule Job
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

const JobListMobile = ({ jobs, clients, staff, userRole }) => {
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
import { MoreHorizontal, Calendar, Clock, MapPin, User, Edit, Trash2, Play, CheckCircle, XCircle } from 'lucide-react';
import { format } from 'date-fns';
import { useJobWorkflow } from '../../hooks/useJobWorkflow';

const JobRowDesktop = ({ job, getClient, getAssignedStaffName, userRole }) => {
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

            {/* EDIT (Placeholder) */}
            <button 
              onClick={() => alert('Edit feature coming soon')}
              className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors"
            >
              <Edit size={16} className="text-slate-400" /> Edit Details
            </button>
            
            {/* ADMIN ACTIONS */}
            {userRole === 'admin' && (
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
                  onClick={() => confirm("Delete?") && console.log('delete')}
                  className="w-full px-4 py-3 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors"
                >
                  <Trash2 size={16} /> Delete
                </button>
              </div>
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

const JobTableDesktop = ({ jobs, clients, staff, userRole }) => {
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
          <p>v{__APP_VERSION__} [{__COMMIT_HASH__}]</p>
          <p>{__BUILD_DATE__}</p>
        </div>
      </div>
    </aside>
  );
};

export default Sidebar;

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
  collection, 
  query, 
  where, 
  onSnapshot, 
  addDoc, 
  serverTimestamp, 
  orderBy,
  doc,
  getDoc
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useClients = () => {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentOrgId, setCurrentOrgId] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        // 1. Fetch User Profile to get the REAL OrgId (Source of Truth)
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setError("User profile not found.");
          setLoading(false);
          return;
        }

        const orgId = userDoc.data().orgId;
        setCurrentOrgId(orgId);

        if (!orgId) {
          setError("Organization ID missing from user profile.");
          setLoading(false);
          return;
        }

        // 2. Subscribe ONLY to clients in this user's Org
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

    // SECURITY: Force attach orgId and server timestamp
    await addDoc(collection(db, 'clients'), {
      ...clientData,
      orgId: currentOrgId, 
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    });
  };

  return { clients, loading, error, addClient };
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
  collection, query, where, onSnapshot, addDoc, serverTimestamp, orderBy, Timestamp, doc, getDoc 
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
        // 1. Fetch User Profile to get OrgId AND Role
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

        // 2. Construct Query based on Role
        let constraints = [
          where('orgId', '==', orgId),
          orderBy('scheduledDate', 'asc')
        ];

        // RBAC: If staff, ONLY show jobs assigned to them
        if (role === 'staff') {
          constraints.push(where('assignedTo', 'array-contains', user.uid));
        }

        const q = query(collection(db, 'jobs'), ...constraints);

        return onSnapshot(q, (snapshot) => {
          const jobData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            scheduledDate: doc.data().scheduledDate?.toDate()
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

  const addJob = async (jobData) => {
    if (!currentOrgId) throw new Error("No Organization ID found.");

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

  return { jobs, loading, error, addJob, role: userRole };
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

const JobsPage = () => {
  // Destructure 'role' from hook
  const { jobs, loading: jobsLoading, error: jobsError, addJob, role: userRole } = useJobs();
  const { clients, loading: clientsLoading } = useClients(); 
  const { staff, loading: staffLoading } = useStaff();

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const loading = jobsLoading || clientsLoading || staffLoading;

  const filteredJobs = jobs.filter(job => {
    const clientName = clients.find(c => c.id === job.clientId)?.name?.toLowerCase() || '';
    return clientName.includes(searchTerm.toLowerCase());
  });

  return (
    <div className="space-y-6">
      {/* Header - Hide 'New Job' button for Staff if desired (Optional, keeping visible for now or hide?) 
          Usually staff don't create jobs, but sticking to prompt reqs: Staff View Restrictions.
          Let's hide the Add button if staff for better UX.
      */}
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
          {/* Only Admin can add jobs */}
          {userRole === 'admin' && (
            <button 
              onClick={() => setIsModalOpen(true)}
              className="bg-brand-600 text-white px-4 py-2 rounded-lg font-semibold hover:bg-brand-700 flex items-center gap-2 shadow-sm whitespace-nowrap"
            >
              <Plus size={20} />
              <span className="hidden md:inline">New Job</span>
              <span className="md:hidden">New</span>
            </button>
          )}
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
          <JobListMobile jobs={filteredJobs} clients={clients} staff={staff} userRole={userRole} />
          <JobTableDesktop jobs={filteredJobs} clients={clients} staff={staff} userRole={userRole} />
        </>
      )}

      <JobFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={addJob} 
        clients={clients} 
        staff={staff}
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
import { useSchedule } from '../hooks/useSchedule';
import { useClients } from '../hooks/useClients';
import DateStrip from '../components/schedule/DateStrip';
import DailyAgenda from '../components/schedule/DailyAgenda';

const SchedulePage = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());

  const weekStart = startOfWeek(selectedDate, { weekStartsOn: 1 }); 
  const weekEnd = endOfWeek(selectedDate, { weekStartsOn: 1 });     

  // Destructure role here
  const { jobs, loading: scheduleLoading, error, role: userRole } = useSchedule(weekStart, weekEnd);
  const { clients, loading: clientsLoading } = useClients();

  const todaysJobs = jobs.filter(job => 
    job.scheduledDate && isSameDay(job.scheduledDate, selectedDate)
  );

  return (
    <div className="bg-gray-50 min-h-full pb-20">
      <div className="sticky top-0 z-10">
        <DateStrip 
          selectedDate={selectedDate} 
          onSelectDate={setSelectedDate} 
        />
      </div>

      <main>
        {error && (
          <div className="p-4 m-4 bg-red-50 text-red-600 rounded-lg text-sm text-center">
            {error}
          </div>
        )}

        <DailyAgenda 
          jobs={todaysJobs} 
          clients={clients} 
          loading={scheduleLoading || clientsLoading} 
          selectedDate={selectedDate}
          userRole={userRole} 
        />
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
import { Mail, User, Shield, Plus, Loader } from 'lucide-react';
import { useStaff } from '../hooks/useStaff';
import { auth, db } from '../lib/firebase';
import { collection, addDoc, serverTimestamp, doc, getDoc } from 'firebase/firestore';

const SettingsPage = () => {
  const { staff, loading: staffLoading } = useStaff();
  const [inviteEmail, setInviteEmail] = useState('');
  const [inviteRole, setInviteRole] = useState('staff');
  const [inviteLoading, setInviteLoading] = useState(false);

  const handleInvite = async (e) => {
    e.preventDefault();
    setInviteLoading(true);
    try {
      const user = auth.currentUser;
      // Get Org ID
      const userDoc = await getDoc(doc(db, 'users', user.uid));
      const orgId = userDoc.data().orgId;

      // Create Invite Doc
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
        <p className="text-slate-500 text-sm">Manage your team and organization</p>
      </div>

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
                  {member.email[0].toUpperCase()}
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
  );
};

export default SettingsPage;

```
---

## FILE: docs/CONTEXT_DUMP.md
```md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- **CRITICAL:** `orgId` is stored in the **Firestore User Profile** (`users/{uid}`).

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **invites/{inviteId}**: { email, orgId, role }
- **jobs/{jobId}**: 
    - `assignedTo`: [userId]
    - `status`: 'scheduled' | 'in_progress' | 'completed' | 'cancelled'
    - `startedAt`: Timestamp
    - `completedAt`: Timestamp
    - `price`: Number
- **clients/{clientId}**: { name, address, orgId, email, phone }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId` (Custom Claims) in React Code.** It is stale.
   - **ALWAYS** fetch `users/{uid}` from Firestore to get the current `orgId`.
   - All Firestore queries MUST filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **Date Handling:** Use `date-fns`.

```
---

## FILE: docs/DEVOPS_MANUAL.md
```md
# ☁️ DevOps & Infrastructure Manual

## 1. CI/CD Architecture
We use **GitHub Actions** for all deployments.
* **Workflows:** Located in `.github/workflows/`
* **Secrets:** Managed in GitHub Repo Settings -> Secrets -> Actions.

## 2. GitHub Secrets (Required)
If setting up a new repo, these secrets must be present:

| Secret Name | Content |
| :--- | :--- |
| `FIREBASE_SERVICE_ACCOUNT_DEV` | JSON key for Dev Project |
| `FIREBASE_SERVICE_ACCOUNT_UAT` | JSON key for UAT Project |
| `FIREBASE_SERVICE_ACCOUNT_PROD` | JSON key for Prod Project |
| `ENV_FILE_DEV` | Content of local `.env.development` |
| `ENV_FILE_UAT` | Content of local `.env.uat` |
| `ENV_FILE_PROD` | Content of local `.env.production` |

## 3. Versioning
* **SemVer:** Manually managed in `package.json` (e.g., `0.1.0`).
* **Build Number:** Auto-incremented via `scripts/increment-build.cjs` on every cloud build.
* **Git Hash:** Injected into the app footer for debugging.

## 4. Troubleshooting
**"Invalid API Key" in Production?**
* Check that `ENV_FILE_PROD` in GitHub Secrets is not empty.
* Check that the variable names in the secret start with `VITE_`.
* Re-run the workflow in the GitHub Actions tab.

```
---

## FILE: docs/PROJECT_STATUS.md
```md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 2 - Core Workflows
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment.
* **Worker View:** RBAC, Role-Aware Hooks, UI Restrictions.
* **Job Workflow:** Status Transitions (Start/Complete/Cancel) with Timestamps.
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Job Edit/Delete:** Full CRUD for Admins.
* [ ] **Google Maps Integration:** Visualizing daily routes.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, fullName, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, startedAt, completedAt, ... }
* `clients/{clientId}`: { name, address, orgId, ... }

```
---

## FILE: docs/PROMPT_APPROVAL.md
```md
# ✅ AI Approval & Execution Prompt

**Instructions:**
Use this prompt **after** the AI has presented the 3 Architectural Options. This signals approval for the **Recommended (Robust)** approach and enforces strict coding standards.

---

### **Prompt Template**

**Decision:** I approve the **Recommended (Robust) Approach**. Proceed with implementation.

**Strict Technical Constraints (Best Practices):**
1.  **React:** Use functional components. Isolate logic in Custom Hooks (e.g., `useJobWorkflow`).
2.  **Tailwind:** Use mobile-first classes (`block md:flex`). Avoid arbitrary values (e.g., `w-[350px]`) — use the theme.
3.  **Firebase & Security (CRITICAL):**
    * **NO AUTH TOKENS:** Do NOT use `idTokenResult` or `request.auth.token` to get `orgId` or `role`. You MUST fetch the **User Profile** from Firestore.
    * **Isolation:** ALL `onSnapshot` queries must filter by `.where("orgId", "==", currentOrgId)`.
    * **Writes:** ALL `addDoc`/`updateDoc` calls must be strictly validated.
    * **Timestamps:** Use `serverTimestamp()` for `createdAt`/`updatedAt`.
4.  **Code Quality:** No "placeholder" code. Complete files only.

**Output Requirements:**

1.  **The "One-Shot" Installer:**
    * Provide a single bash script named `scripts/install_feature.sh`.
    * This script must use `cat << 'EOF' > path/to/file` to safely create/overwrite files.
    * *Note:* Ensure you escape special characters (`$`) in the bash script correctly so the React code generates properly.

2.  **QA Checklist (Manual Testing):**
    * Provide 3-5 specific tests.
    * **Mandatory:** Include a **"Role Switching"** test (e.g., "Log in as Staff -> Verify Button X is hidden").
    * **Mandatory:** Include a **"Data Integrity"** test (e.g., "Verify Firestore document has 'startedAt' timestamp").

3.  **Firestore Indexes (If applicable):**
    * If your queries use `orderBy`, explicitly state if a new entry is needed in `firestore.indexes.json`.

4.  **Git Documentation:**
    * Provide a **Git Commit Comment Block** at the end.
    * Format:
        * **Message:** `feat: [summary]`
        * **Description:** Bullet points of changes.

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
# 📝 AI Feature Request Prompt (Architectural Mode)

**Instructions:**
1.  Ensure you have already initialized the AI session using the `PROMPT_INITIALIZATION.md` template.
2.  Copy the **Prompt Template** below into your AI Chat.
3.  Fill in the bracketed sections `[ ... ]` with your specific requirements.

---

### **Prompt Template**

**Feature Request:** [INSERT FEATURE NAME]

**Context:**
I need to add a module to "Fresh Nest" that allows [WHO] to [DO WHAT].
*Current State:* [Briefly describe relevant existing code, e.g., "We have a Jobs List, but no way to change status."]

**Core Requirements:**

1.  **Data & Schema:**
    * [What new collections or fields do we need?]
    * [e.g., "Add 'startedAt' timestamp to 'jobs' collection"]

2.  **UI (Mobile First):**
    * **Mobile:** [How does it look on phone? e.g., "Swipe to complete", "Big button"]
    * **Desktop:** [How does it look on PC? e.g., "Table Action Menu"]

3.  **Security & RBAC (Crucial):**
    * **Admin:** [What can they do? e.g., "Edit anything"]
    * **Staff:** [What are they RESTRICTED from? e.g., "Can only update their own assigned jobs"]

4.  **Logic & Constraints:**
    * **Architecture:** Must use the "Database Lookup" pattern for `orgId`. NO `auth.token` usage.
    * **State:** [Real-time updates required?]

**🛑 STOP & THINK: Architectural Options**
Before writing any code, please propose **3 Distinct Approaches** to implementing this feature:

1.  **The "Direct/Inline" Approach:** Logic inside components. Fast, but hard to test/reuse.
2.  **The "Custom Hook" Approach (Recommended):** Logic extracted to `use[Feature]`. Handles DB subscriptions, loading states, and RBAC checks internally. Keeps UI clean.
3.  **The "Complex/Global" Approach:** Uses global context providers or cloud functions for simple logic. Overkill?

**Your Task:**
1.  Briefly describe these 3 options (Pros/Cons).
2.  Recommend which one fits our current architecture best.
3.  **List exact Schema Changes** (New fields/Collections).
4.  **WAIT** for my confirmation before generating code.


```
---

## FILE: docs/PROMPT_INITIALIZATION.md
```md
# 🤖 AI Session Initialization Prompt

**Instructions:**
1.  Run `scripts/generate-context.sh` to copy your current codebase to your clipboard (or file).
2.  Paste the **Codebase Context** into the bottom of this prompt.
3.  Send the *entire* block below to your AI assistant to start a new session.

---

**Role:** You are the Senior Lead Developer and Architect for "Fresh Nest," a React + Firebase SaaS application.

**Input:** I am providing the full codebase context below.

**Your Goal:** Ingest this context to completely understand our:
* **Tech Stack:** React (Vite), Tailwind CSS, Firebase (Auth, Firestore, Functions).
* **Architecture:** Multi-Tenant SaaS using `orgId` in Custom Claims for data isolation.
* **Current State:** File structure, existing components, and coding style.

**Critical Rules for Interaction:**
1.  **NO Placeholders:** Never use `// ... rest of code` or `// ... existing logic`. Always provide **COMPLETE, COPY-PASTEABLE FILES**.
2.  **Mobile First:** All UI must be fully responsive. Use Tailwind's `md:`, `lg:` prefixes.
3.  **Icons:** Use `lucide-react` for all icons.
4.  **Security & Data:**
    * Every Firestore query MUST filter by `.where("orgId", "==", user.orgId)`.
    * Every write must include `orgId`.
    * **If a query involves Sorting (`orderBy`), you must explicitly warn about required Firestore Indexes.**
5.  **Functionality & Quality:**
    * **All buttons and inputs must be functional** (e.g., `onClick` handlers attached, Form `onSubmit` handled). Do not build "UI-only" shells unless asked.
    * **Adhere to HTML best practices** (e.g., proper `autocomplete` attributes on inputs, `type="button"` vs `type="submit"`).
6.  **Style:** Use standard React Hooks patterns and clean, modular code.

**Codebase Context:**
[PASTE_FULL_CODEBASE_CONTEXT_HERE]

**Reply "Context Received. Ready for instructions." if you understand.**

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
# Feature: Job Workflow (Status Transitions)
# ====================================================

echo "🏁 Initiating Close-Out for: Job Workflow..."

# 1. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 2 - Core Workflows
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment.
* **Worker View:** RBAC, Role-Aware Hooks, UI Restrictions.
* **Job Workflow:** Status Transitions (Start/Complete/Cancel) with Timestamps.
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Job Edit/Delete:** Full CRUD for Admins.
* [ ] **Google Maps Integration:** Visualizing daily routes.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, fullName, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, startedAt, completedAt, ... }
* `clients/{clientId}`: { name, address, orgId, ... }
INNER_EOF

# 2. Update Context Dump (Crucial for AI Memory)
# We add the new status/timestamp fields to the schema definition
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- **CRITICAL:** `orgId` is stored in the **Firestore User Profile** (`users/{uid}`).

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **invites/{inviteId}**: { email, orgId, role }
- **jobs/{jobId}**: 
    - `assignedTo`: [userId]
    - `status`: 'scheduled' | 'in_progress' | 'completed' | 'cancelled'
    - `startedAt`: Timestamp
    - `completedAt`: Timestamp
    - `price`: Number
- **clients/{clientId}**: { name, address, orgId, email, phone }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId` (Custom Claims) in React Code.** It is stale.
   - **ALWAYS** fetch `users/{uid}` from Firestore to get the current `orgId`.
   - All Firestore queries MUST filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **Date Handling:** Use `date-fns`.
INNER_EOF

# 3. Commit Final Changes
echo "🌿 Committing Documentation & Code..."
git add .
git commit -m "feat: complete job workflow and update docs schema"

# 4. Cut Release (Triggers UAT)
VERSION="v0.3.0-workflow-$(date +%s)"
echo "🚀 Cutting Release Branch: release/$VERSION"

git checkout -b "release/$VERSION"
git push origin "release/$VERSION"

echo "✅ Release Pushed to GitHub!"
echo "👉 Action: 'Deploy to UAT' should be running now."

# 5. Merge to Dev & Cleanup
echo "🔄 Syncing Dev Branch..."
git checkout dev
git pull origin dev
git merge "feature/job-workflow"
git push origin dev

# 6. Delete Local Feature Branch
# We stay on 'dev' now.
echo "🗑️  Deleting local feature branch..."
git branch -d feature/job-workflow

echo "🎉 SUCCESS! Feature Closed."
echo "   - UAT is deploying (release/$VERSION)"
echo "   - Dev is up to date"
echo "   - Docs are updated with new Schema"

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

## FILE: scripts/fix_settings.sh
```sh
#!/bin/bash

echo "🔧 Fixing Settings Page Redirect..."

# 1. Create the Settings Page Component
# This restores the UI to view Staff and send Invites
echo "📝 Creating src/pages/SettingsPage.jsx..."
cat << 'EOF' > src/pages/SettingsPage.jsx
import React, { useState } from 'react';
import { Mail, User, Shield, Plus, Loader } from 'lucide-react';
import { useStaff } from '../hooks/useStaff';
import { auth, db } from '../lib/firebase';
import { collection, addDoc, serverTimestamp, doc, getDoc } from 'firebase/firestore';

const SettingsPage = () => {
  const { staff, loading: staffLoading } = useStaff();
  const [inviteEmail, setInviteEmail] = useState('');
  const [inviteRole, setInviteRole] = useState('staff');
  const [inviteLoading, setInviteLoading] = useState(false);

  const handleInvite = async (e) => {
    e.preventDefault();
    setInviteLoading(true);
    try {
      const user = auth.currentUser;
      // Get Org ID
      const userDoc = await getDoc(doc(db, 'users', user.uid));
      const orgId = userDoc.data().orgId;

      // Create Invite Doc
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
        <p className="text-slate-500 text-sm">Manage your team and organization</p>
      </div>

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
                  {member.email[0].toUpperCase()}
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
  );
};

export default SettingsPage;
EOF

# 2. Register Route in App.jsx
echo "📝 Updating src/App.jsx to include Settings route..."
cat << 'EOF' > src/App.jsx
import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import AppLayout from './components/layout/AppLayout';
import AuthGuard from './components/layout/AuthGuard';
import LoginPage from './features/auth/LoginPage';
import ClientsPage from './pages/ClientsPage';
import JobsPage from './pages/JobsPage';
import SchedulePage from './pages/SchedulePage';
import SettingsPage from './pages/SettingsPage'; // ✨ Imported
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
          <Route path="schedule" element={<SchedulePage />} />
          <Route path="clients" element={<ClientsPage />} />
          <Route path="settings" element={<SettingsPage />} /> {/* ✨ Added Route */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
EOF

echo "✅ Settings Page restored and route registered."
```
---

## FILE: scripts/fix_staff_org.cjs
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

async function fixOrg() {
  try {
    console.log(`🔧 Fixing Org Mismatch...`);

    // 1. Get Admin's Org ID (The Source of Truth)
    const adminAuth = await auth.getUserByEmail(ADMIN_EMAIL);
    const adminDoc = await db.collection('users').doc(adminAuth.uid).get();
    
    if (!adminDoc.exists) {
      console.error("❌ Admin profile not found. Cannot proceed.");
      return;
    }

    const correctOrgId = adminDoc.data().orgId;
    console.log(`✅ Admin Org ID: ${correctOrgId}`);

    // 2. Get Staff User
    const staffAuth = await auth.getUserByEmail(STAFF_EMAIL);
    const staffRef = db.collection('users').doc(staffAuth.uid);

    // 3. Force Update Staff
    await staffRef.set({
      orgId: correctOrgId
    }, { merge: true }); // 'merge: true' keeps other fields like email/role intact

    console.log(`✅ SUCCESS! Moved ${STAFF_EMAIL} into Org: ${correctOrgId}`);
    console.log("👉 Refresh your browser. You should see them in Settings now.");

  } catch (error) {
    console.error("❌ Error:", error.message);
  }
}

fixOrg();

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

## FILE: scripts/init-org.js
```js
/**
 * scripts/init-org.js
 * USAGE: 
 * 1. Ensure service-account.json is in this folder (scripts/).
 * 2. Run: node scripts/init-org.cjs
 */

const admin = require('firebase-admin');
// Ensure this file exists! You downloaded it from Firebase Console -> Project Settings -> Service Accounts
const serviceAccount = require('./service-account.json'); 

// --- CONFIGURATION ---
const TARGET_EMAIL = "FN_TEST_CLEANER@gmail.com"; // <--- The account you want to give a "Home" to
const ORG_NAME = "Cleaner Test Org";              // <--- The name of their new Organization
// ---------------------

// Initialize the Admin SDK
// Check if already initialized to avoid hot-reload errors (though rare in scripts)
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

    // 1. Find the user
    let user;
    try {
      user = await auth.getUserByEmail(TARGET_EMAIL);
      console.log(`✅ Found User: ${user.uid}`);
    } catch (e) {
      console.error(`❌ User ${TARGET_EMAIL} not found in Auth. Did you sign up in the browser first?`);
      process.exit(1);
    }

    // 2. Create the Organization
    const orgRef = await db.collection('organizations').add({
      name: ORG_NAME,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      plan: 'basic', // Default plan for new orgs
      settings: {
        currency: 'USD',
        geoFenceRadius: 200
      }
    });
    console.log(`✅ Created Organization: ${orgRef.id} (${ORG_NAME})`);

    // 3. Update the User Profile (Firestore)
    // We create a public profile for this user so we can find them easily later
    await db.collection('users').doc(user.uid).set({
      email: user.email,
      orgId: orgRef.id,
      role: 'admin', // First user is always admin
      fullName: 'Test User',
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
    console.log(`✅ Created User Profile in Firestore`);

    // 4. Set Custom Claims (The "Magic" Token)
    // This allows the frontend to know their role without querying the DB
    await auth.setCustomUserClaims(user.uid, {
      orgId: orgRef.id,
      role: 'admin'
    });
    console.log(`✅ Claims set on Auth Token!`);

    console.log("\n🎉 SUCCESS! You MUST Sign Out and Sign In again on the app to refresh your token.");

  } catch (error) {
    console.error("❌ Error during bootstrap:", error);
  }
}

bootstrap();
```
---

## FILE: scripts/install_feature.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: JOB WORKFLOW INSTALLER
# Feature: Status Transitions (Start/Complete)
# Approach: Custom Hook + Component Extraction
# ====================================================

echo "🚀 Installing Job Workflow Feature..."

# 1. Create the Logic Hook
# Handles DB updates, Timestamps, and RBAC logic (Admin vs Assigned Staff)
echo "📝 Creating src/hooks/useJobWorkflow.js..."
cat << 'INNER_EOF' > src/hooks/useJobWorkflow.js
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
INNER_EOF

# 2. Extract Mobile Card Component
# We extract this so we can call the useJobWorkflow hook inside it validly
echo "📝 Creating src/components/jobs/JobCardMobile.jsx..."
cat << 'INNER_EOF' > src/components/jobs/JobCardMobile.jsx
import React from 'react';
import { Calendar, Clock, DollarSign, MapPin, User, CheckCircle, Play, Loader } from 'lucide-react';
import { format } from 'date-fns';
import { useJobWorkflow } from '../../hooks/useJobWorkflow';

const JobCardMobile = ({ job, getClientName, getClientAddress, getAssignedStaffName, userRole }) => {
  const { startJob, completeJob, canStart, canComplete, loading } = useJobWorkflow(job, userRole);

  const assignedName = getAssignedStaffName(job.assignedTo);
  const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;

  // Status Badge Helper
  const getStatusColor = (s) => {
    switch(s) {
      case 'completed': return 'bg-green-100 text-green-700';
      case 'in_progress': return 'bg-blue-100 text-blue-700';
      case 'cancelled': return 'bg-red-100 text-red-700';
      default: return 'bg-yellow-100 text-yellow-700';
    }
  };

  return (
    <div className="bg-white p-4 rounded-xl shadow-sm border border-gray-100">
      <div className="flex justify-between items-start mb-2">
        <div>
          <h3 className="font-bold text-slate-800 text-lg">{getClientName(job.clientId)}</h3>
          <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-slate-600 capitalize mt-1">
            {job.serviceType}
          </span>
        </div>
        <div className="text-right">
          <span className={`text-xs font-bold px-2 py-1 rounded-full uppercase ${getStatusColor(job.status)}`}>
            {job.status?.replace('_', ' ')}
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
        
        {/* RBAC: Hide Price if Staff */}
        {userRole !== 'staff' && job.price > 0 && (
          <div className="flex items-center gap-2 text-slate-500">
            <DollarSign size={16} className="text-slate-400 shrink-0" />
            <span>${job.price}</span>
          </div>
        )}
      </div>

      {/* ACTION BUTTONS */}
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
INNER_EOF

# 3. Update JobListMobile to use the new card
echo "📝 Updating src/components/jobs/JobListMobile.jsx..."
cat << 'INNER_EOF' > src/components/jobs/JobListMobile.jsx
import React from 'react';
import JobCardMobile from './JobCardMobile';

const JobListMobile = ({ jobs, clients, staff, userRole }) => {
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
        />
      ))}
    </div>
  );
};

export default JobListMobile;
INNER_EOF

# 4. Extract Desktop Row Component
# Same pattern: Extract row to use hooks safely
echo "📝 Creating src/components/jobs/JobRowDesktop.jsx..."
cat << 'INNER_EOF' > src/components/jobs/JobRowDesktop.jsx
import React, { useState, useRef, useEffect } from 'react';
import { MoreHorizontal, Calendar, Clock, MapPin, User, Edit, Trash2, Play, CheckCircle, XCircle } from 'lucide-react';
import { format } from 'date-fns';
import { useJobWorkflow } from '../../hooks/useJobWorkflow';

const JobRowDesktop = ({ job, getClient, getAssignedStaffName, userRole }) => {
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

            {/* EDIT (Placeholder) */}
            <button 
              onClick={() => alert('Edit feature coming soon')}
              className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors"
            >
              <Edit size={16} className="text-slate-400" /> Edit Details
            </button>
            
            {/* ADMIN ACTIONS */}
            {userRole === 'admin' && (
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
                  onClick={() => confirm("Delete?") && console.log('delete')}
                  className="w-full px-4 py-3 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors"
                >
                  <Trash2 size={16} /> Delete
                </button>
              </div>
            )}
          </div>
        )}
      </td>
    </tr>
  );
};

export default JobRowDesktop;
INNER_EOF

# 5. Update JobTableDesktop to use the new Row component
echo "📝 Updating src/components/jobs/JobTableDesktop.jsx..."
cat << 'INNER_EOF' > src/components/jobs/JobTableDesktop.jsx
import React from 'react';
import JobRowDesktop from './JobRowDesktop';

const JobTableDesktop = ({ jobs, clients, staff, userRole }) => {
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
            />
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default JobTableDesktop;
INNER_EOF

echo "✅ SUCCESS! Job Workflow features installed."

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

echo "✅ Merged and Pushed! GitHub Action is now deploying to Fresh-Nest-Dev."
echo "👉 Check status here: https://github.com/rpdouglas/fresh-nest/actions"

```
---

## FILE: scripts/promote_to_prod.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: PROD PROMOTER
# Goal: Merge the active Release branch into Main
# ====================================================

current_branch=$(git branch --show-current)

# Ensure we are on a release branch
if [[ "$current_branch" != release/* ]]; then
  echo "❌ You must be on a 'release/...' branch to promote to Prod."
  echo "   Current: $current_branch"
  exit 1
fi

echo "🚀 Promoting $current_branch to Production..."

# 1. Switch to Main and Sync
git checkout main
git pull origin main

# 2. Merge the Release
git merge "$current_branch"

# 3. Push to Main (Triggers PROD Action)
git push origin main

echo "✅ Promoted to Prod!"
echo "👉 GitHub Action is now deploying to Fresh-Nest-Prod."

```
---

## FILE: scripts/release_to_uat.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: RELEASE MANAGER
# Goal: Cut a release branch from DEV and push to UAT
# ====================================================

# 1. Sync Dev
echo "🔄 Syncing Dev..."
git checkout dev
git pull origin dev

# 2. Generate Version Name (Time-based for now)
# In the future, we can use semantic versioning (v0.1.1, etc)
version="v0.1.0-rc-$(date +%s)"
branch_name="release/$version"

echo "🌿 Creating Release Branch: $branch_name"
git checkout -b "$branch_name"

# 3. Push to GitHub (Triggers UAT Action)
echo "🚀 Pushing to UAT..."
git push origin "$branch_name"

echo "✅ Release Pushed!"
echo "👉 GitHub Action is now deploying to Fresh-Nest-UAT."
echo "👉 When UAT is verified, merge this PR into 'main' to deploy to PROD."

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

## FILE: scripts/setup-cicd.sh
```sh
#!/bin/bash

# ====================================================
# FRESH NEST: CI/CD PIPELINE INSTALLER
# Sets up GitHub Actions for Dev, UAT, and Prod
# ====================================================

echo "🚀 Setting up GitHub Actions Workflows..."

# 1. Create the Workflows Directory
mkdir -p .github/workflows

# 2. Create DEV Pipeline
echo "📝 Writing .github/workflows/deploy-dev.yml..."
cat << 'EOF' > .github/workflows/deploy-dev.yml
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

      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'development'

      - name: Deploy to Firebase Hosting (DEV)
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_DEV }}'
          channelId: live
          projectId: fresh-nest-dev
EOF

# 3. Create UAT Pipeline (Release Branches)
echo "📝 Writing .github/workflows/deploy-uat.yml..."
cat << 'EOF' > .github/workflows/deploy-uat.yml
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

      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'uat'

      - name: Deploy to Firebase Hosting (UAT)
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_UAT }}'
          channelId: live
          projectId: fresh-nest-uat
EOF

# 4. Create PROD Pipeline (Main Branch)
echo "📝 Writing .github/workflows/deploy-prod.yml..."
cat << 'EOF' > .github/workflows/deploy-prod.yml
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

      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'production'

      - name: Deploy to Firebase Hosting (PROD)
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_PROD }}'
          channelId: live
          projectId: fresh-nest-prod
EOF

# 5. Create Local Helper Script
echo "📝 Writing scripts/merge_to_dev.sh..."
cat << 'EOF' > scripts/merge_to_dev.sh
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

echo "✅ Merged and Pushed! GitHub Action is now deploying to Fresh-Nest-Dev."
echo "👉 Check status here: https://github.com/rpdouglas/freshnest/actions"
EOF

chmod +x scripts/merge_to_dev.sh

echo "✅ SUCCESS! CI/CD Pipelines Installed."
echo "👉 Run: git add . && git commit -m 'chore: setup github actions' && git push origin main"
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

## FILE: scripts/update_docs.sh
```sh
#!/bin/bash

echo "📚 Updating Documentation Suite..."

# 1. Update Context Generator to include Workflows
# We want the AI to be able to see your CI/CD pipelines in future sessions.
echo "⚙️ Updating scripts/generate-context.sh..."
cat << 'INNER_EOF' > scripts/generate-context.sh
#!/bin/bash

OUTPUT_FILE="docs/FULL_CODEBASE_CONTEXT.md"

echo "🔄 Generating Context Dump..."
echo "# FRESH NEST: CODEBASE DUMP" > "\$OUTPUT_FILE"
echo "**Date:** \$(date)" >> "\$OUTPUT_FILE"
echo "**Description:** Complete codebase context." >> "\$OUTPUT_FILE"
echo "" >> "\$OUTPUT_FILE"

ingest_file() {
    local filepath="\$1"
    if [[ "\$filepath" == *".env"* ]] || [[ "\$filepath" == *"service-account"* ]] || [[ "\$filepath" == *".DS_Store"* ]]; then return; fi
    if [ -f "\$filepath" ]; then
        echo "Processing: \$filepath"
        echo "## FILE: \$filepath" >> "\$OUTPUT_FILE"
        echo "\`\`\`\${filepath##*.}" >> "\$OUTPUT_FILE"
        cat "\$filepath" >> "\$OUTPUT_FILE"
        echo "" >> "\$OUTPUT_FILE"
        echo "\`\`\`" >> "\$OUTPUT_FILE"
        echo "---" >> "\$OUTPUT_FILE"
        echo "" >> "\$OUTPUT_FILE"
    fi
}

# Root Configs
ingest_file "package.json"
ingest_file "vite.config.js"
ingest_file "tailwind.config.js"
ingest_file "firebase.json"
ingest_file ".firebaserc"

# Source Code
find src -type f -not -path "*/.*" | sort | while read file; do ingest_file "\$file"; done

# Documentation
find docs -type f -name "*.md" -not -name "FULL_CODEBASE_CONTEXT.md" | sort | while read file; do ingest_file "\$file"; done

# Scripts
find scripts -type f \( -name "*.js" -o -name "*.cjs" -o -name "*.sh" \) | sort | while read file; do ingest_file "\$file"; done

# CI/CD Workflows (NEW)
find .github/workflows -type f -name "*.yml" | sort | while read file; do ingest_file "\$file"; done

echo "✅ Context Generated at: \$OUTPUT_FILE"
INNER_EOF
chmod +x scripts/generate-context.sh

# 2. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 1 Complete / Infrastructure Mature
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment (`useStaff`).
* **DevOps (NEW):** * 3-Environment CI/CD (Dev/UAT/Prod).
    * Automated Build Versioning.
    * Secret Injection via GitHub Actions.

## 🚧 In Progress / Next Up
* [ ] **Worker View:** Restricted dashboard for staff.
* [ ] **Job Workflow:** Status transitions (Start/Finish).

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, ... }
INNER_EOF

# 3. Update SOP (Source Control)
echo "📝 Updating docs/SOP_SOURCE_CONTROL.md..."
cat << 'INNER_EOF' > docs/SOP_SOURCE_CONTROL.md
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
INNER_EOF

# 4. Create DevOps Manual (NEW)
echo "📝 Creating docs/DEVOPS_MANUAL.md..."
cat << 'INNER_EOF' > docs/DEVOPS_MANUAL.md
# ☁️ DevOps & Infrastructure Manual

## 1. CI/CD Architecture
We use **GitHub Actions** for all deployments.
* **Workflows:** Located in `.github/workflows/`
* **Secrets:** Managed in GitHub Repo Settings -> Secrets -> Actions.

## 2. GitHub Secrets (Required)
If setting up a new repo, these secrets must be present:

| Secret Name | Content |
| :--- | :--- |
| `FIREBASE_SERVICE_ACCOUNT_DEV` | JSON key for Dev Project |
| `FIREBASE_SERVICE_ACCOUNT_UAT` | JSON key for UAT Project |
| `FIREBASE_SERVICE_ACCOUNT_PROD` | JSON key for Prod Project |
| `ENV_FILE_DEV` | Content of local `.env.development` |
| `ENV_FILE_UAT` | Content of local `.env.uat` |
| `ENV_FILE_PROD` | Content of local `.env.production` |

## 3. Versioning
* **SemVer:** Manually managed in `package.json` (e.g., `0.1.0`).
* **Build Number:** Auto-incremented via `scripts/increment-build.cjs` on every cloud build.
* **Git Hash:** Injected into the app footer for debugging.

## 4. Troubleshooting
**"Invalid API Key" in Production?**
* Check that `ENV_FILE_PROD` in GitHub Secrets is not empty.
* Check that the variable names in the secret start with `VITE_`.
* Re-run the workflow in the GitHub Actions tab.
INNER_EOF

echo "✅ Documentation Updated Successfully."
echo "👉 You should commit these changes now."

```
---

## FILE: scripts/update_docs_v2.sh
```sh
#!/bin/bash

echo "📚 Performing Comprehensive Documentation Update..."

# ==========================================
# 1. UPDATE PROJECT STATUS
# ==========================================
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 2 - Core Workflows
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment.
* **Worker View (RBAC):** * "Ghost Client" fix (DB Lookup vs Token).
    * Role-Aware Hooks (`useJobs`, `useClients`).
    * UI Restrictions (Hidden Prices, Hidden Buttons).
* **DevOps:** * 3-Environment CI/CD (Dev/UAT/Prod) with Firestore Rules/Indexes.
    * Environment-aware seeding scripts.

## 🚧 In Progress / Next Up
* [ ] **Job Workflow:** Allow staff to mark jobs as "In Progress" / "Completed".
* [ ] **Job Edit/Delete:** Full CRUD for Admins.
* [ ] **Google Maps Integration:** Visualizing daily routes.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, fullName, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, price, ... }
* `clients/{clientId}`: { name, address, orgId, ... }
INNER_EOF

# ==========================================
# 2. UPDATE CONTEXT DUMP (The Architectural Rules)
# ==========================================
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- **CRITICAL:** `orgId` is stored in the **Firestore User Profile** (`users/{uid}`).

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **invites/{inviteId}**: { email, orgId, role }
- **jobs/{jobId}**: { assignedTo: [userId], status, serviceType, ... }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId` (Custom Claims) in React Code.** It is stale.
   - **ALWAYS** fetch `users/{uid}` from Firestore to get the current `orgId`.
   - All Firestore queries MUST filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **Date Handling:** Use `date-fns`.
INNER_EOF

# ==========================================
# 3. UPDATE DEVOPS MANUAL
# ==========================================
echo "📝 Updating docs/DEVOPS_MANUAL.md..."
cat << 'INNER_EOF' > docs/DEVOPS_MANUAL.md
# ☁️ DevOps & Infrastructure Manual

## 1. CI/CD Architecture
We use **GitHub Actions** for "Full Stack" deployments.
* **Workflows:** `.github/workflows/`
* **What Deploys:** Hosting + Firestore Security Rules + Firestore Indexes.
* **Triggers:**
  * `dev` branch -> **Dev** Environment
  * `release/*` branch -> **UAT** Environment
  * `main` branch -> **Production** Environment

## 2. Environment Management
We use "Environment-Aware" scripts. You must pass the target environment (`dev`, `uat`, `prod`) as an argument.

### A. Initialization (New Env)
Sets up the Admin User and Organization.
\`\`\`bash
node scripts/init-org.cjs uat
\`\`\`

### B. Seeding Staff Users
Creates a test staff account linked to the Admin's Org.
\`\`\`bash
node scripts/create_staff_user.cjs uat
\`\`\`

## 3. GitHub Secrets (Required)
| Secret Name | Content |
| :--- | :--- |
| `FIREBASE_SERVICE_ACCOUNT_DEV` | JSON key for Dev |
| `FIREBASE_SERVICE_ACCOUNT_UAT` | JSON key for UAT |
| `FIREBASE_SERVICE_ACCOUNT_PROD` | JSON key for Prod |
| `ENV_FILE_DEV` | `.env.development` content |
| `ENV_FILE_UAT` | `.env.uat` content |
| `ENV_FILE_PROD` | `.env.production` content |

## 4. Troubleshooting
**"Missing Permissions" in CI/CD?**
* Go to Google Cloud IAM.
* Find the Service Account (e.g., `github-actions@...`).
* Grant it the **"Editor"** role (or specifically Firestore Admin + Service Usage Admin).

**"Staff User Not Seeing Data"?**
* Ensure you aren't using `auth.token.orgId`.
* Check Firestore `users/{uid}` to ensure `orgId` matches the data.
INNER_EOF

# ==========================================
# 4. UPDATE INITIALIZATION PROMPT
# ==========================================
echo "📝 Updating docs/PROMPT_INITIALIZATION.md..."
cat << 'INNER_EOF' > docs/PROMPT_INITIALIZATION.md
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
INNER_EOF

echo "✅ Documentation Suite Updated Successfully."

```
---

## FILE: scripts/upgrade_pipelines.sh
```sh
#!/bin/bash

echo "🚀 Upgrading CI/CD Pipelines to include Firestore..."

# 1. Update DEV Pipeline
cat << 'INNER_EOF' > .github/workflows/deploy-dev.yml
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
INNER_EOF

# 2. Update UAT Pipeline
cat << 'INNER_EOF' > .github/workflows/deploy-uat.yml
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
INNER_EOF

# 3. Update PROD Pipeline
cat << 'INNER_EOF' > .github/workflows/deploy-prod.yml
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
INNER_EOF

echo "✅ Pipelines Upgraded to Full-Stack Deployment."

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

