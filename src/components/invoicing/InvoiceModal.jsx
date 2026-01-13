import React, { useEffect, useState } from 'react';
import { X, CheckCircle, Download, FileText } from 'lucide-react';
import { PDFViewer, PDFDownloadLink } from '@react-pdf/renderer';
import InvoiceDocument from './InvoiceDocument';

const InvoiceModal = ({ isOpen, onClose, job, client, onMarkInvoiced }) => {
  const [isClientReady, setIsClientReady] = useState(false);

  // React-PDF requires client-side mounting
  useEffect(() => {
    setIsClientReady(true);
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

        {/* PDF Viewer (Main Content) */}
        <div className="flex-1 bg-gray-100 p-4">
          {isClientReady ? (
            <PDFViewer width="100%" height="100%" className="rounded-lg border border-gray-200 shadow-inner">
              <InvoiceDocument job={job} client={client} />
            </PDFViewer>
          ) : (
            <div className="flex items-center justify-center h-full text-slate-400">
              Loading PDF Engine...
            </div>
          )}
        </div>

        {/* Footer Controls */}
        <div className="px-6 py-4 border-t border-gray-100 bg-white flex justify-between items-center">
          <div className="text-sm text-slate-500">
            Status: {job.invoicedAt ? (
              <span className="text-green-600 font-medium flex items-center gap-1">
                <CheckCircle size={14} /> Invoiced ({job.invoiceNumber})
              </span>
            ) : (
              <span className="text-amber-600 font-medium">Draft (Not Sent)</span>
            )}
          </div>

          <div className="flex gap-3">
            {/* Mark as Invoiced Button */}
            {!job.invoicedAt && (
              <button
                onClick={() => onMarkInvoiced(job.id)}
                className="px-4 py-2 text-slate-700 bg-gray-100 hover:bg-gray-200 rounded-lg font-medium flex items-center gap-2 transition-colors"
              >
                <CheckCircle size={18} />
                Mark as Invoiced
              </button>
            )}

            {/* Download Button (Native PDF Link) */}
            {isClientReady && (
              <PDFDownloadLink
                document={<InvoiceDocument job={job} client={client} />}
                fileName={`Invoice_${client.name.replace(/\s+/g, '_')}.pdf`}
                className="px-6 py-2 bg-brand-600 text-white rounded-lg font-bold hover:bg-brand-700 flex items-center gap-2 transition-colors shadow-sm"
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
