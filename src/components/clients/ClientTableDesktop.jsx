import React from 'react';
import { MapPin, Phone, Mail, MoreHorizontal } from 'lucide-react';

const ClientTableDesktop = ({ clients }) => {
  if (clients.length === 0) {
    return (
      <div className="hidden md:block bg-white p-12 text-center rounded-xl border border-gray-200">
        <p className="text-gray-500">No clients found. Add one to get started.</p>
      </div>
    );
  }

  return (
    <div className="hidden md:block bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <table className="w-full text-left border-collapse">
        <thead>
          <tr className="bg-gray-50 border-b border-gray-200 text-xs uppercase text-gray-500 font-semibold">
            <th className="px-6 py-4">Client Name</th>
            <th className="px-6 py-4">Contact Info</th>
            <th className="px-6 py-4">Address</th>
            <th className="px-6 py-4 text-right">Actions</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100">
          {clients.map((client) => (
            <tr key={client.id} className="hover:bg-gray-50 transition-colors">
              <td className="px-6 py-4">
                <div className="font-medium text-slate-900">{client.name}</div>
                <div className="text-xs text-slate-400">ID: {client.id.slice(0,8)}...</div>
              </td>
              <td className="px-6 py-4">
                <div className="flex flex-col gap-1 text-sm text-slate-600">
                  {client.phone && (
                    <div className="flex items-center gap-2">
                      <Phone size={14} className="text-slate-400" />
                      {client.phone}
                    </div>
                  )}
                  {client.email && (
                    <div className="flex items-center gap-2">
                      <Mail size={14} className="text-slate-400" />
                      {client.email}
                    </div>
                  )}
                </div>
              </td>
              <td className="px-6 py-4">
                <div className="flex items-start gap-2 text-sm text-slate-600 max-w-[200px]">
                  <MapPin size={14} className="text-slate-400 shrink-0 mt-0.5" />
                  <span className="truncate">{client.address}</span>
                </div>
              </td>
              <td className="px-6 py-4 text-right">
                <button className="text-slate-400 hover:text-brand-600 p-2">
                  <MoreHorizontal size={20} />
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ClientTableDesktop;
