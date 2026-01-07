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

## 📂 Key Files Created
* `src/hooks/useStaff.js`
* `src/components/jobs/JobFormModal.jsx` (Updated)
* `src/components/jobs/JobTableDesktop.jsx` (Updated)
