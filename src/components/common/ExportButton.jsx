import React from 'react';
import { Download } from 'lucide-react';
import { generateCSV, downloadCSV } from '../../lib/csv';

const ExportButton = ({ data, filename, headers, role }) => {
  // Security: Render nothing if not Admin
  if (role !== 'admin') return null;

  const handleExport = () => {
    const csv = generateCSV(data, headers);
    downloadCSV(csv, `${filename}_${new Date().toISOString().split('T')[0]}.csv`);
  };

  return (
    <button
      onClick={handleExport}
      className="hidden md:flex items-center gap-2 px-4 py-2 border border-slate-300 text-slate-700 font-medium rounded-lg hover:bg-slate-50 transition-colors"
      title="Export to CSV"
    >
      <Download size={18} />
      <span>Export</span>
    </button>
  );
};

export default ExportButton;
