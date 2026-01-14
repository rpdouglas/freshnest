# 🧹 Fresh Nest

**Fresh Nest** is a Lean SaaS Field Service Management (FSM) platform built for cleaning businesses.
It features Multi-Tenancy, Role-Based Access Control, Geolocation, and Financial Analytics.

## 🚀 Quick Start

1. **Install Dependencies:**
   \`npm install\`

2. **Environment Setup:**
   Ensure you have \`.env.development\` with valid Firebase & Google Maps Keys.

3. **Run Local Dev:**
   \`npm run dev\`

## 📂 Documentation Index

* **[Project Status](./docs/PROJECT_STATUS.md):** Current phase and roadmap.
* **[DevOps Manual](./docs/DEVOPS_MANUAL.md):** CI/CD, Secrets, and Infrastructure.
* **[Context Dump](./docs/CONTEXT_DUMP.md):** High-level architecture rules for AI.
* **[RBAC Matrix](./docs/RBAC_MATRIX.md):** Security permissions reference.
* **[Schema Reference](./docs/SCHEMA_REFERENCE.md):** Firestore data model & Business Logic.

## 🏗️ Architecture
* **Frontend:** React + Vite + Tailwind CSS
* **Backend:** Firebase (Auth, Firestore, Functions)
* **Maps:** Google Maps Javascript API
* **Invoicing:** @react-pdf/renderer (Client-side)
* **Analytics:** Recharts (Client-side aggregation)
