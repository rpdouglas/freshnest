#!/bin/bash

# ====================================================
# FRESH NEST: FEATURE CLOSE-OUT & RELEASE PROTOCOL
# Feature: Job Assignment
# ====================================================

echo "🏁 Initiating Close-Out for: Job Assignment..."

# 1. Update Documentation
echo "📝 Updating Project Documentation..."

# Update PROJECT_STATUS.md
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 1 Complete / Starting Phase 2 (Operations)
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Project Setup:** Vite + React + Tailwind CSS configured.
* **Authentication:** Firebase Login/Signup with Email & Password.
* **Architecture:** Client-Side Multi-Tenancy (OrgId stored in User Profile).
* **Client Management:** `useClients` hook, Mobile Cards, Desktop Table.
* **Job Management:** `useJobs` hook, Relational Data, Scheduling.
* **Schedule View:** Mobile-First Agenda UI with Date Range filtering.
* **Staff Management:** User Invites, Onboarding, Security Rules.
* **Job Assignment:**
    * `useStaff` hook for fetching assignable users.
    * `assignedTo` array in Jobs schema.
    * UI: Dropdown in Modal, Avatar display in Lists.
* **DevOps:** Automated Build Versioning & Git Hash injection.

## 🚧 In Progress / Next Up
* [ ] **Worker View:** A restricted view for staff to see only *their* jobs.
* [ ] **Job Status Workflow:** Allow staff to mark jobs as "Started" / "Completed".

## 🗄️ Database Schema (Firestore)

### `organizations/{orgId}`
* `name`, `plan`, `settings`

### `users/{userId}`
* `email`, `fullName`, `orgId` (Link to Org), `role` ('admin'|'staff')
* `createdAt`

### `invites/{inviteId}`
* `email`, `orgId`, `role`, `status`

### `clients/{clientId}`
* `orgId`, `name`, `email`, `phone`, `address`

### `jobs/{jobId}`
* `orgId`, `clientId` (Ref), `scheduledDate` (Timestamp)
* `status`, `serviceType`, `price`
* `assignedTo` (Array of userIds)

## �� Key Files Created
* `src/hooks/useStaff.js`
* `src/components/jobs/JobFormModal.jsx` (Updated)
* `src/components/jobs/JobTableDesktop.jsx` (Updated)
INNER_EOF

# Update CONTEXT_DUMP.md (Schema Update)
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- **CRITICAL:** `orgId` is stored in the **Firestore User Profile** (`users/{uid}`), NOT in Custom Claims.
- "fresh-nest-dev" Firestore is active.

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **invites/{inviteId}**: { email, orgId, role }
- **jobs/{jobId}**: { assignedTo: [userId], status, serviceType, ... }

## Rules for AI
1. ALL code must be provided as COMPLETE FILES.
2. Use `lucide-react` for icons.
3. Tailwind Colors: `bg-brand-500` (Primary), `bg-slate-800` (Sidebar).
4. **Security & Data Access:**
   - **NEVER** attempt to read `request.auth.token.orgId`. It does not exist.
   - **ALWAYS** fetch the user's Firestore profile to get their `orgId`.
   - All Firestore queries MUST filter by `.where("orgId", "==", currentOrgId)`.
INNER_EOF

# 2. Git Workflow
echo "🌿 Processing Git Workflow..."

# Stage and Commit
git add .
git commit -m "feat: completed job assignment module"

# Switch to Main and Merge
echo "🔄 Switching to main..."
git checkout main
git pull origin main

echo "🔀 Merging feature branch..."
git merge feature/job-assignment

echo "⬆️ Pushing to origin..."
git push origin main

# Delete Local Branch
echo "🗑️ Cleaning up local branch..."
git branch -d feature/job-assignment

# 3. Deployment (UAT)
echo "🚀 Deploying to UAT Environment..."

# Build (Increments Version)
npm run build

# Deploy
npx firebase deploy --only hosting:uat,firestore:rules

echo "✅ SUCCESS! Feature Closed & Deployed to UAT."
