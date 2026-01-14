# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.

## Documentation References
* **Schema:** See `docs/SCHEMA_REFERENCE.md`
* **Security/RBAC:** See `docs/RBAC_MATRIX.md`
* **DevOps:** See `docs/DEVOPS_MANUAL.md`

## Architecture Rules (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId`.** Fetch `users/{uid}`.
   - All queries must filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **State Management:**
   - Prefer deriving state from lists (e.g. `jobs.find(id)`) over storing object snapshots.
6. **Analytics & Export:**
   - **Charts:** Use `recharts` (Client-side aggregation).
   - **CSV Export:** Use `src/lib/csv.js` (Custom utility). Do NOT install `papaparse`.
   - **PDF:** Use `@react-pdf/renderer` inside `InvoiceModal`.
