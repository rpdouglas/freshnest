import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, orderBy, Timestamp, doc, getDoc 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useSchedule = (startDate, endDate) => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [userRole, setUserRole] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user || !startDate || !endDate) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setLoading(false);
          return;
        }

        const userData = userDoc.data();
        const orgId = userData.orgId;
        const role = userData.role;
        setUserRole(role);

        if (!orgId) {
          setError("Organization ID missing.");
          setLoading(false);
          return;
        }

        // Base Constraints
        let constraints = [
          where('orgId', '==', orgId),
          where('scheduledDate', '>=', Timestamp.fromDate(startDate)),
          where('scheduledDate', '<=', Timestamp.fromDate(endDate)),
          orderBy('scheduledDate', 'asc')
        ];

        // RBAC: Staff Filter
        if (role === 'staff') {
          constraints.push(where('assignedTo', 'array-contains', user.uid));
        }

        const q = query(collection(db, 'jobs'), ...constraints);

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

        return unsubscribe;
      } catch (err) {
        console.error(err);
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, [startDate, endDate]); 

  return { jobs, loading, error, role: userRole };
};
