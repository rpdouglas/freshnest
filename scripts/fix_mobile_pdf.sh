#!/bin/bash

echo "🔧 Applying Hotfix: Mobile PDF Rendering..."

echo "📝 Updating src/components/invoicing/InvoiceModal.jsx..."
cat << 'INNER_EOF' > src/components/invoicing/InvoiceModal.jsx
import React, { useEffect, useState } from 'react';
import { X, CheckCircle, Download, FileText, ExternalLink } from 'lucide-react';
import { PDFViewer, PDFDownloadLink } from '@react-pdf/renderer';
import InvoiceDocument from './InvoiceDocument';

const InvoiceModal = ({ isOpen, onClose, job, client, onMarkInvoiced }) => {
  const [isClientReady, setIsClientReady] = useState(false);
  const [isMobile, setIsMobile] = useState(false);

  // Check if mobile (simple width check)
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
        <div className="flex-1 bg-gray-100 p-4 flex flex-col items-center justify-center">
          {isClientReady ? (
            isMobile ? (
              // --- MOBILE VIEW (No Iframe) ---
              <div className="text-center space-y-4 p-6 bg-white rounded-xl shadow-sm max-w-sm">
                <div className="w-16 h-16 bg-brand-50 text-brand-500 rounded-full flex items-center justify-center mx-auto mb-2">
                  <FileText size={32} />
                </div>
                <h4 className="font-bold text-slate-800">PDF Ready</h4>
                <p className="text-sm text-slate-500">
                  Mobile browsers cannot embed PDF previews. Please download the file to view it.
                </p>
                <PDFDownloadLink
                  document={<InvoiceDocument job={job} client={client} />}
                  fileName={`Invoice_${client.name.replace(/\s+/g, '_')}.pdf`}
                  className="block w-full py-3 bg-brand-600 text-white rounded-lg font-bold hover:bg-brand-700 transition-colors"
                >
                  {({ loading }) => (loading ? 'Preparing...' : 'Download / Open PDF')}
                </PDFDownloadLink>
              </div>
            ) : (
              // --- DESKTOP VIEW (Embed) ---
              <PDFViewer width="100%" height="100%" className="rounded-lg border border-gray-200 shadow-inner">
                <InvoiceDocument job={job} client={client} />
              </PDFViewer>
            )
          ) : (
            <div className="flex items-center justify-center h-full text-slate-400">
              Loading PDF Engine...
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
            {/* Mark as Invoiced Button */}
            {!job.invoicedAt && (
              <button
                onClick={() => onMarkInvoiced(job.id)}
                className="flex-1 md:flex-none px-4 py-2 text-slate-700 bg-gray-100 hover:bg-gray-200 rounded-lg font-medium flex items-center justify-center gap-2 transition-colors"
              >
                <CheckCircle size={18} />
                <span className="md:inline">Mark Invoiced</span>
              </button>
            )}

            {/* Desktop Download Button (Hidden on Mobile since we have the big button above) */}
            {!isMobile && isClientReady && (
              <PDFDownloadLink
                document={<InvoiceDocument job={job} client={client} />}
                fileName={`Invoice_${client.name.replace(/\s+/g, '_')}.pdf`}
                className="px-6 py-2 bg-brand-600 text-white rounded-lg font-bold hover:bg-brand-700 flex items-center gap-2 transition-colors shadow-sm"
              >
                {({ loading }) => (
                  <>
                    <Download size={18} />
                    {loading ? 'Preparing...' : 'Download'}
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

echo "✅ Hotfix Applied: Responsive PDF Modal."
