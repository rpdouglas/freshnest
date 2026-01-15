# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Version:** v0.4.0
**Architecture:** Multi-Tenant SaaS.

## 🧠 The "Prime Directive"
We build for **Personas**. Safety > Efficiency.
* **Ahmed (ESL):** Icons over Text. (Work Mode)
* **Brenda (Trust):** Evidence over assumptions. (Evidence Locker)
* **Carla (ODSP):** Financial Safety.
* **Mike/Jasmine:** Scheduling Safety.

## Architecture Rules (STRICT)
1. **Mobile First:** Tailwind classes must be `block md:flex`.
2. **Security:** Use `useProfile` hook to fetch user data.
3. **Logic Hooks:** * `useFieldWork`: Manages Checklists & Evidence.
   * `useFinancials`: Earning aggregation.
   * `useConflictEngine`: Schedule validation.

## Schema (Implemented)
- **users/{userId}**: { financials, constraints, profile }
- **jobs/{jobId}**: 
    - `tasks`: Array (Checklist state)
    - `evidence`: Array (Photo URLs)
    - `status`, `price`, `scheduledDate`, `assignedTo`
