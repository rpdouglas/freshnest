import { useState, useEffect } from 'react';
import { collection, query, where, onSnapshot, doc, getDoc } from 'firebase/firestore';
import { auth, db } from '../lib/firebase';
import { startOfMonth, isAfter } from 'date-fns';

export const useFinancials = () => {
  const [data, setData] = useState({
    limit: null,
    mode: 'unlimited',
    currentEarnings: 0,
    remainingBudget: 0,
    percentUsed: 0
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const loadFinancials = async () => {
      // 1. Fetch User Profile for Limit
      // We assume the user has migrated to the new schema from Sprint 1
      const userDocRef = doc(db, 'users', user.uid);
      
      // Listen to Profile Changes (Real-time limit updates)
      const unsubProfile = onSnapshot(userDocRef, (docSnap) => {
        const userData = docSnap.data();
        const financials = userData?.financials || { mode: 'unlimited', limit: 0 };
        const orgId = userData?.orgId;

        if (!orgId) return;

        // 2. Query Completed Jobs for this User, this Month
        // Note: For MVP, we filter date client-side to avoid complex composite indexes immediately.
        const q = query(
          collection(db, 'jobs'),
          where('orgId', '==', orgId),
          where('assignedTo', 'array-contains', user.uid),
          where('status', '==', 'completed')
        );

        const unsubJobs = onSnapshot(q, (jobSnap) => {
          const monthStart = startOfMonth(new Date());
          
          let earnings = 0;
          jobSnap.docs.forEach(doc => {
            const job = doc.data();
            const completedAt = job.completedAt?.toDate();
            
            // "The Carla Check": Only count jobs from THIS month
            if (completedAt && isAfter(completedAt, monthStart)) {
              earnings += Number(job.price || 0);
            }
          });

          // Calculate Metrics
          const limit = Number(financials.limit || 0);
          const mode = financials.mode || 'unlimited';
          
          // Safety: If unlimited, percentage is always 0
          const percent = (mode === 'cap' && limit > 0) 
            ? Math.min((earnings / limit) * 100, 100) 
            : 0;

          setData({
            limit,
            mode,
            currentEarnings: earnings,
            remainingBudget: mode === 'cap' ? Math.max(limit - earnings, 0) : Infinity,
            percentUsed: percent
          });
          setLoading(false);
        });

        return () => unsubJobs(); // Cleanup jobs listener
      });

      return () => unsubProfile(); // Cleanup profile listener
    };

    const cleanupPromise = loadFinancials();
    return () => { cleanupPromise.then(fn => fn && fn()); };
  }, []);

  // "The Guardrail Function"
  const isCapReached = (jobPrice) => {
    if (data.mode !== 'cap') return false;
    return (data.currentEarnings + Number(jobPrice)) > data.limit;
  };

  return { ...data, isCapReached, loading };
};
