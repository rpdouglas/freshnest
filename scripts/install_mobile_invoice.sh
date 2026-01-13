#!/bin/bash

# ====================================================
# FRESH NEST: MOBILE INVOICE PREVIEW FIX
# Approach: Responsive HTML Preview for Mobile
# ====================================================

echo "🚀 Installing HTML Invoice Preview..."

# 1. Create the HTML Preview Component
# This mimics the PDF layout but uses standard Tailwind HTML for instant mobile rendering
echo "📝 Creating src/components/invoicing/InvoiceHTMLPreview.jsx..."
cat << 'INNER_EOF' > src/components/invoicing/InvoiceHTMLPreview.jsx
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
INNER_EOF

# 2. Update InvoiceModal to use HTML on Mobile
echo "📝 Updating src/components/invoicing/InvoiceModal.jsx..."
cat << 'INNER_EOF' > src/components/invoicing/InvoiceModal.jsx
import React, { useEffect, useState } from 'react';
import { X, CheckCircle, Download, FileText } from 'lucide-react';
import { PDFViewer, PDFDownloadLink } from '@react-pdf/renderer';
import InvoiceDocument from './InvoiceDocument';
import InvoiceHTMLPreview from './InvoiceHTMLPreview';

const InvoiceModal = ({ isOpen, onClose, job, client, onMarkInvoiced }) => {
  const [isClientReady, setIsClientReady] = useState(false);
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    setIsClientReady(true);
    const checkMobile = () => setIsMobile(window.innerWidth < 768);
    checkMobile();
    window.addEventListener('resize', checkMobile);
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  if (!isOpen || !job || !client) return null;

  return (
    <div className="fixed inset-0 bg-black/80 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
      <div className="bg-white rounded-xl shadow-2xl w-full max-w-4xl h-[90vh] flex flex-col overflow-hidden">
        
        {/* Header */}
        <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
          <div className="flex items-center gap-3">
            <div className="bg-brand-100 p-2 rounded-lg text-brand-600">
              <FileText size={20} />
            </div>
            <div>
              <h3 className="font-bold text-lg text-slate-800">Invoice Preview</h3>
              <p className="text-xs text-slate-500">Client: {client.name}</p>
            </div>
          </div>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
            <X size={24} />
          </button>
        </div>

        {/* CONTENT AREA */}
        <div className="flex-1 bg-gray-100 p-4 overflow-hidden relative">
          {isClientReady ? (
            isMobile ? (
              // --- MOBILE VIEW (HTML Preview) ---
              <div className="h-full overflow-y-auto">
                <InvoiceHTMLPreview job={job} client={client} />
              </div>
            ) : (
              // --- DESKTOP VIEW (PDF Embed) ---
              <PDFViewer width="100%" height="100%" className="rounded-lg border border-gray-200 shadow-inner">
                <InvoiceDocument job={job} client={client} />
              </PDFViewer>
            )
          ) : (
            <div className="flex items-center justify-center h-full text-slate-400">
              Loading Preview...
            </div>
          )}
        </div>

        {/* Footer Controls */}
        <div className="px-6 py-4 border-t border-gray-100 bg-white flex flex-col md:flex-row justify-between items-center gap-4">
          <div className="text-sm text-slate-500 w-full md:w-auto text-center md:text-left">
            Status: {job.invoicedAt ? (
              <span className="text-green-600 font-medium flex items-center justify-center md:justify-start gap-1">
                <CheckCircle size={14} /> Invoiced ({job.invoiceNumber})
              </span>
            ) : (
              <span className="text-amber-600 font-medium">Draft (Not Sent)</span>
            )}
          </div>

          <div className="flex gap-3 w-full md:w-auto">
            {!job.invoicedAt && (
              <button
                onClick={() => onMarkInvoiced(job.id)}
                className="flex-1 md:flex-none px-4 py-2 text-slate-700 bg-gray-100 hover:bg-gray-200 rounded-lg font-medium flex items-center justify-center gap-2 transition-colors"
              >
                <CheckCircle size={18} />
                <span className="md:inline">Mark Invoiced</span>
              </button>
            )}

            {/* DOWNLOAD BUTTON (Visible on BOTH Mobile & Desktop) */}
            {isClientReady && (
              <PDFDownloadLink
                document={<InvoiceDocument job={job} client={client} />}
                fileName={`Invoice_${client.name.replace(/\s+/g, '_')}.pdf`}
                className="flex-1 md:flex-none px-6 py-2 bg-brand-600 text-white rounded-lg font-bold hover:bg-brand-700 flex items-center justify-center gap-2 transition-colors shadow-sm"
              >
                {({ loading }) => (
                  <>
                    <Download size={18} />
                    {loading ? 'Preparing...' : 'Download PDF'}
                  </>
                )}
              </PDFDownloadLink>
            )}
          </div>
        </div>

      </div>
    </div>
  );
};

export default InvoiceModal;
INNER_EOF

echo "✅ SUCCESS! Mobile HTML Preview installed."
