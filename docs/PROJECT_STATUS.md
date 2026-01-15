# 📌 Project Status: Fresh Nest (Worker Support Platform)

**Current Phase:** Phase 2 - Field Operations & Trust
**Current Version:** v0.3.0 (Conflict Engine Live)
**Context:** Cornwall, Ontario Socioeconomic Deployment
**Last Updated:** $(date +%Y-%m-%d)

> **Mission:** To transform the cleaning industry into a system of stability for marginalized workers while maintaining enterprise-grade reliability.

## ✅ Completed (Phase 1: Safety & Constraints)
* **Sprint 1: Smart Profile:** Data collection for transport, financials, and blocked windows.
* **Sprint 2: Financial Guardrails:** Strict blocking of shifts that exceed ODSP limits.
* **Sprint 3: Conflict Engine:**
    * **Hard Blocks:** Preventing work during recovery meetings (Mike).
    * **Soft Blocks:** Enforcing 30min buffers for transit users (Jasmine).
    * **Parity:** Visual enforcement on both Mobile (Cards) and Desktop (Table).

## 🎯 Current Sprint: The Field Companion (Sprint 4)
Now that scheduling is safe, we must ensure the *work* is accessible and verifiable.

* [ ] **Icon-First Checklists (Ahmed):**
    * Replace text-heavy task lists with large, clear icons (e.g., Mop, Toilet, Trash).
    * Toggle between languages (English/French) instantly.
* [ ] **Evidence Locker (Brenda):**
    * "Before" and "After" photo uploads.
    * Upload to `jobs/{jobId}/evidence` in Storage.

## 📋 Product Backlog (Master Plan 9)

### Phase 3: Support & Scale
* **Crisis Protocol:** "SOS" button logic to swap shifts instantly.
* **Impact Dashboard:** Report on "Hours created for ODSP workers" for City Hall contracts.

---

## 🗄️ Database Schema Snapshot
* `users/{userId}`: { financials, constraints, profile }
* `jobs/{jobId}`: 
    * `status`: 'scheduled' | 'in_progress' | 'completed'
    * `tasks`: [{ label, icon, isDone }] (New for Sprint 4)
    * `evidence`: [{ url, type, timestamp }] (New for Sprint 4)
