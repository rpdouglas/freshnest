import { useState, useEffect, useMemo } from 'react';
import { 
  collection, query, where, onSnapshot, orderBy, doc, getDoc, limit 
} from 'firebase/firestore';
import { auth, db } from '../lib/firebase';
import { format, startOfMonth, subMonths, isSameMonth } from 'date-fns';

export const useDashboard = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState({
    totalRevenue: 0,
    jobsCompleted: 0,
    avgTicket: 0,
    revenueByMonth: [],
    recentActivity: []
  });
  const [role, setRole] = useState(null);

  useEffect(() => {
    const user = auth.currentUser;
    if (!user) return;

    const init = async () => {
      try {
        // 1. Get Role & Org
        const userDoc = await getDoc(doc(db, 'users', user.uid));
        if (!userDoc.exists()) throw new Error("User profile not found");
        
        const { orgId, role: userRole } = userDoc.data();
        setRole(userRole);

        if (!orgId) throw new Error("No Org ID");

        // 2. Define Query based on Role
        let q;
        if (userRole === 'admin') {
          // Admin: Get all jobs for calculation (Limit to 500 for MVP safety)
          q = query(
            collection(db, 'jobs'),
            where('orgId', '==', orgId),
            orderBy('scheduledDate', 'desc'),
            limit(500)
          );
        } else {
          // Staff: Only get their recent jobs
          q = query(
            collection(db, 'jobs'),
            where('orgId', '==', orgId),
            where('assignedTo', 'array-contains', user.uid),
            orderBy('scheduledDate', 'desc'),
            limit(10)
          );
        }

        // 3. Real-time Listener
        const unsubscribe = onSnapshot(q, (snapshot) => {
          const jobs = snapshot.docs.map(d => ({ 
            id: d.id, 
            ...d.data(),
            scheduledDate: d.data().scheduledDate?.toDate(),
            completedAt: d.data().completedAt?.toDate()
          }));

          if (userRole === 'admin') {
            processAdminStats(jobs);
          } else {
            processStaffStats(jobs);
          }
          setLoading(false);
        }, (err) => {
          console.error(err);
          setError("Failed to load dashboard data.");
          setLoading(false);
        });

        return unsubscribe;

      } catch (err) {
        console.error(err);
        setError(err.message);
        setLoading(false);
      }
    };

    const unsubPromise = init();
    return () => { unsubPromise && unsubPromise.then(fn => fn && fn()); };
  }, []);

  // --- Aggregation Logic (Admin) ---
  const processAdminStats = (jobs) => {
    const completedJobs = jobs.filter(j => j.status === 'completed');
    
    // KPI: Totals
    const totalRevenue = completedJobs.reduce((sum, job) => sum + (Number(job.price) || 0), 0);
    const jobsCompleted = completedJobs.length;
    const avgTicket = jobsCompleted > 0 ? totalRevenue / jobsCompleted : 0;

    // Chart: Last 6 Months
    const last6Months = Array.from({ length: 6 }).map((_, i) => {
      const d = subMonths(new Date(), i); // 0 = this month, 1 = last month
      return {
        date: d,
        label: format(d, 'MMM'),
        revenue: 0
      };
    }).reverse();

    completedJobs.forEach(job => {
      if (!job.completedAt) return;
      const monthBucket = last6Months.find(m => isSameMonth(m.date, job.completedAt));
      if (monthBucket) {
        monthBucket.revenue += (Number(job.price) || 0);
      }
    });

    setStats({
      totalRevenue,
      jobsCompleted,
      avgTicket,
      revenueByMonth: last6Months,
      recentActivity: jobs.slice(0, 5) // Last 5 jobs regardless of status
    });
  };

  // --- Aggregation Logic (Staff) ---
  const processStaffStats = (jobs) => {
    // Simple list for staff
    setStats({
      recentActivity: jobs
    });
  };

  return { stats, role, loading, error };
};
