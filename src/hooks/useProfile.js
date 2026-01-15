import { useState, useEffect } from 'react';
import { doc, onSnapshot, updateDoc, serverTimestamp } from 'firebase/firestore';
import { auth, db } from '../lib/firebase';

export const useProfile = () => {
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) {
      setLoading(false);
      return;
    }

    // Direct User Doc Reference - Security by Design
    // We do not query collection; we bind strictly to the Auth UID.
    const userDocRef = doc(db, 'users', user.uid);

    const unsubscribe = onSnapshot(userDocRef, (docSnap) => {
      if (docSnap.exists()) {
        setProfile({ id: docSnap.id, ...docSnap.data() });
      } else {
        setError("Profile not found.");
      }
      setLoading(false);
    }, (err) => {
      console.error("Profile Fetch Error:", err);
      setError("Failed to load profile.");
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const updateProfile = async (updates) => {
    const user = auth.currentUser;
    if (!user) throw new Error("Not authenticated");

    setLoading(true);
    try {
      const userDocRef = doc(db, 'users', user.uid);
      
      // Safety: Always append audit fields
      const finalUpdates = {
        ...updates,
        updatedAt: serverTimestamp(),
      };

      await updateDoc(userDocRef, finalUpdates);
      return true;
    } catch (err) {
      console.error("Update Error:", err);
      setError("Failed to save changes.");
      throw err;
    } finally {
      setLoading(false);
    }
  };

  return { profile, loading, error, updateProfile };
};
