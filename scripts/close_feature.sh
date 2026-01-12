#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE CLOSE-OUT
# Feature: Job Workflow (Status Transitions)
# ====================================================

echo "🏁 Initiating Close-Out for: Job Workflow..."

# 1. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 2 - Core Workflows
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment.
* **Worker View:** RBAC, Role-Aware Hooks, UI Restrictions.
* **Job Workflow:** Status Transitions (Start/Complete/Cancel) with Timestamps.
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Job Edit/Delete:** Full CRUD for Admins.
* [ ] **Google Maps Integration:** Visualizing daily routes.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, fullName, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, startedAt, completedAt, ... }
* `clients/{clientId}`: { name, address, orgId, ... }
INNER_EOF

# 2. Update Context Dump (Crucial for AI Memory)
# We add the new status/timestamp fields to the schema definition
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- **CRITICAL:** `orgId` is stored in the **Firestore User Profile** (`users/{uid}`).

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **invites/{inviteId}**: { email, orgId, role }
- **jobs/{jobId}**: 
    - `assignedTo`: [userId]
    - `status`: 'scheduled' | 'in_progress' | 'completed' | 'cancelled'
    - `startedAt`: Timestamp
    - `completedAt`: Timestamp
    - `price`: Number
- **clients/{clientId}**: { name, address, orgId, email, phone }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId` (Custom Claims) in React Code.** It is stale.
   - **ALWAYS** fetch `users/{uid}` from Firestore to get the current `orgId`.
   - All Firestore queries MUST filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **Date Handling:** Use `date-fns`.
INNER_EOF

# 3. Commit Final Changes
echo "🌿 Committing Documentation & Code..."
git add .
git commit -m "feat: complete job workflow and update docs schema"

# 4. Cut Release (Triggers UAT)
VERSION="v0.3.0-workflow-$(date +%s)"
echo "🚀 Cutting Release Branch: release/$VERSION"

git checkout -b "release/$VERSION"
git push origin "release/$VERSION"

echo "✅ Release Pushed to GitHub!"
echo "👉 Action: 'Deploy to UAT' should be running now."

# 5. Merge to Dev & Cleanup
echo "🔄 Syncing Dev Branch..."
git checkout dev
git pull origin dev
git merge "feature/job-workflow"
git push origin dev

# 6. Delete Local Feature Branch
# We stay on 'dev' now.
echo "🗑️  Deleting local feature branch..."
git branch -d feature/job-workflow

echo "🎉 SUCCESS! Feature Closed."
echo "   - UAT is deploying (release/$VERSION)"
echo "   - Dev is up to date"
echo "   - Docs are updated with new Schema"
