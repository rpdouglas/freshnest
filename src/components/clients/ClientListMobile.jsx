import React from 'react';
import { MapPin, Phone, Mail } from 'lucide-react';

const ClientListMobile = ({ clients }) => {
  if (clients.length === 0) {
    return (
      <div className="text-center py-10 bg-white rounded-xl border border-gray-100">
        <p className="text-gray-500">No clients found.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:hidden">
      {clients.map((client) => (
        <div key={client.id} className="bg-white p-4 rounded-xl shadow-sm border border-gray-100">
          <div className="flex justify-between items-start mb-2">
            <h3 className="font-bold text-slate-800 text-lg">{client.name}</h3>
          </div>
          
          <div className="space-y-2 text-sm text-slate-600">
            {client.address && (
              <div className="flex items-start gap-2">
                <MapPin size={16} className="text-brand-500 shrink-0 mt-0.5" />
                <span>{client.address}</span>
              </div>
            )}
            
            <div className="flex gap-3 mt-3 pt-3 border-t border-gray-50">
              {client.phone && (
                <a 
                  href={`tel:${client.phone}`}
                  className="flex-1 flex items-center justify-center gap-2 py-2 bg-green-50 text-green-700 rounded-lg font-medium text-xs active:bg-green-100"
                >
                  <Phone size={14} /> Call
                </a>
              )}
              {client.email && (
                <a 
                  href={`mailto:${client.email}`}
                  className="flex-1 flex items-center justify-center gap-2 py-2 bg-blue-50 text-blue-700 rounded-lg font-medium text-xs active:bg-blue-100"
                >
                  <Mail size={14} /> Email
                </a>
              )}
            </div>
          </div>
        </div>
      ))}
    </div>
  );
};

export default ClientListMobile;
