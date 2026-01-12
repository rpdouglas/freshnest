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
