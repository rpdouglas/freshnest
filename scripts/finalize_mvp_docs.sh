#!/bin/bash

# ====================================================
# FRESH NEST: FINAL MVP DOCUMENTATION SYNC
# Goal: Mark project as v1.0.0 and document Export
# ====================================================

echo "📚 Finalizing Documentation for v1.0.0 Release..."

# 1. Update Root README (Feature Complete)
echo "📝 Updating README.md..."
cat << 'INNER_EOF' > README.md
# 🧹 Fresh Nest

**Fresh Nest** is a Lean SaaS Field Service Management (FSM) platform built for cleaning businesses.
It features Multi-Tenancy, Role-Based Access Control, Geolocation, Financial Analytics, and Data Export.

## 🚀 Quick Start

1. **Install Dependencies:**
   \`npm install\`

2. **Environment Setup:**
   Ensure you have \`.env.development\` with valid Firebase & Google Maps Keys.

3. **Run Local Dev:**
   \`npm run dev\`

## 📂 Documentation Index

* **[Project Status](./docs/PROJECT_STATUS.md):** Current phase and roadmap.
* **[DevOps Manual](./docs/DEVOPS_MANUAL.md):** CI/CD, Secrets, and Infrastructure.
* **[Context Dump](./docs/CONTEXT_DUMP.md):** High-level architecture rules for AI.
* **[RBAC Matrix](./docs/RBAC_MATRIX.md):** Security permissions reference.
* **[Schema Reference](./docs/SCHEMA_REFERENCE.md):** Firestore data model & Business Logic.

## 🏗️ Architecture
* **Frontend:** React + Vite + Tailwind CSS
* **Backend:** Firebase (Auth, Firestore, Functions)
* **Maps:** Google Maps Javascript API
* **Invoicing:** @react-pdf/renderer (Client-side)
* **Analytics:** Recharts (Client-side aggregation)
* **Export:** Custom CSV Utility (No heavy dependencies)
INNER_EOF

# 2. Update Project Status (The Big Milestone)
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** ✅ MVP Complete (Maintenance Mode)
**Last Updated:** $(date +%Y-%m-%d)
**Latest Version:** v1.0.0

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding.
* **Jobs:** Scheduling, CRUD, Workflow, Maps.
* **Invoicing:** PDF Generation, Mobile Parity.
* **Dashboard:** Admin KPIs, Revenue Charts, Staff Restrictions.
* **Data Export:** CSV downloads for Clients and Jobs (Admin only).
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 Future Roadmap (Post-MVP)
* [ ] **Email Notifications:** Send invoices via SendGrid/Postmark.
* [ ] **Client Portal:** Allow clients to book their own slots.
* [ ] **Subscription Billing:** Stripe integration for SaaS fees.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: { invoiceNumber, invoicedAt, price, status, ... }
* `clients/{clientId}`: { name, address, coordinates, ... }
INNER_EOF

# 3. Update RBAC Matrix (Add Export)
echo "📝 Updating docs/RBAC_MATRIX.md..."
cat << 'INNER_EOF' > docs/RBAC_MATRIX.md
# 🛡️ Role-Based Access Control (RBAC) Matrix

**Roles:** `admin` (Owner), `staff` (Worker)
**Enforcement:** 1. **Frontend:** UI Hiding via `useJobWorkflow` / `userRole`.
2. **Backend:** Firestore Security Rules (checks `resource.data.orgId`).

| Feature | Action | Admin | Staff | Notes |
| :--- | :--- | :---: | :---: | :--- |
| **Dashboard** | View KPIs | ✅ | ❌ | Revenue, Avg Ticket, Total Jobs. |
| | View Charts | ✅ | ❌ | Monthly Revenue Trends. |
| | View "My Jobs"| ✅ | ✅ | Staff see their assigned list. |
| **Clients** | View List | ✅ | ✅ | Staff see all clients in Org. |
| | Create/Edit | ✅ | ❌ | |
| **Jobs** | View List | ✅ | ⚠️ | Staff only see *assigned* jobs. |
| | Create Job | ✅ | ❌ | |
| | Edit Details | ✅ | ❌ | Price, Notes, Service Type. |
| | Start Job | ✅ | ✅ | Only if assigned (Staff). |
| | Complete Job | ✅ | ✅ | Only if assigned (Staff). |
| | Cancel Job | ✅ | ❌ | |
| | Delete Job | ✅ | ❌ | |
| **Invoicing** | Generate | ✅ | ❌ | |
| **Data Export** | Download CSV | ✅ | ❌ | Prevent data theft. |
| **Settings** | Invite User | ✅ | ❌ | |
| **Financials**| See Prices | ✅ | ❌ | Hidden in UI for Staff. |
INNER_EOF

# 4. Update Context Dump (Add CSV Rule)
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
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
INNER_EOF

# 5. Update Changelog
echo "📝 Updating docs/CHANGELOG.md..."
cat << 'INNER_EOF' > docs/CHANGELOG.md
# 📜 Changelog

## [v1.0.0] - 2026-01-14 (MVP Gold Master)
### Added
* **Data Export:** Admins can now export Client and Job lists to CSV using a custom robust utility.
* **Security:** Role-based restrictions applied to Export buttons (Admin only).
* **Mobile Parity:** Export buttons hidden on mobile to preserve UI density.

## [v0.6.0] - 2026-01-14
### Added
* **Revenue Dashboard:** Admin view with Total Revenue, Jobs Completed, and Avg Ticket KPIs.
* **Visualizations:** Monthly Revenue Bar Chart using `recharts`.
* **Staff Dashboard:** Restricted view showing only assigned upcoming jobs.

## [v0.5.1] - 2026-01-12
### Fixed
* **Mobile Invoicing:** Added responsive HTML preview for mobile devices.

## [v0.5.0] - 2026-01-12
### Added
* **Invoicing Module:** Client-side PDF generation.
INNER_EOF

# 6. Commit Updates
echo "🌿 Committing Documentation Suite..."
git add README.md docs/
git commit -m "docs: finalize v1.0.0 mvp documentation"
git push origin main

echo "🎉 Documentation Updated. Fresh Nest is officially v1.0.0!"
