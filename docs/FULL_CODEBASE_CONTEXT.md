# FRESH NEST: CODEBASE DUMP
**Date:** Mon Jan  5 22:48:07 EST 2026
**Description:** Complete codebase context excluding modules and secrets.

## FILE: package.json
```json
{
  "name": "fresh-nest",
  "private": true,
  "version": "0.0.0",
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

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
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

## FILE: postcss.config.js
```js
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
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

## FILE: index.html
```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>fresh-nest</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>

```
---

## FILE: .gitignore
```gitignore
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
pnpm-debug.log*
lerna-debug.log*

# Dependencies
node_modules
dist
dist-ssr
*.local

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs
*.njsproj
*.sln
*.sw?

# Firebase
.firebase/
firebase-debug.log
firestore-debug.log
ui-debug.log

# SECURITY: Environment Variables & Keys
# NEVER COMMIT THESE FILES
.env
.env.development
.env.uat
.env.production
.env.local

# SECURITY: Admin SDK Keys
scripts/service-account.json
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

## FILE: src/components/jobs/JobFormModal.jsx
```jsx
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

```
---

## FILE: src/components/jobs/JobListMobile.jsx
```jsx
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

```
---

## FILE: src/components/jobs/JobTableDesktop.jsx
```jsx
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

```
---

## FILE: src/hooks/useJobs.js
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

```
---

## FILE: docs/CONTEXT_DUMP.md
```md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore, Functions) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- User has `orgId` in Custom Claims.
- "fresh-nest-dev" Firestore is active.
- `AppLayout` is generic.

## Schema (Implemented)
- **organizations/{orgId}**: { name, plan, settings }
- **users/{userId}**: { email, orgId, role, fullName }

## Rules for AI
1. ALL code must be provided as COMPLETE FILES.
2. Use `lucide-react` for icons.
3. Tailwind Colors: `bg-brand-500` (Primary), `bg-slate-800` (Sidebar).
4. Security: All Firestore queries MUST filter by `where("orgId", "==", user.orgId)`.
```
---

## FILE: docs/PROJECT_STATUS.md
```md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 1 - Foundation & Core Data
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Project Setup:** Vite + React + Tailwind CSS configured.
* **Authentication:** Firebase Login/Signup with Email & Password.
* **Multi-Tenancy:** Custom Claims (`orgId`) & Provisioning Script.
* **Client Management:**
    * `useClients` hook, Mobile Cards, Desktop Table.
    * Security Rules & Indexes deployed.
* **Job Management:**
    * `useJobs` hook with Relational Data (`clientId`).
    * UI: Jobs List with "Join" logic (Client Name lookup).
    * "Add Job" Modal with Client Dropdown.
    * Security Rules & Composite Index (`orgId` + `scheduledDate`) deployed.

## 🚧 In Progress / Next Up
* [ ] **Schedule View:** A dedicated Calendar view for upcoming jobs.
* [ ] **Staff Management:** Adding employees to the Org.

## 🗄️ Database Schema (Firestore)

### `organizations/{orgId}`
* `name`, `plan`, `settings`

### `users/{userId}`
* `email`, `fullName`, `orgId`, `role`

### `clients/{clientId}`
* `orgId`, `name`, `email`, `phone`, `address`

### `jobs/{jobId}` (✨ NEW)
* `orgId`: String
* `clientId`: String (Ref to Client)
* `scheduledDate`: Timestamp
* `status`: String ('scheduled', 'completed')
* `serviceType`: String
* `price`: Number

## 📂 Key Files Created
* `src/hooks/useClients.js`, `src/hooks/useJobs.js`
* `src/pages/ClientsPage.jsx`, `src/pages/JobsPage.jsx`
* `firestore.rules`

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
1.  **React:** Use functional components and proper Hook dependency arrays. Isolate logic in Custom Hooks.
2.  **Tailwind:** Use mobile-first classes (`block md:flex`). Avoid arbitrary values (e.g., `w-[350px]`) — use the theme.
3.  **Firebase:**
    * **Security:** ALL `addDoc` calls must include `orgId`. ALL `onSnapshot` queries must filter by `orgId`.
    * **Timestamps:** Use `serverTimestamp()` for `createdAt` fields.
4.  **Code Quality:** No "placeholder" code. Complete files only.

**Output Requirements:**

1.  **The "One-Shot" Installer:**
    * Provide a single bash script named `scripts/install_feature.sh`.
    * This script must use `cat << 'EOF' > path/to/file` to safely create the directories and write the file contents.
    * *Note:* Ensure you escape special characters in the bash script correctly so the React code generates properly.

2.  **QA Checklist (Manual Testing):**
    * Provide a bulleted list of 3-5 manual tests I should perform to verify this specific feature works.
    * Include at least one "Security/Isolation" test case (e.g., verify Org A cannot see Org B's data).

3.  **Git Documentation:**
    * At the very end, provide a **Git Commit Comment Block**.
    * Format:
        * **Branch:** (Verify we are on `feature/...`)
        * **Message:** `feat: [summary]`
        * **Description:** Bullet points of changes.

*Please generate the installation script, test checklist, and git docs now.*

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

**Core Requirements:**
1.  **Data:** [Describe data needs, e.g., "Store Client details linked to orgId"]
2.  **UI:** [Describe UI needs, e.g., "Mobile cards, Desktop table"]
3.  **Logic:** [Describe logic, e.g., "Real-time updates, security filters"]

**🛑 STOP & THINK: Architectural Options**
Before writing any code, please propose **3 Distinct Approaches** to implementing this feature:

1.  **The "MVP" Approach:** Fastest to build, simplest code, uses basic HTML/Tailwind. Good for testing value quickly.
2.  **The " robust & Scalable" Approach (Recommended):** Best balance. Uses proper abstractions (custom hooks), error handling, and reusable components. Future-proofs for growth.
3.  **The "Over-Engineered" Approach:** Uses advanced libraries (e.g., React Query, Virtualized Tables) or complex patterns. best for massive scale but high initial complexity.

**Your Task:**
1.  Briefly describe these 3 options (Pros/Cons of each).
2.  Recommend which one fits our current "Mobile-First SaaS" stage best.
3.  **WAIT** for my confirmation on which approach to take before generating the code.


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
# 🛡️ Source Control & Development Protocol

**Version:** 1.0
**Last Updated:** 2026-01-05

## 1. The Golden Rules
1.  **NEVER commit directly to `main`.**
    * The `main` branch is "Production Ready." If it breaks, the app is broken.
2.  **NEVER commit API Keys or Secrets.**
    * Ensure `.env` files and `service-account.json` are always in `.gitignore`.
3.  **One Feature = One Branch.**
    * Do not mix "Fixing the CSS" with "Building the Database" in the same branch.

## 2. Branching Strategy

| Branch Prefix | Usage | Example |
| :--- | :--- | :--- |
| `main` | Production code only. Locked. | `main` |
| `feature/...` | New capabilities. | `feature/client-list` |
| `fix/...` | Bug repairs. | `fix/login-error` |
| `chore/...` | Maintenance (deps, docs). | `chore/update-readme` |

## 3. The Workflow Cycle

### Step 1: Sync & Start
Always pull the latest changes before starting.
```bash
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

### Step 2: Develop & Commit
Commit often locally. Use descriptive messages.
```bash
git add .
git commit -m "feat: implemented client table view"
```

### Step 3: Push & Merge
1.  Push your branch to GitHub.
    ```bash
    git push origin feature/your-feature-name
    ```
2.  Go to GitHub and open a **Pull Request (PR)**.
3.  Review the code (Self-Review).
4.  Merge into `main`.

## 4. Commit Message Convention
Follow this format to keep the history readable:
* **`feat:`** New features (e.g., `feat: added login page`)
* **`fix:`** Bug fixes (e.g., `fix: resolved css crash`)
* **`docs:`** Documentation only (e.g., `docs: added sop`)
* **`style:`** Formatting, missing semi-colons, etc.
* **`refactor:`** Refactoring code without changing logic.

## 5. Emergency Recovery
If you accidentally commit to `main` or commit a secret:
1.  **STOP.** Do not push.
2.  Reset the commit (keep changes): `git reset --soft HEAD~1`
3.  Fix the issue (remove the secret or switch branches).

```
---

## FILE: scripts/generate-context.sh
```sh
#!/bin/bash

# ==========================================
# 🚀 FRESH NEST: DEEP CONTEXT GENERATOR
# ==========================================
# Generates a single markdown file containing the full source code
# of the application for AI analysis.

OUTPUT_FILE="docs/FULL_CODEBASE_CONTEXT.md"

# 1. Initialize the file
echo "🔄 Generating Context Dump..."
echo "# FRESH NEST: CODEBASE DUMP" > "$OUTPUT_FILE"
echo "**Date:** $(date)" >> "$OUTPUT_FILE"
echo "**Description:** Complete codebase context excluding modules and secrets." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 2. Helper Function to write file content safely
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

# 3. ROOT CONFIGURATION FILES (Explicit Allow-List)
# We only pick specific files from root to avoid scanning node_modules
echo "⚙️ Ingesting Root Configs..."
ingest_file "package.json"
ingest_file "vite.config.js"
ingest_file "tailwind.config.js"
ingest_file "postcss.config.js"
ingest_file "firebase.json"
ingest_file ".firebaserc"
ingest_file "index.html"
ingest_file ".gitignore"

# 4. SOURCE CODE (Recursive)
echo "💻 Ingesting src/ directory..."
# Find all code files, exclude standard noise
find src -type f \
    -not -path "*/.*" \
    \( -name "*.js" -o -name "*.jsx" -o -name "*.css" -o -name "*.json" \) \
    | sort | while read file; do ingest_file "$file"; done

# 5. DOCUMENTATION (Recursive)
echo "📄 Ingesting docs/ directory..."
find docs -type f -name "*.md" -not -name "FULL_CODEBASE_CONTEXT.md" | sort | while read file; do ingest_file "$file"; done

# 6. SCRIPTS (Recursive)
echo "Vg Ingesting scripts/ directory..."
find scripts -type f \( -name "*.js" -o -name "*.cjs" -o -name "*.sh" \) | sort | while read file; do ingest_file "$file"; done

echo "✅ SUCCESS! Context generated at: $OUTPUT_FILE"
echo "👉 Copy the contents of $OUTPUT_FILE and paste it into your AI chat."
```
---

## FILE: scripts/init-org.cjs
```cjs
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

