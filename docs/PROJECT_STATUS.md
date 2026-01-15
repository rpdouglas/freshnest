# 📌 Project Status: Fresh Nest (Worker Support Platform)

**Current Phase:** Phase 1 - Safety Logic & Enforcement
**Current Version:** v0.1.1 (Smart Profile Live)
**Context:** Cornwall, Ontario Socioeconomic Deployment
**Last Updated:** $(date +%Y-%m-%d)

> **Mission:** To transform the cleaning industry into a system of stability for marginalized workers while maintaining enterprise-grade reliability.

## ✅ Completed (Sprint 1: The Smart Profile)
* **User Schema V2:** Added `financials`, `constraints`, and `transport` objects.
* **Profile Wizard:** Mobile-first, icon-based form for staff self-declaration.
* **Audit Trail:** Mandatory `acceptedTermsVersion` tracking.
* **Localization Prep:** Visual language toggle in settings.

## 🎯 Current Sprint: The Guardian Logic (Sprint 2)
Now that we know the constraints, we must enforce them.

* [ ] **Financial Guardrails (Carla):**
    * Logic: `currentEarnings + jobPrice > cap` = **Disable Claim**.
    * UI: Visual "Earnings Bar" on Dashboard.
* [ ] **Conflict Engine (Mike):**
    * Logic: Filter out jobs overlapping with `blockedWindows`.
* [ ] **Transport Buffers (Jasmine):**
    * Logic: If `transport === 'transit'`, add 30min buffer between shifts.

## 📋 Product Backlog (Master Plan 9)

### Phase 2: Field Operations
* **Visual Interface:** Replace text-heavy lists with Icon-based tasks (Mop, Toilet).
* **Job Evidence:** Photo uploads to specific sub-collections.
* **Inventory Reports:** Specific inputs for Airbnb supplies.

### Phase 3: Support & Scale
* **Crisis Protocol:** "SOS" button logic.
* **Impact Dashboard:** Report on "Hours created for ODSP workers".

---

## 🗄️ Database Schema Snapshot (Target State)

### `users/{userId}`
* `profile`: { name, language, transport, acceptedTermsVersion }
* `financials`: { mode: 'cap', limit: number, currentMonthAccrued: number }
* `constraints`: { heavyLifting: boolean, blockedWindows: array }
* `role`: 'admin' | 'staff'
* `orgId`: string

### `jobs/{jobId}`
* `status`: 'open' | 'claimed' | 'completed'
* `price`: number
* `scheduledDate`: timestamp
* `requirements`: { photoEvidence: array }

