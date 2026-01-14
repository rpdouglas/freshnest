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
