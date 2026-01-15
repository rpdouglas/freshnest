#!/bin/bash

echo "🔄 Realigning Roadmap to Master Plan 9 (Cornwall Context)..."

cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest (Worker Support Platform)

**Current Phase:** Phase 1 - Identity, Safety & Compliance
**Current Version:** v1.0.0 (Core Infrastructure Live)
**Context:** Cornwall, Ontario Socioeconomic Deployment
**Last Updated:** $(date +%Y-%m-%d)

> **Mission:** To transform the cleaning industry into a system of stability for marginalized workers while maintaining enterprise-grade reliability.

## 🎯 Current Sprint: The "Smart Profile" (Sprint 1)
We are upgrading the User Schema to support the complex realities of our workforce (ODSP limits, Transit reliance, Single parenthood).

* [ ] **User Schema Expansion:**
    * Add `financials.limit` (for "Carla" - ODSP).
    * Add `constraints.transport` (for "Jasmine" - Bus routes).
    * Add `constraints.blockedWindows` (for "Mike" - AA Meetings).
* [ ] **Profile Wizard:**
    * Self-onboarding flow for staff to set their own constraints.
    * **Legal:** Mandatory `acceptedTermsVersion` checkbox[cite: 117].
* [ ] **Localization Base:**
    * Prepare app for English/French toggle (for "Ahmed").

## 📋 Product Backlog (Master Plan 9)

### Phase 1: Safety & Constraints
* **The Conflict Engine:** Logic to auto-hide shifts that conflict with school runs (Emily) or recovery meetings (Mike)[cite: 46].
* **Financial Guardrails:** Hard system lock if `Current Earnings + Shift Price > ODSP Cap`[cite: 53].

### Phase 2: Field Operations
* **Visual Interface:** Replace text-heavy lists with Icon-based tasks (Mop, Toilet) for ESL accessibility[cite: 68].
* **Job Evidence:** Photo uploads to specific sub-collections for client verification (Brenda)[cite: 93].
* **Inventory Reports:** specific inputs for Airbnb supplies (Sophie)[cite: 102].

### Phase 3: Support & Scale
* **Crisis Protocol:** "SOS" button logic to swap shifts instantly[cite: 38].
* **Impact Dashboard:** Report on "Hours created for ODSP workers" for City Hall contracts (Sarah)[cite: 80].

---

## ✅ Version History

### v1.0.0 - Infrastructure Core (Completed)
* **Architecture:** Multi-Tenant SaaS (Firebase/React).
* **Security:** Role-Based Access Control (Admin/Staff).
* **Financials:** Admin Revenue Dashboard (Recharts).
* **DevOps:** CI/CD Pipelines (Dev/UAT/Prod).

---

## 🗄️ Database Schema Snapshot (Target State)

### `users/{userId}` [cite: 180]
* `profile`: { name, language, transport, acceptedTermsVersion }
* `financials`: { mode: 'cap', limit: number, currentMonthAccrued: number }
* `constraints`: { heavyLifting: boolean, blockedWindows: array }
* `stats`: { reliabilityScore: number }

### `shifts/{shiftId}` [cite: 205]
* `status`: 'open' | 'claimed' | 'completed'
* `contractLedger`: { claimedBy, claimedAt, rateSnapshot }
* `requirements`: { photoEvidence: array }

INNER_EOF

echo "✅ Project Status updated to Master Plan 9."
