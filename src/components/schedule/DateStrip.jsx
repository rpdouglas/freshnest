import React from 'react';
import { format, isSameDay, addDays, startOfWeek } from 'date-fns';
import { ChevronLeft, ChevronRight } from 'lucide-react';

const DateStrip = ({ selectedDate, onSelectDate }) => {
  // Always show the week surrounding the selected date
  // Start week on Monday (default US is Sunday, but operations usually prefer Mon)
  const weekStart = startOfWeek(selectedDate, { weekStartsOn: 1 });
  
  const days = Array.from({ length: 7 }).map((_, i) => addDays(weekStart, i));

  const handlePrevWeek = () => onSelectDate(addDays(selectedDate, -7));
  const handleNextWeek = () => onSelectDate(addDays(selectedDate, 7));

  return (
    <div className="bg-white border-b border-gray-200 shadow-sm">
      {/* Week Navigation Header */}
      <div className="flex items-center justify-between px-4 py-2 border-b border-gray-100">
        <button 
          onClick={handlePrevWeek}
          className="p-1 hover:bg-gray-100 rounded-full text-slate-500"
        >
          <ChevronLeft size={20} />
        </button>
        <h2 className="font-bold text-slate-800">
          {format(selectedDate, 'MMMM yyyy')}
        </h2>
        <button 
          onClick={handleNextWeek}
          className="p-1 hover:bg-gray-100 rounded-full text-slate-500"
        >
          <ChevronRight size={20} />
        </button>
      </div>

      {/* Horizontal Scrollable Days */}
      <div className="flex justify-between md:justify-center md:gap-8 px-2 py-3 overflow-x-auto no-scrollbar">
        {days.map((day) => {
          const isSelected = isSameDay(day, selectedDate);
          const isToday = isSameDay(day, new Date());

          return (
            <button
              key={day.toString()}
              onClick={() => onSelectDate(day)}
              className={`flex flex-col items-center justify-center min-w-[3rem] py-2 rounded-xl transition-all ${
                isSelected 
                  ? 'bg-brand-600 text-white shadow-md transform scale-105' 
                  : 'hover:bg-gray-50 text-slate-600'
              }`}
            >
              <span className={`text-xs font-medium uppercase mb-1 ${isSelected ? 'text-brand-100' : 'text-slate-400'}`}>
                {format(day, 'EEE')}
              </span>
              <span className={`text-lg font-bold ${isSelected ? 'text-white' : isToday ? 'text-brand-600' : 'text-slate-800'}`}>
                {format(day, 'd')}
              </span>
              {isToday && !isSelected && (
                <div className="w-1 h-1 bg-brand-500 rounded-full mt-1"></div>
              )}
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default DateStrip;
