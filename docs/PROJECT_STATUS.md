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

## 🚧 In Progress / Next Up
* [ ] **Schedule View:** A dedicated Calendar view for upcoming jobs.
* [ ] **Staff Management:** Adding employees to the Org.

## 🗄️ Database Schema (Firestore)

### `organizations/{orgId}`
* `name`, `plan`, `settings`

### `users/{userId}`
* `email`, `fullName`, `orgId`, `role`

### `clients/{clientId}`
* `orgId`, `name`, `email`, `phone`, `address`

### `jobs/{jobId}` (✨ NEW)
* `orgId`: String
* `clientId`: String (Ref to Client)
* `scheduledDate`: Timestamp
* `status`: String ('scheduled', 'completed')
* `serviceType`: String
* `price`: Number

## 📂 Key Files Created
* `src/hooks/useClients.js`, `src/hooks/useJobs.js`
* `src/pages/ClientsPage.jsx`, `src/pages/JobsPage.jsx`
* `firestore.rules`
