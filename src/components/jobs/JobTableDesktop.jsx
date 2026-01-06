import React from 'react';
import { MoreHorizontal, Calendar, Clock, MapPin } from 'lucide-react';
import { format } from 'date-fns';

const JobTableDesktop = ({ jobs, clients }) => {
  const getClient = (id) => clients.find(c => c.id === id) || {};

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
            <th className="px-6 py-4">Service</th>
            <th className="px-6 py-4">Status</th>
            <th className="px-6 py-4 text-right">Actions</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100">
          {jobs.map((job) => {
            const client = getClient(job.clientId);
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
