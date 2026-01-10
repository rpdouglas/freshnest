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
