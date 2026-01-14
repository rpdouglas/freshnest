import { format } from 'date-fns';

/**
 * Converts an array of objects to a CSV string.
 * Automatically handles escaping of special characters.
 */
export const generateCSV = (data, headers) => {
  if (!data || !data.length) return '';

  const processRow = (row) => {
    return headers.map(header => {
      let value = row[header.key];
      
      // Formatting Logic
      if (value === null || value === undefined) {
        value = '';
      } else if (value instanceof Date) {
        value = format(value, 'yyyy-MM-dd HH:mm:ss');
      } else if (typeof value === 'object') {
        // Flatten simple objects if needed, or stringify
        value = JSON.stringify(value);
      } else {
        value = String(value);
      }

      // Escape Logic: If value contains comma, newline, or quote, wrap in quotes
      if (value.includes(',') || value.includes('\n') || value.includes('"')) {
        value = `"${value.replace(/"/g, '""')}"`;
      }

      return value;
    }).join(',');
  };

  const csvRows = [
    headers.map(h => h.label).join(','), // Header Row
    ...data.map(processRow)              // Data Rows
  ];

  return csvRows.join('\n');
};

/**
 * Triggers a browser download of the CSV content
 */
export const downloadCSV = (csvContent, filename) => {
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  if (link.download !== undefined) {
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', filename);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
};
