import React from 'react';
import { Calendar, Clock, DollarSign, MapPin } from 'lucide-react';
import { format } from 'date-fns';

const JobListMobile = ({ jobs, clients }) => {
  // Helper to find client name
  const getClientName = (id) => clients.find(c => c.id === id)?.name || 'Unknown Client';
  const getClientAddress = (id) => clients.find(c => c.id === id)?.address;

  if (jobs.length === 0) {
    return (
      <div className="text-center py-10 bg-white rounded-xl border border-gray-100">
        <p className="text-gray-500">No upcoming jobs.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:hidden">
      {jobs.map((job) => (
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
      ))}
    </div>
  );
};

export default JobListMobile;
