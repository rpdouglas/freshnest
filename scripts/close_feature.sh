#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE CLOSE-OUT
# Feature: Invoicing & PDF Generation
# ====================================================

echo "🏁 Initiating Close-Out for: Invoicing..."

# 1. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 4 - Revenue & Reporting
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding.
* **Jobs:** Scheduling, CRUD, Workflow, Maps.
* **Invoicing:** PDF Generation, Status Tracking (Invoiced/Draft).
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Revenue Dashboard:** Visual charts for Earnings (Daily/Monthly).
* [ ] **Data Export:** CSV export for accounting.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: 
    - `status`: 'scheduled'|'in_progress'|'completed'|'cancelled'
    - `invoiceNumber`: String
    - `invoicedAt`: Timestamp
    - `price`: Number
* `clients/{clientId}`: { name, address, coordinates, ... }
INNER_EOF

# 2. Update Context Dump (Schema Update)
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **jobs/{jobId}**: 
    - `assignedTo`: [userId]
    - `status`: 'scheduled' | 'in_progress' | 'completed' | 'cancelled'
    - `invoiceNumber`: String (e.g. "2026-1023")
    - `invoicedAt`: Timestamp
    - `price`: Number
- **clients/{clientId}**: { coordinates: { lat, lng }, ... }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId`.** Fetch `users/{uid}`.
   - All queries must filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **State Management:**
   - Prefer deriving state from lists (e.g. `jobs.find(id)`) over storing object snapshots to prevent stale data.
INNER_EOF

# 3. Commit Final Changes
echo "🌿 Committing Documentation..."
git add .
git commit -m "feat: complete invoicing module and update docs"

# 4. Cut Release (Triggers UAT)
VERSION="v0.5.0-invoicing-$(date +%s)"
echo "🚀 Cutting Release Branch: release/$VERSION"

git checkout -b "release/$VERSION"
git push origin "release/$VERSION"

echo "✅ Release Pushed to GitHub!"
echo "👉 Action: 'Deploy to UAT' should be running now."

# 5. Merge to Dev & Cleanup
echo "🔄 Syncing Dev Branch..."
git checkout dev
git pull origin dev
git merge "feature/invoicing"
git push origin dev

# 6. Delete Local Feature Branch
echo "🗑️  Deleting local feature branch..."
git branch -d feature/invoicing

echo "🎉 SUCCESS! Feature Closed."
echo "   - UAT is deploying (release/$VERSION)"
