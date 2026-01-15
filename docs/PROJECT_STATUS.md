# 📌 Project Status: Fresh Nest (Worker Support Platform)

**Current Phase:** Phase 1 - Safety Logic & Enforcement
**Current Version:** v0.2.0 (Guardrails Live)
**Context:** Cornwall, Ontario Socioeconomic Deployment
**Last Updated:** $(date +%Y-%m-%d)

> **Mission:** To transform the cleaning industry into a system of stability for marginalized workers while maintaining enterprise-grade reliability.

## ✅ Completed (Sprint 2: Financial Guardrails)
* **Financial Logic:** Client-side aggregation of monthly earnings via `useFinancials`.
* **Guardrail Enforcement:** "Strict Block" on Job Cards if `current + price > limit`.
* **Visuals:** "Safe to Earn" Traffic Light bar on Dashboard.
* **Persona Protection:** Carla (ODSP) is now actively protected from over-earning.

## 🎯 Current Sprint: The Conflict Engine (Sprint 3)
We have the constraints (`blockedWindows`). Now we need to filter the schedule.

* [ ] **Conflict Logic (Mike):**
    * Filter out job offers that overlap with `user.constraints.blockedWindows`.
* [ ] **Transport Buffers (Jasmine):**
    * If `transport === 'transit'`, ensure 30min gap between jobs.

---

## 🗄️ Database Schema Snapshot
* `users/{userId}`: { financials: { limit, mode }, constraints: { blockedWindows } }
* `jobs/{jobId}`: { status, price, scheduledDate, assignedTo }
