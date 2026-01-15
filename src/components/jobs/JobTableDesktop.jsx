import React from 'react';
import JobRowDesktop from './JobRowDesktop';

const JobTableDesktop = ({ jobs, clients, staff, userRole, onEdit, onDelete, onInvoice, financialData, checkConflict }) => {
  const getClient = (id) => clients.find(c => c.id === id) || {};
  
  const getAssignedStaffName = (staffIds) => {
    if (!staffIds || staffIds.length === 0) return 'Unassigned';
    const member = staff.find(s => s.id === staffIds[0]);
    return member ? (member.fullName || member.email) : 'Unknown';
  };

  if (jobs.length === 0) {
    return (
      <div className="hidden md:block bg-white p-12 text-center rounded-xl border border-gray-200">
        <p className="text-gray-500">No jobs found.</p>
      </div>
    );
  }

  return (
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
          {jobs.map((job) => (
            <JobRowDesktop 
              key={job.id} 
              job={job}
              getClient={getClient}
              getAssignedStaffName={getAssignedStaffName}
              userRole={userRole}
              onEdit={onEdit}
              onDelete={onDelete}
              onInvoice={onInvoice}
              financialData={financialData}
              conflict={checkConflict ? checkConflict(job.id) : null}
            />
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default JobTableDesktop;
