import { useState, useEffect } from 'react';
import { 
  collection, query, where, onSnapshot, doc, getDoc 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useStaff = () => {
  const [staff, setStaff] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        // 1. Get Org ID from User Profile
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setLoading(false);
          return;
        }

        const orgId = userDoc.data().orgId;

        if (!orgId) {
          setError("No Organization found.");
          setLoading(false);
          return;
        }

        // 2. Fetch all users in this Org
        const q = query(
          collection(db, 'users'),
          where('orgId', '==', orgId)
        );

        const unsubscribe = onSnapshot(q, (snapshot) => {
          const staffData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
          }));
          setStaff(staffData);
          setLoading(false);
        }, (err) => {
          console.error("Error fetching staff:", err);
          setError("Failed to load staff list.");
          setLoading(false);
        });

        return unsubscribe;

      } catch (err) {
        console.error(err);
        setError("Error initializing staff list.");
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, []);

  return { staff, loading, error };
};
