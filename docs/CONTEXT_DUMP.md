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
5. **Analytics Strategy:**
   - **Client-Side Aggregation:** Fetch raw jobs via `useDashboard` and calculate totals in JS (reduce/map).
   - **Visualization:** Use `recharts` for graphs. Ensure horizontal scrolling on mobile.
6. **PDF Generation:**
   - Desktop: `PDFViewer` (iframe).
   - Mobile: `InvoiceHTMLPreview` (HTML/CSS) + Download Link.
