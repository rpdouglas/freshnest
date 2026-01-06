# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore, Functions) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- User has `orgId` in Custom Claims.
- "fresh-nest-dev" Firestore is active.
- `AppLayout` is generic.

## Schema (Implemented)
- **organizations/{orgId}**: { name, plan, settings }
- **users/{userId}**: { email, orgId, role, fullName }

## Rules for AI
1. ALL code must be provided as COMPLETE FILES.
2. Use `lucide-react` for icons.
3. Tailwind Colors: `bg-brand-500` (Primary), `bg-slate-800` (Sidebar).
4. Security: All Firestore queries MUST filter by `where("orgId", "==", user.orgId)`.