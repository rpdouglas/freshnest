import React, { useState } from 'react';
import { Plus, Search } from 'lucide-react';
import { useClients } from '../hooks/useClients';
import ClientListMobile from '../components/clients/ClientListMobile';
import ClientTableDesktop from '../components/clients/ClientTableDesktop';
import ClientFormModal from '../components/clients/ClientFormModal';

const ClientsPage = () => {
  const { clients, loading, error, addClient } = useClients();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  // Client-side filtering
  const filteredClients = clients.filter(c => 
    c.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    c.email?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
      {/* Header & Actions */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Clients</h1>
          <p className="text-slate-500 text-sm">Manage your residential and commercial customers</p>
        </div>
        
        <div className="flex gap-3">
          <div className="relative flex-1 md:w-64">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
            <input 
              type="text"
              placeholder="Search clients..."
              className="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
          <button 
            onClick={() => setIsModalOpen(true)}
            className="bg-brand-600 text-white px-4 py-2 rounded-lg font-semibold hover:bg-brand-700 flex items-center gap-2 shadow-sm whitespace-nowrap"
          >
            <Plus size={20} />
            <span className="hidden md:inline">Add Client</span>
            <span className="md:hidden">Add</span>
          </button>
        </div>
      </div>

      {/* Content */}
      {loading ? (
        <div className="flex justify-center py-12">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-brand-600"></div>
        </div>
      ) : error ? (
        <div className="bg-red-50 text-red-600 p-4 rounded-lg border border-red-100">
          Error: {error}
        </div>
      ) : (
        <>
          <ClientListMobile clients={filteredClients} />
          <ClientTableDesktop clients={filteredClients} />
        </>
      )}

      {/* Modals */}
      <ClientFormModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={addClient}
      />
    </div>
  );
};

export default ClientsPage;
