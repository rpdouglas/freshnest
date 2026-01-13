import React from 'react';
import { format } from 'date-fns';

const InvoiceHTMLPreview = ({ job, client }) => {
  const invoiceNum = job.invoiceNumber || 'DRAFT';
  const date = job.invoicedAt ? format(job.invoicedAt, 'MMM d, yyyy') : format(new Date(), 'MMM d, yyyy');

  return (
    <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-sm h-full overflow-y-auto">
      {/* Header */}
      <div className="flex justify-between items-start border-b border-gray-100 pb-4 mb-4">
        <div>
          <h2 className="text-xl font-bold text-brand-600">INVOICE</h2>
          <p className="text-slate-500 font-mono text-xs mt-1">#{invoiceNum}</p>
        </div>
        <div className="text-right">
          <h3 className="font-bold text-slate-800">Fresh Nest</h3>
          <p className="text-slate-500 text-xs">{date}</p>
        </div>
      </div>

      {/* Bill To */}
      <div className="mb-6">
        <h4 className="text-xs font-bold text-slate-400 uppercase mb-2">Bill To</h4>
        <div className="text-slate-800 font-medium">{client.name}</div>
        <div className="text-slate-600 text-xs">{client.email}</div>
        <div className="text-slate-600 text-xs mt-1 max-w-[200px]">{client.address}</div>
      </div>

      {/* Line Items */}
      <div className="mb-6">
        <div className="flex justify-between text-xs font-bold text-slate-400 border-b border-gray-100 pb-2 mb-2">
          <span>Description</span>
          <span>Amount</span>
        </div>
        
        <div className="flex justify-between items-start py-2">
          <div>
            <div className="font-medium text-slate-800 capitalize">
              {job.serviceType} Cleaning Service
            </div>
            <div className="text-xs text-slate-500">
              Date: {job.scheduledDate ? format(job.scheduledDate, 'MMM d, yyyy') : 'N/A'}
            </div>
          </div>
          <div className="font-medium text-slate-800">
            ${job.price?.toFixed(2)}
          </div>
        </div>
      </div>

      {/* Total */}
      <div className="flex justify-end border-t border-gray-200 pt-4 mb-8">
        <div className="text-right">
          <span className="text-slate-500 text-xs mr-4">Total Due:</span>
          <span className="text-xl font-bold text-brand-600">${job.price?.toFixed(2)}</span>
        </div>
      </div>

      {/* Footer */}
      <div className="text-center text-xs text-slate-400 mt-auto pt-8 border-t border-gray-50">
        <p>Thank you for choosing Fresh Nest!</p>
        <p>Please pay within 30 days.</p>
      </div>
    </div>
  );
};

export default InvoiceHTMLPreview;
