#!/bin/bash

# ====================================================
# FRESH NEST: INVOICING INSTALLER
# Feature: PDF Generation & Tracking
# Approach: Client-Side Renderer (@react-pdf/renderer)
# ====================================================

echo "🚀 Installing Invoicing Feature..."

# 0. Install Dependencies
echo "📦 Installing @react-pdf/renderer..."
npm install @react-pdf/renderer

# 1. Update useJobs Hook (Add Invoicing Logic)
# We add a function to "seal" the invoice in the database
echo "📝 Updating src/hooks/useJobs.js..."
cat << 'INNER_EOF' > src/hooks/useJobs.js
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
INNER_EOF

# 2. Create the PDF Document Layout
# Defines the visual structure of the Invoice
echo "📝 Creating src/components/invoicing/InvoiceDocument.jsx..."
mkdir -p src/components/invoicing
cat << 'INNER_EOF' > src/components/invoicing/InvoiceDocument.jsx
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
INNER_EOF

# 3. Create Invoice Preview Modal
# Allows admin to see the PDF before downloading/marking as sent
echo "📝 Creating src/components/invoicing/InvoiceModal.jsx..."
cat << 'INNER_EOF' > src/components/invoicing/InvoiceModal.jsx
import React, { useEffect, useState } from 'react';
import { X, CheckCircle, Download, FileText } from 'lucide-react';
import { PDFViewer, PDFDownloadLink } from '@react-pdf/renderer';
import InvoiceDocument from './InvoiceDocument';

const InvoiceModal = ({ isOpen, onClose, job, client, onMarkInvoiced }) => {
  const [isClientReady, setIsClientReady] = useState(false);

  // React-PDF requires client-side mounting
  useEffect(() => {
    setIsClientReady(true);
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

        {/* PDF Viewer (Main Content) */}
        <div className="flex-1 bg-gray-100 p-4">
          {isClientReady ? (
            <PDFViewer width="100%" height="100%" className="rounded-lg border border-gray-200 shadow-inner">
              <InvoiceDocument job={job} client={client} />
            </PDFViewer>
          ) : (
            <div className="flex items-center justify-center h-full text-slate-400">
              Loading PDF Engine...
            </div>
          )}
        </div>

        {/* Footer Controls */}
        <div className="px-6 py-4 border-t border-gray-100 bg-white flex justify-between items-center">
          <div className="text-sm text-slate-500">
            Status: {job.invoicedAt ? (
              <span className="text-green-600 font-medium flex items-center gap-1">
                <CheckCircle size={14} /> Invoiced ({job.invoiceNumber})
              </span>
            ) : (
              <span className="text-amber-600 font-medium">Draft (Not Sent)</span>
            )}
          </div>

          <div className="flex gap-3">
            {/* Mark as Invoiced Button */}
            {!job.invoicedAt && (
              <button
                onClick={() => onMarkInvoiced(job.id)}
                className="px-4 py-2 text-slate-700 bg-gray-100 hover:bg-gray-200 rounded-lg font-medium flex items-center gap-2 transition-colors"
              >
                <CheckCircle size={18} />
                Mark as Invoiced
              </button>
            )}

            {/* Download Button (Native PDF Link) */}
            {isClientReady && (
              <PDFDownloadLink
                document={<InvoiceDocument job={job} client={client} />}
                fileName={`Invoice_${client.name.replace(/\s+/g, '_')}.pdf`}
                className="px-6 py-2 bg-brand-600 text-white rounded-lg font-bold hover:bg-brand-700 flex items-center gap-2 transition-colors shadow-sm"
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
INNER_EOF

# 4. Update JobRowDesktop (Add "Generate Invoice" Action)
echo "📝 Updating src/components/jobs/JobRowDesktop.jsx..."
cat << 'INNER_EOF' > src/components/jobs/JobRowDesktop.jsx
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
INNER_EOF

# 5. Update JobsPage (Wiring the Modal)
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

const JobsPage = () => {
  const { jobs, loading: jobsLoading, error: jobsError, addJob, updateJob, deleteJob, markAsInvoiced, role: userRole } = useJobs();
  const { clients, loading: clientsLoading } = useClients(); 
  const { staff, loading: staffLoading } = useStaff();

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingJob, setEditingJob] = useState(null);
  
  // Invoice State
  const [invoicingJob, setInvoicingJob] = useState(null);
  
  const [searchTerm, setSearchTerm] = useState('');

  const loading = jobsLoading || clientsLoading || staffLoading;

  const filteredJobs = jobs.filter(job => {
    const clientName = clients.find(c => c.id === job.clientId)?.name?.toLowerCase() || '';
    return clientName.includes(searchTerm.toLowerCase());
  });

  // --- Handlers ---

  const handleCreateOpen = () => {
    setEditingJob(null);
    setIsModalOpen(true);
  };

  const handleEditOpen = (job) => {
    setEditingJob(job);
    setIsModalOpen(true);
  };

  const handleInvoiceOpen = (job) => {
    setInvoicingJob(job);
  };

  const handleSave = async (formData) => {
    if (editingJob) {
      await updateJob(editingJob.id, formData);
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
    // Note: We don't close the modal automatically so they can download the now-finalized invoice
  };

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
          {/* Only Admin can add jobs */}
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
          <JobListMobile 
            jobs={filteredJobs} 
            clients={clients} 
            staff={staff} 
            userRole={userRole} 
            onEdit={handleEditOpen} 
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

      {/* Modals */}
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
        onClose={() => setInvoicingJob(null)}
        job={invoicingJob}
        client={invoicingJob ? clients.find(c => c.id === invoicingJob.clientId) : null}
        onMarkInvoiced={handleMarkInvoiced}
      />
    </div>
  );
};

export default JobsPage;
INNER_EOF

# 6. Update JobTableDesktop to pass onInvoice
echo "📝 Updating src/components/jobs/JobTableDesktop.jsx..."
cat << 'INNER_EOF' > src/components/jobs/JobTableDesktop.jsx
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
INNER_EOF

echo "✅ SUCCESS! Invoicing features installed."
