#!/bin/bash

# ====================================================
# FRESH NEST: PHASE 3 CLOSE-OUT
# Goal: Update Docs & Sync
# ====================================================

echo "📚 Updating Documentation for Phase 3 Completion..."

# 1. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 4 - Invoicing & Revenue
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding (Auto-Coordinates).
* **Jobs:** Scheduling, CRUD, Workflow (Start/Complete/Cancel).
* **Maps:** Interactive Schedule Map (Google Maps API).
* **DevOps:** 3-Environment CI/CD, Firestore Indexes, Maps API Integration.

## 🚧 In Progress / Next Up
* [ ] **Invoicing:** Generate PDF invoices for completed jobs.
* [ ] **Revenue Reporting:** Basic dashboard for earnings.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: { status: 'scheduled'|'completed', price, startedAt, completedAt ... }
* `clients/{clientId}`: { name, address, coordinates: { lat, lng }, ... }
INNER_EOF

# 2. Update DevOps Manual (Add Maps Protocol)
echo "📝 Updating docs/DEVOPS_MANUAL.md..."
cat << 'INNER_EOF' > docs/DEVOPS_MANUAL.md
# ☁️ DevOps & Infrastructure Manual

## 1. CI/CD Architecture
We use **GitHub Actions** for "Full Stack" deployments.
* **Workflows:** `.github/workflows/`
* **Triggers:** `dev` (Dev), `release/*` (UAT), `main` (Prod).

## 2. Environment Management
Scripts in `/scripts` handle data seeding. Always pass the env arg (e.g., `node scripts/init-org.cjs uat`).

## 3. GitHub Secrets (Required)
| Secret Name | Content |
| :--- | :--- |
| `FIREBASE_SERVICE_ACCOUNT_[ENV]` | JSON key for Firebase Admin |
| `ENV_FILE_[ENV]` | Full contents of `.env` |

## 4. Google Maps Setup (New Project)
If creating a new environment (e.g., Staging), you MUST:
1.  **GCP Console:** Enable "Maps JavaScript API" and "Geocoding API".
2.  **Billing:** Link the project to your Billing Account (Critical).
3.  **Credentials:** Create an API Key.
4.  **Secrets:** Add `VITE_GOOGLE_MAPS_API_KEY=...` to the `ENV_FILE_[ENV]` GitHub Secret.

## 5. Troubleshooting
**"Billing Not Setup" on Map:**
* Go to GCP Console -> Billing -> Link the project to your account.

**"Missing Permissions" in CI/CD:**
* Grant `firebase-adminsdk` Service Account "Editor" or "Cloud Datastore User" roles.
INNER_EOF

# 3. Update Context Dump (Refine Rules)
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
    - `startedAt`, `completedAt`: Timestamps
- **clients/{clientId}**: 
    - `coordinates`: { lat: number, lng: number }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId`.** Fetch `users/{uid}` from Firestore.
   - All queries must filter by `.where("orgId", "==", currentOrgId)`.
5. **Environment Variables:**
   - ALWAYS use `import.meta.env.VITE_...` (Vite standard).
   - NEVER use `process.env` in frontend code.
INNER_EOF

# 4. Git Commit
echo "🌿 Committing Documentation Updates..."
git add .
git commit -m "chore: finalize phase 3 docs and update devops manual"
git push origin main

echo "🎉 Phase 3 Maps & Geocoding Officially Closed!"
