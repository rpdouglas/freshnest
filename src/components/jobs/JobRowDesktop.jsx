import React, { useState, useRef, useEffect } from 'react';
import { MoreHorizontal, Calendar, Clock, MapPin, User, Edit, Trash2, Play, CheckCircle, XCircle, FileText, ShieldAlert, AlertTriangle } from 'lucide-react';
import { format } from 'date-fns';
import { useJobWorkflow } from '../../hooks/useJobWorkflow';

const JobRowDesktop = ({ job, getClient, getAssignedStaffName, userRole, onEdit, onDelete, onInvoice, financialData, conflict }) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const menuRef = useRef(null);
  
  const { startJob, completeJob, cancelJob, canStart, canComplete, canCancel, loading } = useJobWorkflow(job, userRole);

  const client = getClient(job.clientId);
  const assignedName = getAssignedStaffName(job.assignedTo);
  const isUnassigned = !job.assignedTo || job.assignedTo.length === 0;

  // --- SAFETY LOGIC ---
  const isActionable = job.status === 'scheduled';
  const isFinancialBlock = financialData?.isCapReached ? financialData.isCapReached(job.price || 0) : false;
  const isTimeBlock = conflict?.type === 'hard';
  const isTransitWarn = conflict?.type === 'soft';
  const shouldBlock = (isFinancialBlock || isTimeBlock || isTransitWarn) && isActionable && userRole === 'staff';

  // --- VISUAL STYLES ---
  // Dim row if blocked (Mike/Jasmine requirement for "Traffic Control")
  const rowOpacity = shouldBlock ? 'opacity-75 bg-red-50/30' : 'hover:bg-gray-50';

  const getStatusBadge = (s) => {
    const baseClasses = "text-xs font-bold px-2 py-1 rounded-full uppercase";
    switch(s) {
      case 'completed': return <span className={`${baseClasses} bg-green-100 text-green-700`}>{s}</span>;
      case 'in_progress': return <span className={`${baseClasses} bg-blue-100 text-blue-700`}>In Progress</span>;
      case 'cancelled': return <span className={`${baseClasses} bg-red-100 text-red-700`}>{s}</span>;
      default: return <span className={`${baseClasses} bg-yellow-100 text-yellow-700`}>{s}</span>;
    }
  };

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (menuRef.current && !menuRef.current.contains(event.target)) {
        setIsMenuOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const handleAction = async (actionFn) => {
    await actionFn();
    setIsMenuOpen(false);
  };

  return (
    <tr className={`transition-colors relative group ${rowOpacity}`}>
      {/* 1. Date */}
      <td className="px-6 py-4">
        <div className="flex items-center gap-2 font-medium text-slate-900">
          <Calendar size={16} className={isTimeBlock ? 'text-red-500' : 'text-brand-500'} />
          {job.scheduledDate ? format(job.scheduledDate, 'MMM d, yyyy') : 'TBD'}
        </div>
        <div className="flex items-center gap-2 text-xs text-slate-500 mt-1 pl-6">
          <Clock size={12} />
          {job.scheduledDate ? format(job.scheduledDate, 'h:mm a') : ''}
        </div>
      </td>

      {/* 2. Client */}
      <td className="px-6 py-4">
        <div className="font-medium text-slate-900">{client.name || 'Unknown'}</div>
        <div className="flex items-center gap-1 text-xs text-slate-400 mt-0.5">
          <MapPin size={12} />
          <span className="truncate max-w-[150px]">{client.address || 'No address'}</span>
        </div>
      </td>

      {/* 3. Assigned */}
      <td className="px-6 py-4">
        <div className={`flex items-center gap-2 text-sm ${isUnassigned ? 'text-slate-400 italic' : 'text-slate-700'}`}>
          <User size={14} />
          {assignedName}
        </div>
      </td>

      {/* 4. Service & Price */}
      <td className="px-6 py-4">
        <span className="capitalize text-sm text-slate-700">{job.serviceType}</span>
        {job.price > 0 && (
          <div className={`text-xs mt-1 ${isFinancialBlock ? 'text-red-600 font-bold' : 'text-slate-400'}`}>
            ${job.price}
          </div>
        )}
      </td>

      {/* 5. Status & Conflict Icons */}
      <td className="px-6 py-4">
        {getStatusBadge(job.status)}
        {conflict && (
          <div className="flex items-center gap-1 mt-1 text-[10px] font-bold text-red-600">
            {conflict.type === 'hard' ? <XCircle size={12} /> : <AlertTriangle size={12} />}
            {conflict.type.toUpperCase()} CONFLICT
          </div>
        )}
      </td>
      
      {/* 6. ACTIONS */}
      <td className="px-6 py-4 text-right relative">
        <button 
          onClick={(e) => { e.stopPropagation(); setIsMenuOpen(!isMenuOpen); }}
          className={`p-2 rounded-full transition-colors ${isMenuOpen ? 'bg-brand-50 text-brand-600' : 'text-slate-400 hover:text-brand-600 hover:bg-gray-100'}`}
        >
          <MoreHorizontal size={20} />
        </button>

        {isMenuOpen && (
          <div 
            ref={menuRef}
            className="absolute right-8 top-8 w-64 bg-white rounded-lg shadow-xl border border-gray-100 z-50 overflow-hidden text-left animate-in fade-in zoom-in duration-200"
          >
            {/* BLOCKED STATE */}
            {shouldBlock && canStart ? (
              <div className="px-4 py-3 bg-red-50 text-red-700 text-sm border-b border-red-100">
                <div className="flex items-center gap-2 font-bold mb-1">
                  <ShieldAlert size={16} /> Action Blocked
                </div>
                <div className="text-xs opacity-90">
                  {isFinancialBlock && "• Monthly Earning Limit\n"}
                  {conflict && `• ${conflict.message}`}
                </div>
              </div>
            ) : (
              /* ALLOWED STATE */
              <>
                {canStart && (
                  <button onClick={() => handleAction(startJob)} disabled={loading} className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors font-medium">
                    <Play size={16} className="text-green-500" /> Start Job
                  </button>
                )}
                {canComplete && (
                  <button onClick={() => handleAction(completeJob)} disabled={loading} className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors font-medium">
                    <CheckCircle size={16} className="text-blue-500" /> Complete Job
                  </button>
                )}
              </>
            )}

            {/* ADMIN ACTIONS */}
            {userRole === 'admin' && (
              <>
                {job.status === 'completed' && (
                  <button onClick={() => { setIsMenuOpen(false); onInvoice(job); }} className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-purple-50 flex items-center gap-2 transition-colors border-t border-gray-50 font-medium">
                    <FileText size={16} className="text-purple-500" /> {job.invoicedAt ? 'View Invoice' : 'Generate Invoice'}
                  </button>
                )}
                <button onClick={() => { setIsMenuOpen(false); onEdit(job); }} className="w-full px-4 py-3 text-sm text-slate-700 hover:bg-gray-50 flex items-center gap-2 transition-colors">
                  <Edit size={16} className="text-slate-400" /> Edit Details
                </button>
                <div className="border-t border-gray-100">
                  {canCancel && (
                    <button onClick={() => handleAction(cancelJob)} className="w-full px-4 py-3 text-sm text-amber-600 hover:bg-amber-50 flex items-center gap-2 transition-colors">
                      <XCircle size={16} /> Cancel Job
                    </button>
                  )}
                  <button onClick={() => { setIsMenuOpen(false); onDelete(job.id); }} className="w-full px-4 py-3 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors">
                    <Trash2 size={16} /> Delete
                  </button>
                </div>
              </>
            )}
          </div>
        )}
      </td>
    </tr>
  );
};

export default JobRowDesktop;
