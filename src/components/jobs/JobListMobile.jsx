import React from 'react';
import JobCardMobile from './JobCardMobile';

const JobListMobile = ({ jobs, clients, staff, userRole, onEdit, onInvoice, financialData, checkConflict }) => {
  const getClientName = (id) => clients.find(c => c.id === id)?.name || 'Unknown Client';
  const getClientAddress = (id) => clients.find(c => c.id === id)?.address;
  
  const getAssignedStaffName = (staffIds) => {
    if (!staffIds || staffIds.length === 0) return 'Unassigned';
    const member = staff.find(s => s.id === staffIds[0]);
    return member ? (member.fullName || member.email) : 'Unknown';
  };

  if (jobs.length === 0) {
    return <div className="text-center py-10 bg-white rounded-xl border border-gray-100 text-gray-500">No jobs found.</div>;
  }

  return (
    <div className="space-y-4 md:hidden">
      {jobs.map((job) => (
        <JobCardMobile 
          key={job.id} 
          job={job}
          getClientName={getClientName}
          getClientAddress={getClientAddress}
          getAssignedStaffName={getAssignedStaffName}
          userRole={userRole}
          onEdit={onEdit}
          onInvoice={onInvoice}
          financialData={financialData}
          conflict={checkConflict ? checkConflict(job.id) : null}
        />
      ))}
    </div>
  );
};

export default JobListMobile;
