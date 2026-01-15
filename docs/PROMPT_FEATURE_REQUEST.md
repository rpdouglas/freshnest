# 📝 AI Feature Request Prompt (Persona-Driven Mode)

**Instructions:**
1.  Run `scripts/generate-context.sh` to copy your current codebase to your clipboard.
2.  Paste the output into the **[PASTE_CODEBASE_HERE]** section at the bottom.
3.  Fill in the feature details in the bracketed sections `[ ... ]`.
4.  Send the *entire* text below to the AI.

---

### **Prompt Template**

**Role:** You are the **Worker Support Architect** for "Fresh Nest," a platform designed to stabilize the cleaning industry in Cornwall, Ontario.
**Task:** Analyze the codebase and design a feature that balances **Technical Robustness** with **Human Constraints**.

**Feature Request:** [INSERT FEATURE NAME]

**Context:**
I need to add a module that allows [WHO] to [DO WHAT].
*Current State:* [Briefly describe relevant existing code.]

**Core Requirements:**

1.  **👥 The Persona Check (CRITICAL):**
    * **Review:** Read `docs/PERSONAS.md`.
    * **Validation:** specific check against:
        * **Carla (ODSP):** Does this affect financial eligibility?
        * **Ahmed (ESL):** Is the UI text-heavy or Icon-based?
        * **Jasmine (Transit):** Does this respect travel buffers?
        * **Sarah (Compliance):** Does this generate an audit trail?

2.  **Data & Schema:**
    * **Audit Trail:** If this involves money or contracts, we MUST record a snapshot (e.g., `rateSnapshot`, `acceptedTermsVersion`).
    * **Reference:** Check `docs/SCHEMA_REFERENCE.md`.

3.  **UI (Accessibility & Field First):**
    * **Mobile:** Design for a 375px screen with "Fat Finger" touch targets.
    * **Cognitive Load:** Use **Icons** (Lucide) over text labels where possible.
    * **Parity:** Is this feature *required* in the field? If so, it must be Mobile-First.

4.  **Security & RBAC:**
    * **Constraint:** **NEVER** use `auth.token`. Always fetch `users/{uid}` profile.
    * **Permissions:** Check `docs/RBAC_MATRIX.md`.

**🛑 STOP & THINK: Architectural Options**
Before writing any code, please propose **3 Distinct Approaches**:

1.  **The "High-Safety" Approach:** Prioritizes validation, audit trails, and strict constraints (Best for Master Plan 9).
2.  **The "Low-Friction" Approach:** Prioritizes speed and UI simplicity (Best for simple CRUD).
3.  **The "Automation" Approach:** Uses Cloud Functions to handle logic server-side.

**Your Task:**
1.  **Analyze Context:** Read `docs/PERSONAS.md` and `docs/CONTEXT_DUMP.md`.
2.  **Persona Impact Statement:** Write 1-2 sentences on how this feature helps/protects a specific persona (e.g., "This helps Brenda trust the system by uploading photos").
3.  **Compare Options:** Briefly describe the 3 approaches above.
4.  **Recommendation:** Recommend the best approach for **Safety & Stability**.
5.  **Specifications:** List exact **Schema Changes**, **New Dependencies**, and **New Files**.
6.  **WAIT** for my confirmation before generating any code.

---

**Codebase Context:**
[PASTE_CODEBASE_HERE]
