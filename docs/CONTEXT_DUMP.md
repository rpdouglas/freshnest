# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- **CRITICAL:** `orgId` is stored in the **Firestore User Profile** (`users/{uid}`).

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **invites/{inviteId}**: { email, orgId, role }
- **jobs/{jobId}**: 
    - `assignedTo`: [userId]
    - `status`: 'scheduled' | 'in_progress' | 'completed' | 'cancelled'
    - `startedAt`, `completedAt`, `updatedAt`: Timestamps
    - `price`: Number
- **clients/{clientId}**: { name, address, orgId, email, phone }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId` (Custom Claims) in React Code.** It is stale.
   - **ALWAYS** fetch `users/{uid}` from Firestore to get the current `orgId`.
   - All Firestore queries MUST filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **Date Handling:** Use `date-fns`.
