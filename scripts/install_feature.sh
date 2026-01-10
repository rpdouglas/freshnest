#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE INSTALLER
# Feature: Worker View (RBAC)
# Approach: Smart Hooks (Role-Aware Querying)
# ====================================================

echo "🚀 Installing Worker View Feature..."

# 1. Update useJobs Hook (The Logic Core)
# Now fetches 'role' from profile and filters query if role == 'staff'
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
EOF

# 2. Update useSchedule Hook
# Matches logic from useJobs to secure the calendar view as well
echo "📝 Updating src/hooks/useSchedule.js..."
cat << 'EOF' > src/hooks/useSchedule.js
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
EOF

# 3. Update JobsPage to pass role down
echo "📝 Updating src/pages/JobsPage.jsx..."
cat << 'EOF' > src/pages/JobsPage.jsx
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
EOF

# 4. Update Desktop Table (Hide Price)
echo "📝 Updating src/components/jobs/JobTableDesktop.jsx..."
cat << 'EOF' > src/components/jobs/JobTableDesktop.jsx
import React from 'react';
import { MoreHorizontal, Calendar, Clock, MapPin, User } from 'lucide-react';
import { format } from 'date-fns';

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
    <div className="hidden md:block bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <table className="w-full text-left border-collapse">
        <thead>
          <tr className="bg-gray-50 border-b border-gray-200 text-xs uppercase text-gray-500 font-semibold">
            <th className="px-6 py-4">Scheduled Date</th>
            <th className="px-6 py-4">Client</th>
            <th className="px-6 py-4">Assigned Staff</th>
            <th className="px-6 py-4">Service</th>
            <th className="px-6 py-4">Status</th>
            {/* Hide Actions for Staff? Maybe they need to complete jobs later. Keeping for now. */}
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
                  {/* RBAC: Hide Price if Staff */}
                  {userRole !== 'staff' && job.price > 0 && (
                    <div className="text-xs text-slate-400">${job.price}</div>
                  )}
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

# 5. Update Mobile List (Hide Price)
echo "📝 Updating src/components/jobs/JobListMobile.jsx..."
cat << 'EOF' > src/components/jobs/JobListMobile.jsx
import React from 'react';
import { Calendar, Clock, DollarSign, MapPin, User } from 'lucide-react';
import { format } from 'date-fns';

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
      <div className="text-center py-10 bg-white rounded-xl border border-gray-100">
        <p className="text-gray-500">No jobs found.</p>
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
          </div>
        );
      })}
    </div>
  );
};

export default JobListMobile;
EOF

# 6. Update SchedulePage to pass role
echo "📝 Updating src/pages/SchedulePage.jsx..."
cat << 'EOF' > src/pages/SchedulePage.jsx
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
EOF

# 7. Update DailyAgenda (Hide Price)
echo "📝 Updating src/components/schedule/DailyAgenda.jsx..."
cat << 'EOF' > src/components/schedule/DailyAgenda.jsx
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
EOF

echo "✅ SUCCESS! Worker View (RBAC) installed."