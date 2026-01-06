import { useState, useEffect } from 'react';
import { 
  collection, 
  query, 
  where, 
  onSnapshot, 
  addDoc, 
  serverTimestamp,
  orderBy 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useClients = () => {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    // Get the orgId from the token claims (stored in local state or refetch)
    // For now, we assume the user object is hydrated or we fetch the token result.
    // In a robust app, we'd use a generic AuthContext, but here we access the ID token.
    user.getIdTokenResult().then((idTokenResult) => {
      const orgId = idTokenResult.claims.orgId;

      if (!orgId) {
        setError("Organization ID missing from user profile.");
        setLoading(false);
        return;
      }

      // SECURITY: Subscribe ONLY to clients in this user's Org
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

      return () => unsubscribe();
    });
  }, []);

  const addClient = async (clientData) => {
    const user = auth.currentUser;
    if (!user) throw new Error("Not authenticated");

    const idTokenResult = await user.getIdTokenResult();
    const orgId = idTokenResult.claims.orgId;

    if (!orgId) throw new Error("No Organization ID found.");

    // SECURITY: Force attach orgId and server timestamp
    await addDoc(collection(db, 'clients'), {
      ...clientData,
      orgId, 
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    });
  };

  return { clients, loading, error, addClient };
};
