import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useJobs } from '../hooks/useJobs';
import { useClients } from '../hooks/useClients';
import { useStaff } from '../hooks/useStaff';
import JobListMobile from '../components/jobs/JobListMobile';
import JobTableDesktop from '../components/jobs/JobTableDesktop';
import JobFormModal from '../components/jobs/JobFormModal';

const JobsPage = () => {
  // Destructure 'role' from hook
  const { jobs, loading: jobsLoading, error: jobsError, addJob, role: userRole } = useJobs();
  const { clients, loading: clientsLoading } = useClients(); 
  const { staff, loading: staffLoading } = useStaff();

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const loading = jobsLoading || clientsLoading || staffLoading;

  const filteredJobs = jobs.filter(job => {
    const clientName = clients.find(c => c.id === job.clientId)?.name?.toLowerCase() || '';
    return clientName.includes(searchTerm.toLowerCase());
  });

  return (
    <div className="space-y-6">
      {/* Header - Hide 'New Job' button for Staff if desired (Optional, keeping visible for now or hide?) 
          Usually staff don't create jobs, but sticking to prompt reqs: Staff View Restrictions.
          Let's hide the Add button if staff for better UX.
      */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Job Management</h1>
          <p className="text-slate-500 text-sm">Schedule and track cleaning appointments</p>
        </div>
        
        <div className="flex gap-3">
          <div className="relative flex-1 md:w-64">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
            <input 
              type="text"
              placeholder="Search by client..."
              className="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
          {/* Only Admin can add jobs */}
          {userRole === 'admin' && (
            <button 
              onClick={() => setIsModalOpen(true)}
              className="bg-brand-600 text-white px-4 py-2 rounded-lg font-semibold hover:bg-brand-700 flex items-center gap-2 shadow-sm whitespace-nowrap"
            >
              <Plus size={20} />
              <span className="hidden md:inline">New Job</span>
              <span className="md:hidden">New</span>
            </button>
          )}
        </div>
      </div>

      {/* Content */}
      {loading ? (
        <div className="flex justify-center py-12">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-brand-600"></div>
        </div>
      ) : jobsError ? (
        <div className="bg-red-50 text-red-600 p-4 rounded-lg border border-red-100">
          Error: {jobsError}
        </div>
      ) : (
        <>
          <JobListMobile jobs={filteredJobs} clients={clients} staff={staff} userRole={userRole} />
          <JobTableDesktop jobs={filteredJobs} clients={clients} staff={staff} userRole={userRole} />
        </>
      )}

      <JobFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={addJob} 
        clients={clients} 
        staff={staff}
      />
    </div>
  );
};

export default JobsPage;
