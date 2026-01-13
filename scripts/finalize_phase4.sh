#!/bin/bash

# ====================================================
# FRESH NEST: PHASE 4 FINALIZATION
# Goal: Sync Docs with Mobile Hotfixes
# ====================================================

echo "📚 Updating Documentation for Phase 4 (Post-Hotfix)..."

# 1. Refine Context Dump (Add Mobile PDF Rule)
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **jobs/{jobId}**: 
    - `assignedTo`: [userId]
    - `status`: 'scheduled' | 'in_progress' | 'completed' | 'cancelled'
    - `invoiceNumber`: String (e.g. "2026-1023")
    - `invoicedAt`: Timestamp
    - `price`: Number
- **clients/{clientId}**: { coordinates: { lat, lng }, ... }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId`.** Fetch `users/{uid}`.
   - All queries must filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **PDF Generation Strategy:**
   - **Desktop:** Use `@react-pdf/renderer` inside a `PDFViewer` (iframe).
   - **Mobile:** Do **NOT** use iframes. Render a semantic HTML/Tailwind preview component (`InvoiceHTMLPreview`) and provide a `PDFDownloadLink`.
   - **State:** Always use Live Data (IDs) for modals to prevent stale state bugs.
INNER_EOF

# 2. Update Project Status (Detailed)
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 5 - Revenue & Reporting
**Last Updated:** $(date +%Y-%m-%d)
**Latest Version:** v0.5.1 (Mobile Invoicing Patch)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy.
* **Clients:** CRUD, Filtering, Geocoding.
* **Jobs:** Scheduling, CRUD, Workflow, Maps.
* **Invoicing:** * PDF Generation (@react-pdf/renderer).
    * Invoice Status Tracking.
    * **Mobile Parity:** HTML Preview for mobile devices (iframe workaround).
* **DevOps:** 3-Environment CI/CD, Firestore Indexes.

## 🚧 In Progress / Next Up
* [ ] **Revenue Dashboard:** Visual charts for Earnings (Daily/Monthly).
* [ ] **Data Export:** CSV export for accounting.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: { invoiceNumber, invoicedAt, price, status, ... }
* `clients/{clientId}`: { name, address, coordinates, ... }
INNER_EOF

# 3. Commit Documentation
echo "🌿 Committing Final Docs..."
git add docs/
git commit -m "docs: finalize phase 4 with mobile architecture notes"
git push origin main

echo "🎉 Phase 4 Officially Closed & Documented."
