#!/bin/bash

# ====================================================
# FRESH NEST: GOOGLE MAPS INSTALLER
# Feature: Geocoding & Map Visualization
# Approach: Frontend Geocoding + Google Maps JS API
# ====================================================

echo "🚀 Installing Google Maps & Geocoding Features..."

# 0. Install Dependencies
# We use the official react wrapper for Google Maps
echo "📦 Installing @react-google-maps/api..."
npm install @react-google-maps/api

# 1. Create Maps Utility Library
# Handles the direct API calls to Google
echo "📝 Creating src/lib/maps.js..."
mkdir -p src/lib
cat << 'INNER_EOF' > src/lib/maps.js
// Utility to handle Google Maps Geocoding
const API_KEY = import.meta.env.VITE_GOOGLE_MAPS_API_KEY;

export const geocodeAddress = async (address) => {
  if (!address || !API_KEY) return null;

  try {
    const url = \`https://maps.googleapis.com/maps/api/geocode/json?address=\${encodeURIComponent(address)}&key=\${API_KEY}\`;
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
INNER_EOF

# 2. Create Map Component
# Renders the actual Google Map with markers
echo "📝 Creating src/components/map/MapComponent.jsx..."
mkdir -p src/components/map
cat << 'INNER_EOF' > src/components/map/MapComponent.jsx
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
INNER_EOF

# 3. Update ClientFormModal to Geocode on Save
echo "📝 Updating src/components/clients/ClientFormModal.jsx..."
cat << 'INNER_EOF' > src/components/clients/ClientFormModal.jsx
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
INNER_EOF

# 4. Update SchedulePage to Include Map View
echo "📝 Updating src/pages/SchedulePage.jsx..."
cat << 'INNER_EOF' > src/pages/SchedulePage.jsx
import React, { useState } from 'react';
import { startOfWeek, endOfWeek, isSameDay } from 'date-fns';
import { Map, List } from 'lucide-react'; // Icons for toggle
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
              className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-sm font-medium transition-colors \${
                viewMode === 'list' ? 'bg-brand-50 text-brand-700' : 'text-slate-500 hover:text-slate-700'
              }`}
            >
              <List size={16} /> List
            </button>
            <button
              onClick={() => setViewMode('map')}
              className={`flex items-center gap-2 px-4 py-1.5 rounded-md text-sm font-medium transition-colors \${
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
INNER_EOF

echo "✅ SUCCESS! Maps & Geocoding installed."
echo "👉 Make sure you have VITE_GOOGLE_MAPS_API_KEY in your .env file!"
