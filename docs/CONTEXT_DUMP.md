# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **jobs/{jobId}**: 
    - `assignedTo`: [userId]
    - `status`: 'scheduled' | 'in_progress' | 'completed' | 'cancelled'
    - `startedAt`, `completedAt`: Timestamps
- **clients/{clientId}**: 
    - `coordinates`: { lat: number, lng: number }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId`.** Fetch `users/{uid}` from Firestore.
   - All queries must filter by `.where("orgId", "==", currentOrgId)`.
5. **Environment Variables:**
   - ALWAYS use `import.meta.env.VITE_...` (Vite standard).
   - NEVER use `process.env` in frontend code.
