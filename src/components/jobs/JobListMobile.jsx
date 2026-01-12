import React from 'react';
import JobCardMobile from './JobCardMobile';

const JobListMobile = ({ jobs, clients, staff, userRole }) => {
  const getClientName = (id) => clients.find(c => c.id === id)?.name || 'Unknown Client';
  const getClientAddress = (id) => clients.find(c => c.id === id)?.address;
  
  const getAssignedStaffName = (staffIds) => {
    if (!staffIds || staffIds.length === 0) return 'Unassigned';
    const member = staff.find(s => s.id === staffIds[0]);
    return member ? (member.fullName || member.email) : 'Unknown';
  };

  if (jobs.length === 0) {
    return (
      <div className="md:hidden text-center py-10 bg-white rounded-xl border border-gray-100">
        <p className="text-gray-500">No jobs found.</p>
      </div>
    );
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
        />
      ))}
    </div>
  );
};

export default JobListMobile;
