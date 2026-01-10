import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, addDoc, serverTimestamp, orderBy, Timestamp, doc, getDoc 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useJobs = () => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentOrgId, setCurrentOrgId] = useState(null);
  const [userRole, setUserRole] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        // 1. Fetch User Profile to get OrgId AND Role
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setLoading(false);
          return;
        }

        const userData = userDoc.data();
        const orgId = userData.orgId;
        const role = userData.role;

        setCurrentOrgId(orgId);
        setUserRole(role);

        if (!orgId) {
          setError("Organization ID missing.");
          setLoading(false);
          return;
        }

        // 2. Construct Query based on Role
        let constraints = [
          where('orgId', '==', orgId),
          orderBy('scheduledDate', 'asc')
        ];

        // RBAC: If staff, ONLY show jobs assigned to them
        if (role === 'staff') {
          constraints.push(where('assignedTo', 'array-contains', user.uid));
        }

        const q = query(collection(db, 'jobs'), ...constraints);

        return onSnapshot(q, (snapshot) => {
          const jobData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            scheduledDate: doc.data().scheduledDate?.toDate()
          }));
          setJobs(jobData);
          setLoading(false);
        }, (err) => {
          console.error("Error fetching jobs:", err);
          setError("Failed to load jobs.");
          setLoading(false);
        });
      } catch (err) {
        console.error(err);
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, []);

  const addJob = async (jobData) => {
    if (!currentOrgId) throw new Error("No Organization ID found.");

    const timestampDate = new Date(jobData.scheduledDate);
    const assignedTo = jobData.assignedStaffId ? [jobData.assignedStaffId] : [];

    await addDoc(collection(db, 'jobs'), {
      clientId: jobData.clientId,
      serviceType: jobData.serviceType,
      price: Number(jobData.price),
      notes: jobData.notes,
      assignedTo: assignedTo,
      status: 'scheduled',
      scheduledDate: Timestamp.fromDate(timestampDate),
      orgId: currentOrgId, 
      createdAt: serverTimestamp(),
      createdBy: auth.currentUser.uid
    });
  };

  return { jobs, loading, error, addJob, role: userRole };
};
