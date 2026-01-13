#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE CLOSE-OUT
# Feature: Revenue Dashboard & Analytics
# ====================================================

echo "🏁 Initiating Close-Out for: Revenue Dashboard..."

# 1. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 6 - Data Export & Polish
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding.
* **Jobs:** Scheduling, CRUD, Workflow, Maps.
* **Invoicing:** PDF Generation (Client-side), Mobile Parity.
* **Dashboard:** Admin KPIs, Revenue Charts (Recharts), Staff View restrictions.
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Data Export:** CSV export for accounting (Quickbooks/Xero support).
* [ ] **Final Polish:** UX consistency check.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: { status, price, completedAt, scheduledDate, ... }
* `clients/{clientId}`: { name, address, coordinates, ... }
INNER_EOF

# 2. Update Context Dump (Dashboard Logic)
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
5. **Analytics Strategy:**
   - **Client-Side Aggregation:** Fetch raw jobs via `useDashboard` and calculate totals in JS (reduce/map).
   - **Visualization:** Use `recharts` for graphs. Ensure horizontal scrolling on mobile.
6. **PDF Generation:**
   - Desktop: `PDFViewer` (iframe).
   - Mobile: `InvoiceHTMLPreview` (HTML/CSS) + Download Link.
INNER_EOF

# 3. Update Changelog
echo "📝 Updating docs/CHANGELOG.md..."
cat << 'INNER_EOF' > docs/CHANGELOG.md
# 📜 Changelog

## [v0.6.0] - 2026-01-12
### Added
* **Revenue Dashboard:** Admin view with Total Revenue, Jobs Completed, and Avg Ticket KPIs.
* **Visualizations:** Monthly Revenue Bar Chart using `recharts`.
* **Staff Dashboard:** Restricted view showing only assigned upcoming jobs.
* **Mobile Optimization:** Horizontal scroll containers for charts on small screens.

## [v0.5.1] - 2026-01-12
### Fixed
* **Mobile Invoicing:** Added responsive HTML preview for mobile devices.

## [v0.5.0] - 2026-01-12
### Added
* **Invoicing Module:** Client-side PDF generation.

INNER_EOF

# 4. Commit Final Changes
echo "🌿 Committing Documentation..."
git add .
git commit -m "feat: complete revenue dashboard and update docs"

# 5. Cut Release (Triggers UAT)
VERSION="v0.6.0-dashboard-$(date +%s)"
echo "🚀 Cutting Release Branch: release/$VERSION"

git checkout -b "release/$VERSION"
git push origin "release/$VERSION"

echo "✅ Release Pushed to GitHub!"
echo "👉 Action: 'Deploy to UAT' should be running now."

# 6. Merge to Dev & Cleanup
echo "🔄 Syncing Dev Branch..."
git checkout dev
git pull origin dev
git merge "feature/dashboard"
git push origin dev

# 7. Delete Local Feature Branch
echo "🗑️  Deleting local feature branch..."
git branch -d feature/dashboard

echo "🎉 SUCCESS! Phase 5 Closed."
echo "   - UAT is deploying (release/$VERSION)"
