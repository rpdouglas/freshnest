import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, addDoc, updateDoc, deleteDoc, 
  serverTimestamp, orderBy, Timestamp, doc, getDoc 
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

        // Constraints
        let constraints = [
          where('orgId', '==', orgId),
          orderBy('scheduledDate', 'asc')
        ];

        if (role === 'staff') {
          constraints.push(where('assignedTo', 'array-contains', user.uid));
        }

        const q = query(collection(db, 'jobs'), ...constraints);

        return onSnapshot(q, (snapshot) => {
          const jobData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            scheduledDate: doc.data().scheduledDate?.toDate(),
            invoicedAt: doc.data().invoicedAt?.toDate()
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

  // --- MUTATIONS ---

  const addJob = async (jobData) => {
    if (!currentOrgId) throw new Error("No Org ID.");
    if (userRole !== 'admin') throw new Error("Unauthorized.");

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

  const updateJob = async (jobId, jobData) => {
    if (userRole !== 'admin') throw new Error("Unauthorized.");

    const timestampDate = new Date(jobData.scheduledDate);
    const assignedTo = jobData.assignedStaffId ? [jobData.assignedStaffId] : [];

    const jobRef = doc(db, 'jobs', jobId);
    await updateDoc(jobRef, {
      clientId: jobData.clientId,
      serviceType: jobData.serviceType,
      price: Number(jobData.price),
      notes: jobData.notes,
      assignedTo: assignedTo,
      scheduledDate: Timestamp.fromDate(timestampDate),
      updatedAt: serverTimestamp()
    });
  };

  const deleteJob = async (jobId) => {
    if (userRole !== 'admin') throw new Error("Unauthorized.");
    const jobRef = doc(db, 'jobs', jobId);
    await deleteDoc(jobRef);
  };

  const markAsInvoiced = async (jobId) => {
    if (userRole !== 'admin') throw new Error("Unauthorized.");
    
    // Simple ID gen: Year + Random 4 digits (e.g. 2026-4821)
    const invoiceNumber = `${new Date().getFullYear()}-${Math.floor(1000 + Math.random() * 9000)}`;
    
    const jobRef = doc(db, 'jobs', jobId);
    await updateDoc(jobRef, {
      invoicedAt: serverTimestamp(),
      invoiceNumber: invoiceNumber,
      updatedAt: serverTimestamp()
    });
  };

  return { jobs, loading, error, addJob, updateJob, deleteJob, markAsInvoiced, role: userRole };
};
