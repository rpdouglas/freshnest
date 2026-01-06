# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 1 - Foundation & Core Data
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Project Setup:** Vite + React + Tailwind CSS configured.
* **Authentication:** Firebase Login/Signup with Email & Password.
* **Multi-Tenancy:** Custom Claims (`orgId`) & Provisioning Script.
* **Client Management:**
    * `useClients` hook, Mobile Cards, Desktop Table.
    * Security Rules & Indexes deployed.
* **Job Management:**
    * `useJobs` hook with Relational Data (`clientId`).
    * UI: Jobs List with "Join" logic (Client Name lookup).
    * "Add Job" Modal with Client Dropdown.
    * Security Rules & Composite Index (`orgId` + `scheduledDate`) deployed.
* **Schedule View:**
    * `useSchedule` hook (Date Range filtering).
    * Mobile-First Agenda UI (Date Strip + Daily List).

## 🚧 In Progress / Next Up
* [ ] **Staff Management:** Adding employees to the Org (User Invite flow).
* [ ] **Job Assignment:** Assigning specific jobs to specific staff members.

## 🗄️ Database Schema (Firestore)

### `organizations/{orgId}`
* `name`, `plan`, `settings`

### `users/{userId}`
* `email`, `fullName`, `orgId`, `role`

### `clients/{clientId}`
* `orgId`, `name`, `email`, `phone`, `address`

### `jobs/{jobId}`
* `orgId`, `clientId` (Ref), `scheduledDate` (Timestamp)
* `status`, `serviceType`, `price`

## 📂 Key Files Created
* `src/hooks/useClients.js`, `src/hooks/useJobs.js`, `src/hooks/useSchedule.js`
* `src/pages/ClientsPage.jsx`, `src/pages/JobsPage.jsx`, `src/pages/SchedulePage.jsx`
* `firestore.rules`
