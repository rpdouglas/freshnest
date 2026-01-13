#!/bin/bash

echo "📚 Upgrading Documentation Architecture..."

# 1. Create Root README.md
# The standard entry point for any developer (or you, 6 months from now)
echo "📝 Creating README.md..."
cat << 'INNER_EOF' > README.md
# 🧹 Fresh Nest

**Fresh Nest** is a Lean SaaS Field Service Management (FSM) platform for cleaning businesses.
It features Multi-Tenancy, Role-Based Access Control, Geolocation, and Invoicing.

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
* **[Schema Reference](./docs/SCHEMA_REFERENCE.md):** Firestore data model.

## 🏗️ Architecture
* **Frontend:** React + Vite + Tailwind CSS
* **Backend:** Firebase (Auth, Firestore, Functions)
* **Maps:** Google Maps Javascript API
* **Invoicing:** @react-pdf/renderer (Client-side generation)

INNER_EOF

# 2. Create RBAC_MATRIX.md
# Explains the specific permissions implemented in useJobWorkflow and Security Rules
echo "📝 Creating docs/RBAC_MATRIX.md..."
cat << 'INNER_EOF' > docs/RBAC_MATRIX.md
# 🛡️ Role-Based Access Control (RBAC) Matrix

**Roles:** `admin` (Owner), `staff` (Worker)
**Enforcement:** 1. **Frontend:** UI Hiding via `useJobWorkflow` / `userRole`.
2. **Backend:** Firestore Security Rules (checks `resource.data.orgId`).

| Feature | Action | Admin | Staff | Notes |
| :--- | :--- | :---: | :---: | :--- |
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
| | Mark Paid | ✅ | ❌ | |
| **Settings** | Invite User | ✅ | ❌ | |
| **Financials**| See Prices | ✅ | ❌ | Hidden in UI for Staff. |

INNER_EOF

# 3. Create SCHEMA_REFERENCE.md
# Detailed breakdown of fields
echo "📝 Creating docs/SCHEMA_REFERENCE.md..."
cat << 'INNER_EOF' > docs/SCHEMA_REFERENCE.md
# 🗄️ Firestore Schema Reference

## `organizations/{orgId}`
* **name** (string): Display name.
* **settings** (map): `{ currency, geoFenceRadius }`.
* **plan** (string): Subscription tier.

## `users/{userId}`
* **email** (string)
* **fullName** (string)
* **orgId** (string): **CRITICAL**. Links user to tenant.
* **role** (string): `'admin'` | `'staff'`.

## `clients/{clientId}`
* **orgId** (string)
* **name** (string)
* **email** (string)
* **phone** (string)
* **address** (string): Text address.
* **coordinates** (map): `{ lat: number, lng: number }`. Used for Maps.

## `jobs/{jobId}`
* **orgId** (string)
* **clientId** (string): Ref to `clients`.
* **assignedTo** (array): List of `userId` strings.
* **status** (string): `'scheduled'` | `'in_progress'` | `'completed'` | `'cancelled'`.
* **serviceType** (string): `'standard'` | `'deep'` | etc.
* **price** (number): Estimated cost.
* **scheduledDate** (timestamp): When the job is.
* **startedAt** (timestamp): When status changed to in_progress.
* **completedAt** (timestamp): When status changed to completed.
* **invoiceNumber** (string): Generated ID (e.g., "2026-4821").
* **invoicedAt** (timestamp): When PDF was generated.

INNER_EOF

# 4. Create CHANGELOG.md
# Start tracking history
echo "📝 Creating docs/CHANGELOG.md..."
cat << 'INNER_EOF' > docs/CHANGELOG.md
# 📜 Changelog

## [v0.5.1] - 2026-01-12
### Fixed
* **Mobile Invoicing:** Added responsive HTML preview for mobile devices to bypass PDF iframe limitations.
* **UI:** Added "Generate Invoice" button to Mobile Job Card.
* **State:** Fixed stale state bug in Invoice Modal by using ID-based lookups.

## [v0.5.0] - 2026-01-12
### Added
* **Invoicing Module:** Client-side PDF generation using `@react-pdf/renderer`.
* **Tracking:** `invoicedAt` and `invoiceNumber` fields added to Job Schema.

## [v0.4.0] - 2026-01-12
### Added
* **Google Maps:** Interactive schedule map.
* **Geocoding:** Auto-convert addresses to Lat/Lng on Client save.

INNER_EOF

# 5. Update CONTEXT_DUMP.md to Reference new docs
# This keeps the context token count lower for the AI
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
6. **PDF Generation:**
   - Desktop: `PDFViewer` (iframe).
   - Mobile: `InvoiceHTMLPreview` (HTML/CSS) + Download Link.
INNER_EOF

echo "✅ Documentation Suite Upgraded."
echo "👉 You now have a professional SaaS documentation structure."
