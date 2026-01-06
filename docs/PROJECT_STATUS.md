# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 1 - Foundation & Core Data
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Project Setup:** Vite + React + Tailwind CSS configured.
* **Authentication:** Firebase Login/Signup with Email & Password.
* **Multi-Tenancy:** * Custom Claims (`orgId`) implemented.
    * `init-org.cjs` script created for provisioning new organizations.
* **Client Management:**
    * Robust `useClients` hook with `orgId` security filters.
    * Responsive UI: Mobile Card List + Desktop Data Table.
    * "Add Client" Modal with validation.
    * Firestore Security Rules & Composite Indexes deployed.

## 🚧 In Progress / Next Up
* [ ] **Job Management:** Creating and assigning cleaning jobs.
* [ ] **Scheduling:** Calendar view for jobs.
* [ ] **Staff Management:** Adding employees to the Org.

## 🗄️ Database Schema (Firestore)

### `organizations/{orgId}`
* `name`: String
* `plan`: String ("basic", "gold")
* `settings`: Map (currency, etc.)

### `users/{userId}`
* `email`: String
* `fullName`: String
* `orgId`: String (Link to Organization)
* `role`: String ("admin", "user")

### `clients/{clientId}` (✨ NEW)
* `orgId`: String (Security Partition)
* `name`: String
* `email`: String
* `phone`: String
* `address`: String
* `createdAt`: Timestamp

## 📂 Key Files Created
* `src/hooks/useClients.js`
* `src/pages/ClientsPage.jsx`
* `src/components/clients/*` (Modal, List, Table)
* `firestore.rules`
* `firestore.indexes.json`

