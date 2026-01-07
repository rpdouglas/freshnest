# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- **CRITICAL:** `orgId` is stored in the **Firestore User Profile** (`users/{uid}`), NOT in Custom Claims.
- "fresh-nest-dev" Firestore is active.

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **invites/{inviteId}**: { email, orgId, role }

## Rules for AI
1. ALL code must be provided as COMPLETE FILES.
2. Use `lucide-react` for icons.
3. Tailwind Colors: `bg-brand-500` (Primary), `bg-slate-800` (Sidebar).
4. **Security & Data Access:**
   - **NEVER** attempt to read `request.auth.token.orgId`. It does not exist.
   - **ALWAYS** fetch the user's Firestore profile to get their `orgId`.
   - All Firestore queries MUST filter by `.where("orgId", "==", currentOrgId)`.
