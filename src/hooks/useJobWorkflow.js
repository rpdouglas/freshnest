import { useState } from 'react';
import { doc, updateDoc, serverTimestamp } from 'firebase/firestore';
import { db, auth } from '../lib/firebase';

export const useJobWorkflow = (job, userRole) => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const userId = auth.currentUser?.uid;

  // --- RBAC PERMISSIONS ---
  const isAdmin = userRole === 'admin';
  const isStaff = userRole === 'staff';
  const isAssigned = job.assignedTo && job.assignedTo.includes(userId);

  // Permission Logic:
  // Admin can edit ANY job.
  // Staff can ONLY edit jobs assigned to them.
  const hasPermission = isAdmin || (isStaff && isAssigned);

  // --- STATUS ACTIONS ---
  
  const startJob = async () => {
    if (!hasPermission) return;
    setLoading(true);
    setError(null);
    try {
      const jobRef = doc(db, 'jobs', job.id);
      await updateDoc(jobRef, {
        status: 'in_progress',
        startedAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      });
    } catch (err) {
      console.error("Error starting job:", err);
      setError("Failed to start job.");
    } finally {
      setLoading(false);
    }
  };

  const completeJob = async () => {
    if (!hasPermission) return;
    setLoading(true);
    setError(null);
    try {
      const jobRef = doc(db, 'jobs', job.id);
      await updateDoc(jobRef, {
        status: 'completed',
        completedAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      });
    } catch (err) {
      console.error("Error completing job:", err);
      setError("Failed to complete job.");
    } finally {
      setLoading(false);
    }
  };

  const cancelJob = async () => {
    // Only Admin can cancel for now
    if (!isAdmin) return; 
    setLoading(true);
    setError(null);
    try {
      const jobRef = doc(db, 'jobs', job.id);
      await updateDoc(jobRef, {
        status: 'cancelled',
        updatedAt: serverTimestamp()
      });
    } catch (err) {
      console.error("Error cancelling job:", err);
      setError("Failed to cancel job.");
    } finally {
      setLoading(false);
    }
  };

  // --- UI FLAGS ---
  const canStart = hasPermission && job.status === 'scheduled';
  const canComplete = hasPermission && job.status === 'in_progress';
  const canCancel = isAdmin && job.status !== 'completed' && job.status !== 'cancelled';

  return {
    startJob,
    completeJob,
    cancelJob,
    canStart,
    canComplete,
    canCancel,
    loading,
    error
  };
};
