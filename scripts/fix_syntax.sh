#!/bin/bash

echo "🔧 Repairing Syntax Errors in Maps Feature..."

# 1. Fix src/lib/maps.js
# Removing extra backslashes from template literals
echo "📝 Repairing src/lib/maps.js..."
cat << 'INNER_JS' > src/lib/maps.js
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
INNER_JS

# 2. Fix src/pages/SchedulePage.jsx
# Removing extra backslashes from className template literals
echo "📝 Repairing src/pages/SchedulePage.jsx..."
cat << 'INNER_JSX' > src/pages/SchedulePage.jsx
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
INNER_JSX

echo "✅ Syntax Repairs Complete."
