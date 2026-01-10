import React, { useState } from 'react';
import { startOfWeek, endOfWeek, isSameDay } from 'date-fns';
import { useSchedule } from '../hooks/useSchedule';
import { useClients } from '../hooks/useClients';
import DateStrip from '../components/schedule/DateStrip';
import DailyAgenda from '../components/schedule/DailyAgenda';

const SchedulePage = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());

  const weekStart = startOfWeek(selectedDate, { weekStartsOn: 1 }); 
  const weekEnd = endOfWeek(selectedDate, { weekStartsOn: 1 });     

  // Destructure role here
  const { jobs, loading: scheduleLoading, error, role: userRole } = useSchedule(weekStart, weekEnd);
  const { clients, loading: clientsLoading } = useClients();

  const todaysJobs = jobs.filter(job => 
    job.scheduledDate && isSameDay(job.scheduledDate, selectedDate)
  );

  return (
    <div className="bg-gray-50 min-h-full pb-20">
      <div className="sticky top-0 z-10">
        <DateStrip 
          selectedDate={selectedDate} 
          onSelectDate={setSelectedDate} 
        />
      </div>

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
          userRole={userRole} 
        />
      </main>
    </div>
  );
};

export default SchedulePage;
