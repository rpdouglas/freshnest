import { useMemo } from 'react';
import { getDay, getHours, addMinutes, differenceInMinutes, isSameDay } from 'date-fns';

export const useConflictEngine = (jobs, userProfile) => {
  
  const conflicts = useMemo(() => {
    const map = {};
    if (!userProfile || !jobs || jobs.length === 0) return map;

    // --- 1. SETUP & SORTING ---
    // We need jobs sorted by time to calculate travel buffers
    const sortedJobs = [...jobs].sort((a, b) => 
      a.scheduledDate?.getTime() - b.scheduledDate?.getTime()
    );

    const constraints = userProfile.constraints || {};
    const profile = userProfile.profile || {};
    const blockedWindows = constraints.blockedWindows || [];
    const isTransit = profile.transport === 'transit';
    
    // Standard job duration (2 hours) hardcoded for MVP
    const JOB_DURATION_MINS = 120;
    const TRANSIT_BUFFER_MINS = 30;

    // --- 2. HARD CHECKS (Mike - Recovery) ---
    // Logic: Map ID to Time Range. If overlap -> HARD BLOCK.
    sortedJobs.forEach(job => {
      if (!job.scheduledDate) return;
      
      const date = job.scheduledDate;
      const day = getDay(date); // 0=Sun, 1=Mon, etc.
      const hour = getHours(date);

      let hardConflict = null;

      if (blockedWindows.includes('tue_evening') && day === 2 && hour >= 18) {
        hardConflict = "Personal Commitment (Tue Eve)";
      }
      if (blockedWindows.includes('thu_evening') && day === 4 && hour >= 18) {
        hardConflict = "Personal Commitment (Thu Eve)";
      }
      if (blockedWindows.includes('sat_morning') && day === 6 && hour < 12) {
        hardConflict = "Unavailable (Sat Morn)";
      }
      if (blockedWindows.includes('sun_allday') && day === 0) {
        hardConflict = "Unavailable (Sunday)";
      }

      if (hardConflict) {
        map[job.id] = { type: 'hard', message: hardConflict };
      }
    });

    // --- 3. SOFT CHECKS (Jasmine - Transit) ---
    // Logic: Compare Job(i) Start vs Job(i-1) End.
    if (isTransit) {
      for (let i = 1; i < sortedJobs.length; i++) {
        const currentJob = sortedJobs[i];
        const prevJob = sortedJobs[i - 1];

        // Skip if already hard blocked
        if (map[currentJob.id]) continue; 

        // Only check buffer if on the same day
        if (isSameDay(currentJob.scheduledDate, prevJob.scheduledDate)) {
          const prevEndTime = addMinutes(prevJob.scheduledDate, JOB_DURATION_MINS);
          const gap = differenceInMinutes(currentJob.scheduledDate, prevEndTime);

          if (gap < TRANSIT_BUFFER_MINS) {
            map[currentJob.id] = { 
              type: 'soft', 
              message: `Tight Schedule: Only ${gap}m travel time` 
            };
          }
        }
      }
    }

    return map;
  }, [jobs, userProfile]);

  // Helper to look up a specific job
  const checkConflict = (jobId) => conflicts[jobId] || null;

  return { conflicts, checkConflict };
};
