import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useJobs } from '../hooks/useJobs';
import { useClients } from '../hooks/useClients';
import { useStaff } from '../hooks/useStaff';
import { useFinancials } from '../hooks/useFinancials'; 
import { useProfile } from '../hooks/useProfile'; // NEEDED FOR CONSTRAINTS
import { useConflictEngine } from '../hooks/useConflictEngine'; // NEW HOOK

import JobListMobile from '../components/jobs/JobListMobile';
import JobTableDesktop from '../components/jobs/JobTableDesktop';
import JobFormModal from '../components/jobs/JobFormModal';
import InvoiceModal from '../components/invoicing/InvoiceModal';
import ExportButton from '../components/common/ExportButton';

const JobsPage = () => {
  const { jobs, loading: jobsLoading, error: jobsError, addJob, updateJob, deleteJob, markAsInvoiced, role: userRole } = useJobs();
  const { clients, loading: clientsLoading } = useClients(); 
  const { staff, loading: staffLoading } = useStaff();
  
  // 1. DATA LAYERS
  const financialData = useFinancials();
  const { profile } = useProfile(); // Fetch constraints
  
  // 2. INITIALIZE CONFLICT ENGINE
  const { checkConflict } = useConflictEngine(jobs, profile);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingJobId, setEditingJobId] = useState(null);
  const [invoicingJobId, setInvoicingJobId] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  const loading = jobsLoading || clientsLoading || staffLoading;

  const filteredJobs = jobs.filter(job => {
    const clientName = clients.find(c => c.id === job.clientId)?.name?.toLowerCase() || '';
    return clientName.includes(searchTerm.toLowerCase());
  });

  const exportData = filteredJobs.map(job => {
    const client = clients.find(c => c.id === job.clientId);
    const assignedMember = job.assignedTo?.[0] ? staff.find(s => s.id === job.assignedTo[0]) : null;
    return {
      ...job,
      clientName: client ? client.name : 'Unknown',
      clientAddress: client ? client.address : '',
      assignedToName: assignedMember ? assignedMember.fullName : 'Unassigned',
      scheduledDate: job.scheduledDate, 
      completedAt: job.completedAt
    };
  });

  const exportHeaders = [
    { key: 'invoiceNumber', label: 'Invoice #' },
    { key: 'clientName', label: 'Client' },
    { key: 'clientAddress', label: 'Address' },
    { key: 'serviceType', label: 'Service' },
    { key: 'price', label: 'Price' },
    { key: 'status', label: 'Status' },
    { key: 'scheduledDate', label: 'Scheduled' },
    { key: 'completedAt', label: 'Completed' },
    { key: 'assignedToName', label: 'Staff' }
  ];

  const handleCreateOpen = () => { setEditingJobId(null); setIsModalOpen(true); };
  const handleEditOpen = (job) => { setEditingJobId(job.id); setIsModalOpen(true); };
  const handleInvoiceOpen = (job) => { setInvoicingJobId(job.id); };

  const handleSave = async (formData) => {
    if (editingJobId) { await updateJob(editingJobId, formData); } 
    else { await addJob(formData); }
  };

  const handleDelete = async (jobId) => {
    if (window.confirm("Delete job?")) { await deleteJob(jobId); }
  };

  const handleMarkInvoiced = async (jobId) => { await markAsInvoiced(jobId); };

  return (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Job Management</h1>
          <p className="text-slate-500 text-sm">Schedule and track cleaning appointments</p>
        </div>
        <div className="flex gap-3">
          <div className="relative flex-1 md:w-64">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
            <input 
              type="text" placeholder="Search..." 
              className="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-lg focus:outline-none"
              value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
          <ExportButton role={userRole} data={exportData} filename="Jobs" headers={exportHeaders} />
          {userRole === 'admin' && (
            <button onClick={handleCreateOpen} className="bg-brand-600 text-white px-4 py-2 rounded-lg font-semibold flex items-center gap-2">
              <Plus size={20} /> <span className="hidden md:inline">New Job</span>
            </button>
          )}
        </div>
      </div>

      {loading ? (
        <div className="flex justify-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-brand-600"></div></div>
      ) : (
        <>
          {/* 3. PASS DOWN CONFLICT CHECKER */}
          <JobListMobile 
            jobs={filteredJobs} 
            clients={clients} 
            staff={staff}
            userRole={userRole}
            onEdit={handleEditOpen}
            onInvoice={handleInvoiceOpen}
            financialData={financialData}
            checkConflict={checkConflict} 
          />
          <JobTableDesktop 
            jobs={filteredJobs} 
            clients={clients} 
            staff={staff} 
            userRole={userRole}
            onEdit={handleEditOpen} 
            onDelete={handleDelete} 
            onInvoice={handleInvoiceOpen}
            financialData={financialData}
            checkConflict={checkConflict}
          />
        </>
      )}

      <JobFormModal 
        isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} onSave={handleSave} 
        clients={clients} staff={staff} initialData={editingJobId ? jobs.find(j => j.id === editingJobId) : null}
      />
      <InvoiceModal 
        isOpen={!!invoicingJobId} onClose={() => setInvoicingJobId(null)} 
        job={invoicingJobId ? jobs.find(j => j.id === invoicingJobId) : null} 
        client={invoicingJobId ? clients.find(c => c.id === jobs.find(j => j.id === invoicingJobId).clientId) : null}
        onMarkInvoiced={handleMarkInvoiced}
      />
    </div>
  );
};

export default JobsPage;
