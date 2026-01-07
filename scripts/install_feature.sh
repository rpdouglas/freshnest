#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE INSTALLER
# Feature: Job Assignment (Staff Allocation)
# Approach: Simple Dropdown + Array Storage
# ====================================================

echo "🚀 Installing Job Assignment Feature..."

# 1. Create the Staff Hook
# We need a dedicated way to fetch 'assignable' users (Admin + Staff)
echo "📝 Writing src/hooks/useStaff.js..."
cat << 'EOF' > src/hooks/useStaff.js
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
EOF

# 2. Update useJobs to handle 'assignedTo'
echo "📝 Updating src/hooks/useJobs.js..."
cat << 'EOF' > src/hooks/useJobs.js
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
        const orgId = userDoc.exists() ? userDoc.data().orgId : null;
        setCurrentOrgId(orgId);

        if (!orgId) {
          setError("Organization ID missing.");
          setLoading(false);
          return;
        }

        const q = query(
          collection(db, 'jobs'),
          where('orgId', '==', orgId),
          orderBy('scheduledDate', 'asc')
        );

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

    // Prepare Assignment Array
    // Even though UI is single select, we store as array for future proofing
    const assignedTo = jobData.assignedStaffId ? [jobData.assignedStaffId] : [];

    await addDoc(collection(db, 'jobs'), {
      clientId: jobData.clientId,
      serviceType: jobData.serviceType,
      price: Number(jobData.price),
      notes: jobData.notes,
      assignedTo: assignedTo, // ✨ NEW FIELD
      status: 'scheduled',
      scheduledDate: Timestamp.fromDate(timestampDate),
      orgId: currentOrgId, 
      createdAt: serverTimestamp(),
      createdBy: auth.currentUser.uid
    });
  };

  return { jobs, loading, error, addJob };
};
EOF

# 3. Update UI Components

echo "📝 Updating src/components/jobs/JobFormModal.jsx..."
cat << 'EOF' > src/components/jobs/JobFormModal.jsx
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
EOF

echo "📝 Updating src/components/jobs/JobTableDesktop.jsx..."
cat << 'EOF' > src/components/jobs/JobTableDesktop.jsx
import React from 'react';
import { MoreHorizontal, Calendar, Clock, MapPin, User } from 'lucide-react';
import { format } from 'date-fns';

const JobTableDesktop = ({ jobs, clients, staff }) => {
  const getClient = (id) => clients.find(c => c.id === id) || {};
  
  const getAssignedStaffName = (staffIds) => {
    if (!staffIds || staffIds.length === 0) return 'Unassigned';
    const member = staff.find(s => s.id === staffIds[0]);
    return member ? (member.fullName || member.email) : 'Unknown';
  };

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
            <th className="px-6 py-4">Assigned Staff</th>
            <th className="px-6 py-4">Service</th>
            <th className="px-6 py-4">Status</th>
            <th className="px-6 py-4 text-right">Actions</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100">
          {jobs.map((job) => {
            const client = getClient(job.clientId);
            const assignedName = getAssignedStaffName(job.assignedTo);
            const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;

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
                  <div className={`flex items-center gap-2 text-sm ${isUnassigned ? 'text-slate-400 italic' : 'text-slate-700'}`}>
                    <User size={14} />
                    {assignedName}
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

echo "📝 Updating src/components/jobs/JobListMobile.jsx..."
cat << 'EOF' > src/components/jobs/JobListMobile.jsx
import React from 'react';
import { Calendar, Clock, DollarSign, MapPin, User } from 'lucide-react';
import { format } from 'date-fns';

const JobListMobile = ({ jobs, clients, staff }) => {
  const getClientName = (id) => clients.find(c => c.id === id)?.name || 'Unknown Client';
  const getClientAddress = (id) => clients.find(c => c.id === id)?.address;
  
  const getAssignedStaffName = (staffIds) => {
    if (!staffIds || staffIds.length === 0) return 'Unassigned';
    const member = staff.find(s => s.id === staffIds[0]);
    return member ? (member.fullName || member.email) : 'Unknown';
  };

  if (jobs.length === 0) {
    return (
      <div className="text-center py-10 bg-white rounded-xl border border-gray-100">
        <p className="text-gray-500">No upcoming jobs.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:hidden">
      {jobs.map((job) => {
        const assignedName = getAssignedStaffName(job.assignedTo);
        const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;

        return (
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
              
              {/* STAFF ASSIGNMENT ROW */}
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
               {job.price > 0 && (
                 <div className="flex items-center gap-2 text-slate-500">
                   <DollarSign size={16} className="text-slate-400 shrink-0" />
                   <span>${job.price}</span>
                 </div>
              )}
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default JobListMobile;
EOF

# 4. Orchestrate in JobsPage
echo "📝 Updating src/pages/JobsPage.jsx..."
cat << 'EOF' > src/pages/JobsPage.jsx
import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useJobs } from '../hooks/useJobs';
import { useClients } from '../hooks/useClients';
import { useStaff } from '../hooks/useStaff'; // ✨ NEW
import JobListMobile from '../components/jobs/JobListMobile';
import JobTableDesktop from '../components/jobs/JobTableDesktop';
import JobFormModal from '../components/jobs/JobFormModal';

const JobsPage = () => {
  const { jobs, loading: jobsLoading, error: jobsError, addJob } = useJobs();
  const { clients, loading: clientsLoading } = useClients(); 
  const { staff, loading: staffLoading } = useStaff(); // Fetch staff

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const loading = jobsLoading || clientsLoading || staffLoading;

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
          <JobListMobile jobs={filteredJobs} clients={clients} staff={staff} />
          <JobTableDesktop jobs={filteredJobs} clients={clients} staff={staff} />
        </>
      )}

      {/* Modals */}
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
EOF

echo "✅ SUCCESS! Job Assignment Feature installed."