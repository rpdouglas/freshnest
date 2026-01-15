import React, { useState } from 'react';
import { Mail, User, Shield, Plus, Loader, UserCog, Building } from 'lucide-react';
import { useStaff } from '../hooks/useStaff';
import { useProfile } from '../hooks/useProfile'; // Check own role
import { auth, db } from '../lib/firebase';
import { collection, addDoc, serverTimestamp, doc, getDoc } from 'firebase/firestore';
import ProfileForm from '../components/settings/ProfileForm';

const SettingsPage = () => {
  const { profile } = useProfile(); // Get current user's role
  const { staff, loading: staffLoading } = useStaff();
  
  const [activeTab, setActiveTab] = useState('profile'); // 'profile' | 'team'
  const [inviteEmail, setInviteEmail] = useState('');
  const [inviteRole, setInviteRole] = useState('staff');
  const [inviteLoading, setInviteLoading] = useState(false);

  const isAdmin = profile?.role === 'admin';

  const handleInvite = async (e) => {
    e.preventDefault();
    setInviteLoading(true);
    try {
      const user = auth.currentUser;
      const orgId = profile.orgId; // Use profile orgId, redundant fetch removed for speed

      await addDoc(collection(db, 'invites'), {
        email: inviteEmail,
        role: inviteRole,
        orgId,
        status: 'pending',
        invitedBy: user.uid,
        createdAt: serverTimestamp()
      });

      alert(`Invite sent to ${inviteEmail}`);
      setInviteEmail('');
    } catch (error) {
      console.error(error);
      alert("Failed to send invite.");
    } finally {
      setInviteLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Settings</h1>
        <p className="text-slate-500 text-sm">Manage your profile and preferences</p>
      </div>

      {/* TAB NAVIGATION */}
      <div className="flex border-b border-gray-200">
        <button
          onClick={() => setActiveTab('profile')}
          className={`flex items-center gap-2 px-6 py-3 font-medium text-sm transition-colors border-b-2 ${
            activeTab === 'profile' 
              ? 'border-brand-600 text-brand-600' 
              : 'border-transparent text-slate-500 hover:text-slate-700'
          }`}
        >
          <UserCog size={18} />
          My Profile
        </button>
        
        {isAdmin && (
          <button
            onClick={() => setActiveTab('team')}
            className={`flex items-center gap-2 px-6 py-3 font-medium text-sm transition-colors border-b-2 ${
              activeTab === 'team' 
                ? 'border-brand-600 text-brand-600' 
                : 'border-transparent text-slate-500 hover:text-slate-700'
            }`}
          >
            <Building size={18} />
            Organization & Team
          </button>
        )}
      </div>

      {/* TAB CONTENT: MY PROFILE */}
      {activeTab === 'profile' && (
        <div className="max-w-2xl">
          <ProfileForm />
        </div>
      )}

      {/* TAB CONTENT: TEAM (Admin Only) */}
      {activeTab === 'team' && isAdmin && (
        <div className="space-y-6 animate-in fade-in duration-300">
          
          {/* Staff List Card */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
              <h3 className="font-bold text-slate-800 flex items-center gap-2">
                <User size={20} className="text-brand-500" />
                Team Members
              </h3>
            </div>
            
            <div className="divide-y divide-gray-100">
              {staffLoading ? (
                <div className="p-6 text-center text-slate-400">Loading staff...</div>
              ) : staff.map((member) => (
                <div key={member.id} className="p-4 flex items-center justify-between hover:bg-gray-50">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-brand-100 rounded-full flex items-center justify-center text-brand-600 font-bold">
                      {(member.email || '?')[0].toUpperCase()}
                    </div>
                    <div>
                      <p className="font-medium text-slate-900">{member.fullName || 'Unnamed User'}</p>
                      <p className="text-xs text-slate-500">{member.email}</p>
                    </div>
                  </div>
                  <span className={`px-2 py-1 rounded text-xs font-bold uppercase ${
                    member.role === 'admin' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700'
                  }`}>
                    {member.role}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Invite Form Card */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 bg-gray-50">
              <h3 className="font-bold text-slate-800 flex items-center gap-2">
                <Mail size={20} className="text-brand-500" />
                Invite New Member
              </h3>
            </div>
            <form onSubmit={handleInvite} className="p-6 flex flex-col md:flex-row gap-4 items-end">
              <div className="flex-1 w-full">
                <label className="block text-sm font-medium text-slate-700 mb-1">Email Address</label>
                <input 
                  type="email" 
                  required
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none"
                  placeholder="colleague@freshnest.com"
                  value={inviteEmail}
                  onChange={(e) => setInviteEmail(e.target.value)}
                />
              </div>
              <div className="w-full md:w-48">
                <label className="block text-sm font-medium text-slate-700 mb-1">Role</label>
                <select 
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:outline-none bg-white"
                  value={inviteRole}
                  onChange={(e) => setInviteRole(e.target.value)}
                >
                  <option value="staff">Staff</option>
                  <option value="admin">Admin</option>
                </select>
              </div>
              <button 
                type="submit" 
                disabled={inviteLoading}
                className="w-full md:w-auto px-6 py-2 bg-brand-600 text-white rounded-lg font-medium hover:bg-brand-700 disabled:opacity-50 flex items-center justify-center gap-2"
              >
                {inviteLoading ? <Loader className="animate-spin" size={18} /> : <Plus size={18} />}
                Send Invite
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default SettingsPage;
