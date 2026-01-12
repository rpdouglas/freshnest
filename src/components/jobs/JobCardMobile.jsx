import React from 'react';
import { Calendar, Clock, DollarSign, MapPin, User, CheckCircle, Play, Loader, Edit } from 'lucide-react';
import { format } from 'date-fns';
import { useJobWorkflow } from '../../hooks/useJobWorkflow';

const JobCardMobile = ({ job, getClientName, getClientAddress, getAssignedStaffName, userRole, onEdit }) => {
  const { startJob, completeJob, canStart, canComplete, loading } = useJobWorkflow(job, userRole);

  const assignedName = getAssignedStaffName(job.assignedTo);
  const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;

  const getStatusColor = (s) => {
    switch(s) {
      case 'completed': return 'bg-green-100 text-green-700';
      case 'in_progress': return 'bg-blue-100 text-blue-700';
      case 'cancelled': return 'bg-red-100 text-red-700';
      default: return 'bg-yellow-100 text-yellow-700';
    }
  };

  return (
    <div className="bg-white p-4 rounded-xl shadow-sm border border-gray-100 relative">
      {/* Admin Edit Button (Top Right Absolute) */}
      {userRole === 'admin' && (
        <button 
          onClick={() => onEdit(job)}
          className="absolute top-4 right-4 p-1.5 bg-gray-50 rounded-full text-slate-400 hover:text-brand-600 hover:bg-brand-50"
        >
          <Edit size={16} />
        </button>
      )}

      <div className="flex justify-between items-start mb-2 pr-8">
        <div>
          <h3 className="font-bold text-slate-800 text-lg">{getClientName(job.clientId)}</h3>
          <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-slate-600 capitalize mt-1">
            {job.serviceType}
          </span>
        </div>
      </div>
      
      {/* Status Badge */}
      <div className="mb-3">
        <span className={`text-xs font-bold px-2 py-1 rounded-full uppercase ${getStatusColor(job.status)}`}>
          {job.status?.replace('_', ' ')}
        </span>
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
        
        {userRole !== 'staff' && job.price > 0 && (
          <div className="flex items-center gap-2 text-slate-500">
            <DollarSign size={16} className="text-slate-400 shrink-0" />
            <span>${job.price}</span>
          </div>
        )}
      </div>

      {/* WORKFLOW BUTTONS */}
      {(canStart || canComplete) && (
        <div className="mt-4 pt-4 border-t border-gray-50 flex gap-2">
          {canStart && (
            <button 
              onClick={startJob}
              disabled={loading}
              className="flex-1 bg-brand-600 text-white py-2 rounded-lg font-bold flex items-center justify-center gap-2 hover:bg-brand-700 active:scale-95 transition-all"
            >
              {loading ? <Loader className="animate-spin" size={18} /> : <Play size={18} />}
              Start Job
            </button>
          )}
          
          {canComplete && (
            <button 
              onClick={completeJob}
              disabled={loading}
              className="flex-1 bg-green-600 text-white py-2 rounded-lg font-bold flex items-center justify-center gap-2 hover:bg-green-700 active:scale-95 transition-all"
            >
              {loading ? <Loader className="animate-spin" size={18} /> : <CheckCircle size={18} />}
              Complete Job
            </button>
          )}
        </div>
      )}
    </div>
  );
};

export default JobCardMobile;
