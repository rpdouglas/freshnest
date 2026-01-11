import { useState, useEffect } from 'react';
import { 
  collection, 
  query, 
  where, 
  onSnapshot, 
  addDoc, 
  serverTimestamp, 
  orderBy,
  doc,
  getDoc
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useClients = () => {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentOrgId, setCurrentOrgId] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    const fetchOrgAndSubscribe = async () => {
      try {
        // 1. Fetch User Profile to get the REAL OrgId (Source of Truth)
        const userDocRef = doc(db, 'users', user.uid);
        const userDoc = await getDoc(userDocRef);
        
        if (!userDoc.exists()) {
          setError("User profile not found.");
          setLoading(false);
          return;
        }

        const orgId = userDoc.data().orgId;
        setCurrentOrgId(orgId);

        if (!orgId) {
          setError("Organization ID missing from user profile.");
          setLoading(false);
          return;
        }

        // 2. Subscribe ONLY to clients in this user's Org
        const q = query(
          collection(db, 'clients'),
          where('orgId', '==', orgId),
          orderBy('createdAt', 'desc')
        );

        const unsubscribe = onSnapshot(q, (snapshot) => {
          const clientData = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
          }));
          setClients(clientData);
          setLoading(false);
        }, (err) => {
          console.error("Error fetching clients:", err);
          setError("Failed to load clients.");
          setLoading(false);
        });

        return unsubscribe;

      } catch (err) {
        console.error(err);
        setError("Error initializing client list.");
        setLoading(false);
      }
    };

    const unsubscribePromise = fetchOrgAndSubscribe();
    return () => { unsubscribePromise.then(unsub => unsub && unsub()); };
  }, []);

  const addClient = async (clientData) => {
    if (!currentOrgId) throw new Error("No Organization ID found.");

    // SECURITY: Force attach orgId and server timestamp
    await addDoc(collection(db, 'clients'), {
      ...clientData,
      orgId: currentOrgId, 
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    });
  };

  return { clients, loading, error, addClient };
};
