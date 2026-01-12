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
