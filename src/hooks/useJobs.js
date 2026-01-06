import { useState, useEffect } from 'react';
import { 
  collection, 
  query, 
  where, 
  onSnapshot, 
  addDoc, 
  serverTimestamp,
  orderBy,
  Timestamp 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useJobs = () => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
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

      // SECURITY: Filter by orgId
      // Note: This requires a composite index (orgId + scheduledDate)
      const q = query(
        collection(db, 'jobs'),
        where('orgId', '==', orgId),
        orderBy('scheduledDate', 'asc')
      );

      const unsubscribe = onSnapshot(q, (snapshot) => {
        const jobData = snapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data(),
          // Convert Firestore Timestamp to JS Date for easier UI handling
          scheduledDate: doc.data().scheduledDate?.toDate()
        }));
        setJobs(jobData);
        setLoading(false);
      }, (err) => {
        console.error("Error fetching jobs:", err);
        setError("Failed to load jobs. (Check console for Index link)");
        setLoading(false);
      });

      return () => unsubscribe();
    });
  }, []);

  const addJob = async (jobData) => {
    const user = auth.currentUser;
    if (!user) throw new Error("Not authenticated");

    const idTokenResult = await user.getIdTokenResult();
    const orgId = idTokenResult.claims.orgId;

    if (!orgId) throw new Error("No Organization ID found.");

    // Convert string date (from input) to Firestore Timestamp
    const timestampDate = new Date(jobData.scheduledDate);

    await addDoc(collection(db, 'jobs'), {
      clientId: jobData.clientId,
      serviceType: jobData.serviceType,
      price: Number(jobData.price),
      notes: jobData.notes,
      status: 'scheduled', // Default status
      scheduledDate: Timestamp.fromDate(timestampDate),
      orgId, 
      createdAt: serverTimestamp(),
      createdBy: user.uid
    });
  };

  return { jobs, loading, error, addJob };
};
