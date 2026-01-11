# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 2 - Core Workflows
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment.
* **Worker View (RBAC):** * "Ghost Client" fix (DB Lookup vs Token).
    * Role-Aware Hooks (`useJobs`, `useClients`).
    * UI Restrictions (Hidden Prices, Hidden Buttons).
* **DevOps:** * 3-Environment CI/CD (Dev/UAT/Prod) with Firestore Rules/Indexes.
    * Environment-aware seeding scripts.

## 🚧 In Progress / Next Up
* [ ] **Job Workflow:** Allow staff to mark jobs as "In Progress" / "Completed".
* [ ] **Job Edit/Delete:** Full CRUD for Admins.
* [ ] **Google Maps Integration:** Visualizing daily routes.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, fullName, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, price, ... }
* `clients/{clientId}`: { name, address, orgId, ... }
