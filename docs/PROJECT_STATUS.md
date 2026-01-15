# 📌 Project Status: Fresh Nest (Worker Support Platform)

**Current Phase:** Phase 2 - Field Operations (Inventory)
**Current Version:** v0.4.0 (Field Companion Live)
**Context:** Cornwall, Ontario Socioeconomic Deployment
**Last Updated:** $(date +%Y-%m-%d)

> **Mission:** To transform the cleaning industry into a system of stability for marginalized workers while maintaining enterprise-grade reliability.

## ✅ Completed Features
* **Sprint 1: Smart Profile:** Data collection for transport, financials, and blocked windows.
* **Sprint 2: Financial Guardrails:** Strict blocking of shifts that exceed ODSP limits.
* **Sprint 3: Conflict Engine:** Scheduling protection (Recovery meetings & Transit buffers).
* **Sprint 4: Field Companion:**
    * **Work Mode:** Icon-first checklists for ESL accessibility (Ahmed).
    * **Evidence Locker:** Photo verification for trust (Brenda).
    * **Progress Tracking:** Real-time updates for Admins.

## 🎯 Current Sprint: The Inventory Manager (Sprint 5)
Workers often arrive at Airbnb units to find supplies missing. This causes stress and bad reviews. We need a way for "Sophie" (The Supplier) to track and restock.

* [ ] **Supply Reporting:**
    * Task-integrated logic: "Did you use the last roll of TP?"
    * One-tap reporting for "Low Stock".
* [ ] **Restock Dashboard:**
    * Admin view of which units need supplies *before* the next cleaner arrives.

## 📋 Product Backlog (Master Plan 9)

### Phase 3: Support & Scale
* **Crisis Protocol:** "SOS" button logic to swap shifts instantly.
* **Impact Dashboard:** Report on "Hours created for ODSP workers" for City Hall contracts.

---

## 🗄️ Database Schema Snapshot
* `jobs/{jobId}`: 
    * `tasks`: [{ id, label, icon, isCompleted }]
    * `evidence`: [{ id, url, type, timestamp }]
    * `inventoryUsed`: [{ itemId, quantity }] (Upcoming)
