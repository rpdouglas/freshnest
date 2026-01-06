import { useState, useEffect } from 'react';
import { 
  collection, 
  query, 
  where, 
  onSnapshot, 
  orderBy,
  Timestamp 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useSchedule = (startDate, endDate) => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user || !startDate || !endDate) {
      setLoading(false);
      return;
    }

    user.getIdTokenResult().then((idTokenResult) => {
      const orgId = idTokenResult.claims.orgId;

      if (!orgId) {
        setError("Organization ID missing.");
        setLoading(false);
        return;
      }

      // SECURITY: Filter by orgId AND Date Range
      // Note: This relies on the composite index (orgId + scheduledDate) we already created.
      const q = query(
        collection(db, 'jobs'),
        where('orgId', '==', orgId),
        where('scheduledDate', '>=', Timestamp.fromDate(startDate)),
        where('scheduledDate', '<=', Timestamp.fromDate(endDate)),
        orderBy('scheduledDate', 'asc')
      );

      const unsubscribe = onSnapshot(q, (snapshot) => {
        const jobData = snapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data(),
          scheduledDate: doc.data().scheduledDate?.toDate()
        }));
        setJobs(jobData);
        setLoading(false);
      }, (err) => {
        console.error("Error fetching schedule:", err);
        setError("Failed to load schedule.");
        setLoading(false);
      });

      return () => unsubscribe();
    });
  }, [startDate, endDate]); // Refetch when the date range changes

  return { jobs, loading, error };
};
