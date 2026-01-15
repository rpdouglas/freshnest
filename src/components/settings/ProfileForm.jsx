import React, { useState, useEffect } from 'react';
import { 
  Save, Bus, Car, DollarSign, Calendar, 
  Dumbbell, Languages, AlertCircle, CheckCircle, Loader 
} from 'lucide-react';
import { useProfile } from '../../hooks/useProfile';

const ProfileForm = () => {
  const { profile, loading, updateProfile } = useProfile();
  const [isSaving, setIsSaving] = useState(false);
  const [message, setMessage] = useState(null); // { type: 'success'|'error', text: '' }

  // Local Form State
  const [formData, setFormData] = useState({
    fullName: '',
    phone: '',
    language: 'en',
    transport: 'transit', // Default for Jasmine
    financialMode: 'unlimited',
    financialLimit: '',
    heavyLifting: false,
    blockedWindows: [],
    acceptedTerms: false
  });

  // Hydrate form from Firestore data
  useEffect(() => {
    if (profile) {
      setFormData({
        fullName: profile.fullName || '',
        phone: profile.profile?.phone || '',
        language: profile.profile?.language || 'en',
        transport: profile.profile?.transport || 'transit',
        financialMode: profile.financials?.mode || 'unlimited',
        financialLimit: profile.financials?.limit || '',
        heavyLifting: profile.constraints?.heavyLifting || false,
        blockedWindows: profile.constraints?.blockedWindows || [],
        acceptedTerms: profile.profile?.acceptedTermsVersion === 'v1.0'
      });
    }
  }, [profile]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage(null);
    setIsSaving(true);

    try {
      // 1. Construct Schema-Compliant Object
      const updates = {
        fullName: formData.fullName, // Root level for easy Auth display
        profile: {
          phone: formData.phone,
          language: formData.language,
          transport: formData.transport,
          // Sarah (Compliance): Audit Trail
          acceptedTermsVersion: formData.acceptedTerms ? 'v1.0' : null
        },
        financials: {
          mode: formData.financialMode,
          limit: formData.financialMode === 'cap' ? Number(formData.financialLimit) : null
        },
        constraints: {
          heavyLifting: formData.heavyLifting,
          blockedWindows: formData.blockedWindows
        }
      };

      await updateProfile(updates);
      setMessage({ type: 'success', text: 'Profile updated successfully!' });
      
      // Clear success message after 3s
      setTimeout(() => setMessage(null), 3000);
    } catch (err) {
      setMessage({ type: 'error', text: 'Failed to save profile. Try again.' });
    } finally {
      setIsSaving(false);
    }
  };

  const toggleWindow = (windowId) => {
    setFormData(prev => {
      const current = prev.blockedWindows;
      if (current.includes(windowId)) {
        return { ...prev, blockedWindows: current.filter(id => id !== windowId) };
      } else {
        return { ...prev, blockedWindows: [...current, windowId] };
      }
    });
  };

  if (loading) return <div className="p-8 text-center text-slate-400">Loading profile...</div>;

  return (
    <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      
      {/* Header */}
      <div className="px-6 py-4 border-b border-gray-100 bg-slate-50 flex justify-between items-center">
        <div>
          <h2 className="text-lg font-bold text-slate-800">My Worker Profile</h2>
          <p className="text-xs text-slate-500">Manage your capabilities & limits</p>
        </div>
        {/* Ahmed: Visual Language Toggle Placeholder */}
        <div className="flex gap-2">
          <button 
            type="button" 
            onClick={() => setFormData({...formData, language: 'en'})}
            className={`text-xs px-2 py-1 rounded font-bold ${formData.language === 'en' ? 'bg-slate-800 text-white' : 'bg-white text-slate-400 border'}`}
          >EN</button>
          <button 
            type="button" 
            onClick={() => setFormData({...formData, language: 'fr'})}
            className={`text-xs px-2 py-1 rounded font-bold ${formData.language === 'fr' ? 'bg-brand-600 text-white' : 'bg-white text-slate-400 border'}`}
          >FR</button>
        </div>
      </div>

      <div className="p-6 space-y-8">
        
        {/* SECTION 1: IDENTITY */}
        <div className="space-y-4">
          <label className="block text-sm font-bold text-slate-700 uppercase tracking-wide">
            Identity
          </label>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <span className="text-xs text-slate-500 mb-1 block">Full Name</span>
              <input 
                type="text" 
                required
                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 outline-none"
                value={formData.fullName}
                onChange={e => setFormData({...formData, fullName: e.target.value})}
              />
            </div>
            <div>
              <span className="text-xs text-slate-500 mb-1 block">Phone Number</span>
              <input 
                type="tel" 
                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 outline-none"
                placeholder="(555) 123-4567"
                value={formData.phone}
                onChange={e => setFormData({...formData, phone: e.target.value})}
              />
            </div>
          </div>
        </div>

        <hr className="border-slate-100" />

        {/* SECTION 2: TRANSPORT (Jasmine) */}
        <div>
          <label className="flex items-center gap-2 text-sm font-bold text-slate-700 uppercase tracking-wide mb-3">
            <Bus size={18} className="text-brand-500" /> Transport Mode
          </label>
          <div className="grid grid-cols-2 gap-4">
            <button
              type="button"
              onClick={() => setFormData({...formData, transport: 'transit'})}
              className={`p-4 rounded-xl border-2 flex flex-col items-center gap-2 transition-all ${
                formData.transport === 'transit' 
                  ? 'border-brand-500 bg-brand-50 text-brand-700' 
                  : 'border-slate-200 hover:border-slate-300 text-slate-500'
              }`}
            >
              <Bus size={32} />
              <span className="font-bold">Public Transit</span>
            </button>
            <button
              type="button"
              onClick={() => setFormData({...formData, transport: 'vehicle'})}
              className={`p-4 rounded-xl border-2 flex flex-col items-center gap-2 transition-all ${
                formData.transport === 'vehicle' 
                  ? 'border-brand-500 bg-brand-50 text-brand-700' 
                  : 'border-slate-200 hover:border-slate-300 text-slate-500'
              }`}
            >
              <Car size={32} />
              <span className="font-bold">Personal Vehicle</span>
            </button>
          </div>
          {formData.transport === 'transit' && (
            <p className="text-xs text-slate-500 mt-2 bg-slate-50 p-2 rounded">
              ℹ️ We will add 30-min travel buffers to your schedule automatically.
            </p>
          )}
        </div>

        <hr className="border-slate-100" />

        {/* SECTION 3: FINANCIALS (Carla) */}
        <div>
          <label className="flex items-center gap-2 text-sm font-bold text-slate-700 uppercase tracking-wide mb-3">
            <DollarSign size={18} className="text-green-600" /> Financial Safety
          </label>
          
          <div className="bg-orange-50 border border-orange-100 rounded-lg p-4 mb-4">
            <div className="flex items-start gap-3">
              <input 
                type="radio" 
                id="fin_cap"
                name="fin_mode"
                checked={formData.financialMode === 'cap'}
                onChange={() => setFormData({...formData, financialMode: 'cap'})}
                className="mt-1 w-4 h-4 text-brand-600"
              />
              <div className="flex-1">
                <label htmlFor="fin_cap" className="font-bold text-slate-800 block">
                  Strict Earning Cap (ODSP/Support)
                </label>
                <p className="text-xs text-slate-600 mb-2">
                  Stop assigning me work once I reach a monthly limit.
                </p>
                {formData.financialMode === 'cap' && (
                  <div className="relative max-w-[200px]">
                    <span className="absolute left-3 top-2.5 text-slate-500">$</span>
                    <input 
                      type="number" 
                      placeholder="1000.00"
                      className="w-full pl-7 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 outline-none"
                      value={formData.financialLimit}
                      onChange={e => setFormData({...formData, financialLimit: e.target.value})}
                    />
                  </div>
                )}
              </div>
            </div>
          </div>

          <div className="flex items-start gap-3 p-4 rounded-lg border border-slate-100">
            <input 
              type="radio" 
              id="fin_unlimited"
              name="fin_mode"
              checked={formData.financialMode === 'unlimited'}
              onChange={() => setFormData({...formData, financialMode: 'unlimited'})}
              className="mt-1 w-4 h-4 text-brand-600"
            />
            <div>
              <label htmlFor="fin_unlimited" className="font-bold text-slate-800 block">
                Unlimited Earnings
              </label>
              <p className="text-xs text-slate-500">I have no restrictions on income.</p>
            </div>
          </div>
        </div>

        <hr className="border-slate-100" />

        {/* SECTION 4: CONSTRAINTS (Mike) */}
        <div>
          <label className="flex items-center gap-2 text-sm font-bold text-slate-700 uppercase tracking-wide mb-3">
            <Calendar size={18} className="text-purple-600" /> Unavailability
          </label>
          <p className="text-xs text-slate-500 mb-3">Select recurring times you CANNOT work (e.g. meetings, appointments).</p>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            {[
              { id: 'tue_evening', label: 'Tue Evening', sub: '7pm - 10pm' },
              { id: 'thu_evening', label: 'Thu Evening', sub: '7pm - 10pm' },
              { id: 'sat_morning', label: 'Sat Morning', sub: '8am - 12pm' },
              { id: 'sun_allday',  label: 'Sunday', sub: 'All Day' },
            ].map(window => (
              <button
                key={window.id}
                type="button"
                onClick={() => toggleWindow(window.id)}
                className={`p-3 rounded-lg border text-left transition-all ${
                  formData.blockedWindows.includes(window.id)
                    ? 'bg-red-50 border-red-200' 
                    : 'bg-white border-slate-200 hover:border-slate-300'
                }`}
              >
                <div className="flex justify-between items-start">
                  <span className={`font-bold text-sm ${formData.blockedWindows.includes(window.id) ? 'text-red-700' : 'text-slate-700'}`}>
                    {window.label}
                  </span>
                  {formData.blockedWindows.includes(window.id) && <CheckCircle size={14} className="text-red-600" />}
                </div>
                <span className="text-xs text-slate-400 block mt-1">{window.sub}</span>
              </button>
            ))}
          </div>
        </div>

        {/* SECTION 5: CAPABILITIES */}
        <div className="flex items-center justify-between p-4 bg-slate-50 rounded-xl border border-slate-200">
          <div className="flex items-center gap-3">
            <div className="bg-white p-2 rounded-full border border-slate-200">
              <Dumbbell size={20} className="text-slate-600" />
            </div>
            <div>
              <span className="font-bold text-slate-800 block">Heavy Lifting OK?</span>
              <span className="text-xs text-slate-500">Can lift 50lbs+ (Deep Cleans)</span>
            </div>
          </div>
          <div className="relative inline-block w-12 mr-2 align-middle select-none transition duration-200 ease-in">
            <input 
              type="checkbox" 
              name="heavy" 
              id="heavy" 
              checked={formData.heavyLifting}
              onChange={e => setFormData({...formData, heavyLifting: e.target.checked})}
              className="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-4 appearance-none cursor-pointer checked:right-0 checked:border-green-400"
              style={{ right: formData.heavyLifting ? '0' : 'auto', left: formData.heavyLifting ? 'auto' : '0' }}
            />
            <label htmlFor="heavy" className={`toggle-label block overflow-hidden h-6 rounded-full cursor-pointer ${formData.heavyLifting ? 'bg-green-400' : 'bg-slate-300'}`}></label>
          </div>
        </div>

      </div>

      {/* FOOTER & ACTIONS */}
      <div className="p-6 bg-slate-50 border-t border-gray-100">
        
        <div className="mb-4 flex items-start gap-2">
          <input 
            type="checkbox" 
            id="terms" 
            required
            checked={formData.acceptedTerms}
            onChange={e => setFormData({...formData, acceptedTerms: e.target.checked})}
            className="mt-1 w-4 h-4 text-brand-600 rounded"
          />
          <label htmlFor="terms" className="text-xs text-slate-600 leading-tight">
            I confirm these details are accurate. I understand that falsifying my earning limits may result in schedule conflicts. <span className="font-bold text-brand-600">(Terms v1.0)</span>
          </label>
        </div>

        {message && (
          <div className={`mb-4 p-3 rounded-lg flex items-center gap-2 text-sm ${
            message.type === 'success' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
          }`}>
            {message.type === 'success' ? <CheckCircle size={16} /> : <AlertCircle size={16} />}
            {message.text}
          </div>
        )}

        <button 
          type="submit" 
          disabled={isSaving || !formData.acceptedTerms}
          className="w-full bg-brand-600 text-white py-3 rounded-xl font-bold hover:bg-brand-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 transition-all shadow-md active:scale-95"
        >
          {isSaving ? <Loader className="animate-spin" size={20} /> : <Save size={20} />}
          Save Profile
        </button>
      </div>
    </form>
  );
};

export default ProfileForm;
