#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE INSTALLER
# Feature: Schedule View (Calendar Module)
# Approach: Mobile-First Agenda (Horizontal Strip + List)
# ====================================================

echo "🚀 Installing Schedule View Feature..."

# 1. Create Directories
mkdir -p src/components/schedule
mkdir -p src/hooks

# 2. Create the Specialized Hook (Logic Layer)
# This hook fetches jobs specifically for a date range to handle the Calendar logic
echo "📝 Writing src/hooks/useSchedule.js..."
cat << 'EOF' > src/hooks/useSchedule.js
import { useState, useEffect } from 'react';
import { 
  collection, 
  query, 
  where, 
  onSnapshot, 
  orderBy,
  Timestamp 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useSchedule = (startDate, endDate) => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user || !startDate || !endDate) {
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

      // SECURITY: Filter by orgId AND Date Range
      // Note: This relies on the composite index (orgId + scheduledDate) we already created.
      const q = query(
        collection(db, 'jobs'),
        where('orgId', '==', orgId),
        where('scheduledDate', '>=', Timestamp.fromDate(startDate)),
        where('scheduledDate', '<=', Timestamp.fromDate(endDate)),
        orderBy('scheduledDate', 'asc')
      );

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

      return () => unsubscribe();
    });
  }, [startDate, endDate]); // Refetch when the date range changes

  return { jobs, loading, error };
};
EOF

# 3. Create Components (UI Layer)

echo "📝 Writing src/components/schedule/DateStrip.jsx..."
cat << 'EOF' > src/components/schedule/DateStrip.jsx
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
EOF

echo "📝 Writing src/components/schedule/DailyAgenda.jsx..."
cat << 'EOF' > src/components/schedule/DailyAgenda.jsx
import React from 'react';
import { Clock, MapPin, DollarSign, User, AlertCircle } from 'lucide-react';
import { format } from 'date-fns';

const DailyAgenda = ({ jobs, clients, loading, selectedDate }) => {
  // Helper to join client data
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
          <CalendarIcon className="text-slate-300" size={32} />
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

// Simple Icon component for the empty state
const CalendarIcon = ({ className, size }) => (
  <svg 
    xmlns="http://www.w3.org/2000/svg" 
    width={size} 
    height={size} 
    viewBox="0 0 24 24" 
    fill="none" 
    stroke="currentColor" 
    strokeWidth="2" 
    strokeLinecap="round" 
    strokeLinejoin="round" 
    className={className}
  >
    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
    <line x1="16" y1="2" x2="16" y2="6"></line>
    <line x1="8" y1="2" x2="8" y2="6"></line>
    <line x1="3" y1="10" x2="21" y2="10"></line>
  </svg>
);

export default DailyAgenda;
EOF

# 4. Create the Page Container
echo "📝 Writing src/pages/SchedulePage.jsx..."
cat << 'EOF' > src/pages/SchedulePage.jsx
import React, { useState } from 'react';
import { startOfWeek, endOfWeek, isSameDay } from 'date-fns';
import { useSchedule } from '../hooks/useSchedule';
import { useClients } from '../hooks/useClients';
import DateStrip from '../components/schedule/DateStrip';
import DailyAgenda from '../components/schedule/DailyAgenda';

const SchedulePage = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());

  // Calculate the Start and End of the current week for the query
  // We fetch a whole week's worth of data so switching days is instant
  const weekStart = startOfWeek(selectedDate, { weekStartsOn: 1 }); // Monday
  const weekEnd = endOfWeek(selectedDate, { weekStartsOn: 1 });     // Sunday

  // Custom hooks
  const { jobs, loading: scheduleLoading, error } = useSchedule(weekStart, weekEnd);
  const { clients, loading: clientsLoading } = useClients();

  // Filter the fetched week's jobs to show only the selected day
  const todaysJobs = jobs.filter(job => 
    job.scheduledDate && isSameDay(job.scheduledDate, selectedDate)
  );

  return (
    <div className="bg-gray-50 min-h-full pb-20">
      {/* 1. Date Navigation */}
      <div className="sticky top-0 z-10">
        <DateStrip 
          selectedDate={selectedDate} 
          onSelectDate={setSelectedDate} 
        />
      </div>

      {/* 2. Main Agenda View */}
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
        />
      </main>
    </div>
  );
};

export default SchedulePage;
EOF

# 5. Update Routing
echo "📝 Updating App.jsx route..."
cat << 'EOF' > src/App.jsx
import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import AppLayout from './components/layout/AppLayout';
import AuthGuard from './components/layout/AuthGuard';
import LoginPage from './features/auth/LoginPage';
import ClientsPage from './pages/ClientsPage';
import JobsPage from './pages/JobsPage';
import SchedulePage from './pages/SchedulePage';
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
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
EOF

echo "✅ SUCCESS! Schedule View installed."