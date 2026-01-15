# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Version:** v0.3.0
**Architecture:** Multi-Tenant SaaS.

## 🧠 The "Prime Directive"
We build for **Personas**. Safety > Efficiency.
* **Carla (ODSP):** Never allow over-earning.
* **Mike (Recovery):** Never schedule during meetings.
* **Ahmed (ESL):** Icons over Text.
* **Brenda (Trust):** Evidence over assumptions.

## Documentation References
* **Schema:** See `docs/SCHEMA_REFERENCE.md`
* **Security:** See `docs/RBAC_MATRIX.md`

## Architecture Rules (STRICT)
1. **NO PLACEHOLDERS:** Complete files only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security:** Use `useProfile` hook to fetch user data. Do NOT use Auth Tokens.
5. **Logic Hooks:** * `useFinancials`: Earning aggregation & Blocking.
   * `useConflictEngine`: Schedule validation (Hard/Soft blocks).
   * `useJobWorkflow`: Status transitions.

## Schema (Implemented)
- **users/{userId}**: { financials, constraints, profile }
- **jobs/{jobId}**: { status, price, scheduledDate, assignedTo }
