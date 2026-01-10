import React, { useState, useEffect, useRef } from 'react';
import { MoreHorizontal, Calendar, Clock, MapPin, User, Edit, Trash2 } from 'lucide-react';
import { format } from 'date-fns';

const JobTableDesktop = ({ jobs, clients, staff, userRole }) => {
  const [activeMenuJobId, setActiveMenuJobId] = useState(null);
  const menuRef = useRef(null);

  const getClient = (id) => clients.find(c => c.id === id) || {};
  
  const getAssignedStaffName = (staffIds) => {
    if (!staffIds || staffIds.length === 0) return 'Unassigned';
    const member = staff.find(s => s.id === staffIds[0]);
    return member ? (member.fullName || member.email) : 'Unknown';
  };

  // Close menu when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (menuRef.current && !menuRef.current.contains(event.target)) {
        setActiveMenuJobId(null);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const handleAction = (action, job) => {
    setActiveMenuJobId(null); // Close menu
    if (action === 'edit') {
      alert(`Edit Job functionality coming in next module!\nJob ID: ${job.id}`);
    } else if (action === 'delete') {
      if(confirm("Are you sure you want to delete this job? (Logic coming soon)")) {
        console.log("Delete job", job.id);
      }
    }
  };

  if (jobs.length === 0) {
    return (
      <div className="hidden md:block bg-white p-12 text-center rounded-xl border border-gray-200">
        <p className="text-gray-500">No jobs found.</p>
      </div>
    );
  }

  return (
    // Changed overflow-hidden to overflow-visible so the dropdown isn't clipped
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
          {jobs.map((job) => {
            const client = getClient(job.clientId);
            const assignedName = getAssignedStaffName(job.assignedTo);
            const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;
            const isMenuOpen = activeMenuJobId === job.id;

            return (
              <tr key={job.id} className="hover:bg-gray-50 transition-colors relative">
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
                
                {/* ACTION COLUMN */}
                <td className="px-6 py-4 text-right relative">
                  <button 
                    onClick={(e) => {
                      e.stopPropagation();
                      setActiveMenuJobId(isMenuOpen ? null : job.id);
                    }}
                    className={`p-2 rounded-full transition-colors ${isMenuOpen ? 'bg-brand-50 text-brand-600' : 'text-slate-400 hover:text-brand-600 hover:bg-gray-100'}`}
                  >
                    <MoreHorizontal size={20} />
                  </button>

                  {/* Dropdown Menu */}
                  {isMenuOpen && (
                    <div 
                      ref={menuRef}
                      className="absolute right-8 top-8 w-40 bg-white rounded-lg shadow-xl border border-gray-100 z-50 overflow-hidden text-left animate-in fade-in zoom-in duration-200"
                    >
                      <button 
                        onClick={() => handleAction('edit', job)}
                        className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors"
                      >
                        <Edit size={16} className="text-slate-400" /> Edit Job
                      </button>
                      
                      {userRole === 'admin' && (
                        <button 
                          onClick={() => handleAction('delete', job)}
                          className="w-full px-4 py-3 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors border-t border-gray-50"
                        >
                          <Trash2 size={16} /> Delete
                        </button>
                      )}
                    </div>
                  )}
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
