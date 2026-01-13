# 📝 AI Feature Request Prompt (Architectural Mode)

**Instructions:**
1.  Run `scripts/generate-context.sh` to copy your current codebase to your clipboard.
2.  Paste the output into the **[PASTE_CODEBASE_HERE]** section at the bottom.
3.  Fill in the feature details in the bracketed sections `[ ... ]`.
4.  Send the *entire* text below to the AI.

---

### **Prompt Template**

**Role:** You are the Senior Lead Developer for "Fresh Nest".
**Task:** Analyze the codebase provided below and propose an architecture for a new feature.

**Feature Request:** [INSERT FEATURE NAME]

**Context:**
I need to add a module to "Fresh Nest" that allows [WHO] to [DO WHAT].
*Current State:* [Briefly describe relevant existing code, e.g., "We have a Jobs List, but no way to change status."]

**Core Requirements:**

1.  **Data & Schema:**
    * [What new collections or fields do we need?]
    * [e.g., "Add 'coordinates' to 'clients' collection"]

2.  **UI (Mobile First):**
    * **Mobile:** [How does it look on phone? e.g., "Swipe to complete", "Big button"]
    * **Desktop:** [How does it look on PC? e.g., "Table Action Menu"]

3.  **Security & RBAC (Crucial):**
    * **Admin:** [What permissions do they have?]
    * **Staff:** [What are they RESTRICTED from?]
    * *Constraint:* **NEVER** use `auth.token` or Custom Claims for roles. **ALWAYS** fetch the User Profile from Firestore (`users/{uid}`).

4.  **Infrastructure & Config (New):**
    * **Dependencies:** [Do we need new NPM packages? e.g., `react-pdf`, `@react-google-maps/api`]
    * **Env Variables:** [Do we need new API Keys? e.g., `VITE_STRIPE_KEY`]

**🛑 STOP & THINK: Architectural Options**
Before writing any code, please propose **3 Distinct Approaches** to implementing this feature:

1.  **The "Direct/Inline" Approach:** Logic inside components. Fast, but hard to test/reuse.
2.  **The "Custom Hook" Approach (Recommended):** Logic extracted to `use[Feature]`. Handles DB subscriptions, loading states, and RBAC checks internally. Keeps UI clean.
3.  **The "Complex/Global" Approach:** Uses global context providers or cloud functions for simple logic. Overkill?

**Your Task:**
1.  **Analyze the Codebase:** Review the provided file dump to understand our patterns (Hooks, Firebase Auth, Tailwind).
2.  **Compare Options:** Briefly describe the 3 approaches above (Pros/Cons).
3.  **Recommendation:** Recommend the best approach for our "Lean SaaS" architecture.
4.  **Specifications:** List exact **Schema Changes**, **New Dependencies**, and **New Files**.
5.  **WAIT** for my confirmation before generating any code.

---

**Codebase Context:**
[PASTE_CODEBASE_HERE]
