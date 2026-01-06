import React, { useState } from 'react';
import { startOfWeek, endOfWeek, isSameDay } from 'date-fns';
import { useSchedule } from '../hooks/useSchedule';
import { useClients } from '../hooks/useClients';
import DateStrip from '../components/schedule/DateStrip';
import DailyAgenda from '../components/schedule/DailyAgenda';

const SchedulePage = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());

  // Calculate the Start and End of the current week for the query
  // We fetch a whole week's worth of data so switching days is instant
  const weekStart = startOfWeek(selectedDate, { weekStartsOn: 1 }); // Monday
  const weekEnd = endOfWeek(selectedDate, { weekStartsOn: 1 });     // Sunday

  // Custom hooks
  const { jobs, loading: scheduleLoading, error } = useSchedule(weekStart, weekEnd);
  const { clients, loading: clientsLoading } = useClients();

  // Filter the fetched week's jobs to show only the selected day
  const todaysJobs = jobs.filter(job => 
    job.scheduledDate && isSameDay(job.scheduledDate, selectedDate)
  );

  return (
    <div className="bg-gray-50 min-h-full pb-20">
      {/* 1. Date Navigation */}
      <div className="sticky top-0 z-10">
        <DateStrip 
          selectedDate={selectedDate} 
          onSelectDate={setSelectedDate} 
        />
      </div>

      {/* 2. Main Agenda View */}
      <main>
        {error && (
          <div className="p-4 m-4 bg-red-50 text-red-600 rounded-lg text-sm text-center">
            {error}
          </div>
        )}

        <DailyAgenda 
          jobs={todaysJobs} 
          clients={clients} 
          loading={scheduleLoading || clientsLoading} 
          selectedDate={selectedDate}
        />
      </main>
    </div>
  );
};

export default SchedulePage;
