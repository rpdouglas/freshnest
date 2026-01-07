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
* **Staff Management:** * User Invites (Admin sends email).
    * Onboarding (Auto-linking to Org upon signup).
    * Security Rules (Profile-based access control).
* **DevOps:** Automated Build Versioning & Git Hash injection.

## 🚧 In Progress / Next Up
* [ ] **Job Assignment:** Assigning specific jobs to specific staff members.
* [ ] **Worker View:** A restricted view for staff to see only *their* jobs.

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
* `assignedTo` (Array of userIds - Coming Soon)

## 📂 Key Files Created
* `src/hooks/useSettings.js`
* `src/pages/SettingsPage.jsx`
* `src/features/auth/LoginPage.jsx` (Onboarding Logic)
* `firestore.rules` (Profile-Based Security)
