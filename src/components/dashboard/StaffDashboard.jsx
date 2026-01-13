import React from 'react';
import { Calendar, MapPin, User } from 'lucide-react';
import { format } from 'date-fns';

const StaffDashboard = ({ jobs, clients }) => {
  
  // Helper to find name from ID
  const getClientName = (id) => {
    const client = clients.find(c => c.id === id);
    return client ? client.name : 'Unknown Client';
  };

  return (
    <div className="space-y-6">
      <div className="bg-brand-600 text-white p-6 rounded-2xl shadow-lg">
        <h1 className="text-2xl font-bold">Welcome Back!</h1>
        <p className="text-brand-100 opacity-90">Here are your assigned jobs.</p>
      </div>

      <div className="space-y-4">
        <h2 className="font-bold text-slate-800 text-lg">Upcoming Jobs</h2>
        {jobs.length === 0 ? (
          <div className="bg-white p-8 text-center rounded-xl border border-gray-100 text-slate-500">
            No jobs assigned right now.
          </div>
        ) : (
          jobs.map(job => (
            <div key={job.id} className="bg-white p-4 rounded-xl shadow-sm border border-gray-100 flex items-start gap-4">
              <div className="bg-brand-50 p-3 rounded-lg text-brand-600 shrink-0">
                <Calendar size={20} />
              </div>
              <div>
                <div className="font-bold text-slate-900">
                  {job.scheduledDate ? format(job.scheduledDate, 'MMM d, h:mm a') : 'TBD'}
                </div>
                
                {/* ✨ Fixed Client Name Display */}
                <div className="flex items-center gap-1 text-sm text-slate-600 mt-1">
                  <User size={14} />
                  {getClientName(job.clientId)}
                </div>

                <div className="mt-2">
                  <span className={`text-[10px] uppercase font-bold px-2 py-1 rounded-full ${
                    job.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-blue-50 text-blue-700'
                  }`}>
                    {job.status}
                  </span>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default StaffDashboard;
