#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE CLOSE-OUT (CI/CD Version)
# Feature: Worker View (RBAC)
# ====================================================

echo "🏁 Initiating Close-Out for: Worker View..."

# 1. Update Documentation
echo "📝 Updating Project Documentation..."

cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 1 Complete / Infrastructure Mature
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment (`useStaff`).
* **Worker View:** * RBAC Hooks (`useJobs` filters by role).
    * UI Restrictions (Hidden Prices, Hidden Buttons).
    * Secure Mobile/Desktop Views.
* **DevOps:** 3-Environment CI/CD (Dev/UAT/Prod).

## 🚧 In Progress / Next Up
* [ ] **Job Workflow:** Allow staff to mark jobs as "Started" / "Completed".
* [ ] **Job Edit/Delete:** Full CRUD for Admins.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, ... }
INNER_EOF

# 2. Commit Final Changes
echo "🌿 Committing Documentation..."
git add .
git commit -m "feat: completed worker view and updated docs"

# 3. Cut Release (Triggers UAT)
# We use a timestamped version for the release branch
VERSION="v0.2.0-rbac-$(date +%s)"
echo "🚀 Cutting Release Branch: release/$VERSION"

git checkout -b "release/$VERSION"
git push origin "release/$VERSION"

echo "✅ Release Pushed to GitHub!"
echo "👉 Action: 'Deploy to UAT' should be running now."

# 4. Merge to Dev & Cleanup
echo "🔄 Syncing Dev Branch..."
git checkout dev
git pull origin dev
git merge "feature/worker-view"
git push origin dev

# 5. Delete Local Feature Branch
# We stay on 'dev' now.
echo "🗑️  Deleting local feature branch..."
git branch -d feature/worker-view

echo "�� SUCCESS! Feature Closed."
echo "   - UAT is deploying (release/$VERSION)"
echo "   - Dev is up to date"
echo "   - You are now on 'dev' branch"
