import React from 'react';
import { DollarSign, ShieldCheck, ShieldAlert } from 'lucide-react';

const FinancialProgress = ({ current, limit, percent, mode }) => {
  // If unlimited, show a simple "Earnings" card
  if (mode !== 'cap') {
    return (
      <div className="bg-white p-4 rounded-xl shadow-sm border border-gray-100 flex items-center gap-4">
        <div className="bg-green-50 p-3 rounded-full text-green-600">
          <DollarSign size={24} />
        </div>
        <div>
          <p className="text-xs text-slate-500 uppercase font-bold">Month to Date</p>
          <p className="text-xl font-bold text-slate-900">${current.toFixed(2)}</p>
        </div>
      </div>
    );
  }

  // Color Logic (Traffic Light)
  let colorClass = "bg-brand-500";
  let statusIcon = <ShieldCheck size={20} className="text-green-600" />;
  let statusText = "Safe to Earn";

  if (percent > 95) {
    colorClass = "bg-red-500";
    statusIcon = <ShieldAlert size={20} className="text-red-600" />;
    statusText = "Limit Reached";
  } else if (percent > 75) {
    colorClass = "bg-yellow-500";
    statusText = "Approaching Limit";
  }

  return (
    <div className="bg-white p-5 rounded-xl shadow-sm border border-gray-200">
      <div className="flex justify-between items-start mb-3">
        <div>
          <h3 className="font-bold text-slate-800 flex items-center gap-2">
            {statusIcon}
            Monthly Cap
          </h3>
          <p className="text-xs text-slate-500 mt-1">{statusText}</p>
        </div>
        <div className="text-right">
          <span className="block text-xl font-bold text-slate-900">
            ${current.toFixed(0)} <span className="text-slate-400 text-sm">/ ${limit}</span>
          </span>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="h-3 w-full bg-slate-100 rounded-full overflow-hidden">
        <div 
          className={`h-full ${colorClass} transition-all duration-500 ease-out`}
          style={{ width: `${percent}%` }}
        />
      </div>
      
      <p className="text-[10px] text-slate-400 mt-2 text-right">
        Reset on 1st of month
      </p>
    </div>
  );
};

export default FinancialProgress;
