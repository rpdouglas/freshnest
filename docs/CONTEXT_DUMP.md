# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Version:** v0.1.1
**Architecture:** Multi-Tenant SaaS.

## 🧠 The "Prime Directive"
We build for **Personas**. Safety > Efficiency.
* **Carla (ODSP):** Never allow over-earning.
* **Mike (Recovery):** Never schedule during meetings.
* **Ahmed (ESL):** Icons over Text.

## Documentation References
* **Schema:** See `docs/SCHEMA_REFERENCE.md`
* **Security:** See `docs/RBAC_MATRIX.md`

## Architecture Rules (STRICT)
1. **NO PLACEHOLDERS:** Complete files only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security:** Use `useProfile` hook to fetch user data. Do NOT use Auth Tokens.
5. **Logic:** * **Profile:** Managed via `ProfileForm.jsx`.
   * **Jobs:** Managed via `useJobs` / `useJobWorkflow`.

## Schema (Implemented)
- **users/{userId}**: 
    - `financials`: { mode: 'cap' | 'unlimited', limit: number }
    - `constraints`: { blockedWindows: ['tue_evening', ...] }
    - `profile`: { transport: 'transit' | 'vehicle' }
- **jobs/{jobId}**: { status, price, scheduledDate, assignedTo: [] }
