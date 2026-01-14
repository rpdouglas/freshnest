#!/bin/bash

# ====================================================
# FRESH NEST: DOCUMENTATION SYNCHRONIZATION
# Goal: Update all docs to reflect Phase 5 Completion
# ====================================================

echo "📚 Synchronizing Documentation Suite..."

# 1. Create Root README.md (The Front Door)
echo "📝 Creating README.md..."
cat << 'INNER_EOF' > README.md
# 🧹 Fresh Nest

**Fresh Nest** is a Lean SaaS Field Service Management (FSM) platform built for cleaning businesses.
It features Multi-Tenancy, Role-Based Access Control, Geolocation, and Financial Analytics.

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
INNER_EOF

# 2. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 6 - Data Export & Polish
**Last Updated:** $(date +%Y-%m-%d)
**Latest Version:** v0.6.0 (Revenue Dashboard)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding.
* **Jobs:** Scheduling, CRUD, Workflow, Maps.
* **Invoicing:** PDF Generation, Mobile Parity.
* **Dashboard:** Admin KPIs, Revenue Charts, Staff Restrictions.
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Data Export:** CSV export for accounting (Quickbooks/Xero support).
* [ ] **Final Polish:** UX consistency check.
INNER_EOF

# 3. Update RBAC Matrix (Add Dashboard Rules)
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
| **Settings** | Invite User | ✅ | ❌ | |
| **Financials**| See Prices | ✅ | ❌ | Hidden in UI for Staff. |
INNER_EOF

# 4. Update Schema Reference (Add Business Logic)
echo "📝 Updating docs/SCHEMA_REFERENCE.md..."
cat << 'INNER_EOF' > docs/SCHEMA_REFERENCE.md
# 🗄️ Firestore Schema & Business Logic

## 🧠 Business Logic & Calculations

### 1. Revenue Calculation
* **Definition:** Sum of `price` for all jobs where `status === 'completed'`.
* **Constraint:** Jobs that are 'scheduled' or 'in_progress' do NOT count towards revenue.
* **Aggregation:** Performed Client-Side in `useDashboard.js`.

### 2. Job Completion
* **Trigger:** User clicks "Complete Job".
* **Update:** Sets `status: 'completed'` AND `completedAt: serverTimestamp()`.
* **Note:** `completedAt` is used for Monthly Grouping in charts.

---

## 📂 Collection Reference

### `organizations/{orgId}`
* **name** (string): Display name.
* **settings** (map): `{ currency, geoFenceRadius }`.
* **plan** (string): Subscription tier.

### `users/{userId}`
* **email** (string)
* **fullName** (string)
* **orgId** (string): **CRITICAL**. Links user to tenant.
* **role** (string): `'admin'` | `'staff'`.

### `clients/{clientId}`
* **orgId** (string)
* **name** (string)
* **email** (string)
* **phone** (string)
* **address** (string): Text address.
* **coordinates** (map): `{ lat: number, lng: number }`. Used for Maps.

### `jobs/{jobId}`
* **orgId** (string)
* **clientId** (string): Ref to `clients`.
* **assignedTo** (array): List of `userId` strings.
* **status** (string): `'scheduled'` | `'in_progress'` | `'completed'` | `'cancelled'`.
* **serviceType** (string): `'standard'` | `'deep'` | etc.
* **price** (number): Estimated cost.
* **scheduledDate** (timestamp): When the job is.
* **startedAt** (timestamp): When status changed to in_progress.
* **completedAt** (timestamp): Used for Revenue Reports.
* **invoiceNumber** (string): Generated ID (e.g., "2026-4821").
* **invoicedAt** (timestamp): When PDF was generated.
INNER_EOF

# 5. Update Changelog
echo "📝 Updating docs/CHANGELOG.md..."
cat << 'INNER_EOF' > docs/CHANGELOG.md
# 📜 Changelog

## [v0.6.0] - 2026-01-14
### Added
* **Revenue Dashboard:** Admin view with Total Revenue, Jobs Completed, and Avg Ticket KPIs.
* **Visualizations:** Monthly Revenue Bar Chart using `recharts` with horizontal scrolling for mobile.
* **Staff Dashboard:** Restricted view showing only assigned upcoming jobs.
* **Security:** Implemented Client-Side role checks to prevent data leaks.

## [v0.5.1] - 2026-01-12
### Fixed
* **Mobile Invoicing:** Added responsive HTML preview for mobile devices to bypass PDF iframe limitations.
* **UI:** Added "Generate Invoice" button to Mobile Job Card.

## [v0.5.0] - 2026-01-12
### Added
* **Invoicing Module:** Client-side PDF generation using `@react-pdf/renderer`.
* **Tracking:** `invoicedAt` and `invoiceNumber` fields added to Job Schema.
INNER_EOF

# 6. Commit Updates
echo "🌿 Committing Documentation Suite..."
git add README.md docs/
git commit -m "docs: finalize phase 5 revenue dashboard documentation"
git push origin main

echo "✅ Documentation Suite Updated."
