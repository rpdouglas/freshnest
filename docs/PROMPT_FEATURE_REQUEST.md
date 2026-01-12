# 📝 AI Feature Request Prompt (Architectural Mode)

**Instructions:**
1.  Ensure you have already initialized the AI session using the `PROMPT_INITIALIZATION.md` template.
2.  Copy the **Prompt Template** below into your AI Chat.
3.  Fill in the bracketed sections `[ ... ]` with your specific requirements.

---

### **Prompt Template**

**Feature Request:** [INSERT FEATURE NAME]

**Context:**
I need to add a module to "Fresh Nest" that allows [WHO] to [DO WHAT].
*Current State:* [Briefly describe relevant existing code, e.g., "We have a Jobs List, but no way to change status."]

**Core Requirements:**

1.  **Data & Schema:**
    * [What new collections or fields do we need?]
    * [e.g., "Add 'startedAt' timestamp to 'jobs' collection"]

2.  **UI (Mobile First):**
    * **Mobile:** [How does it look on phone? e.g., "Swipe to complete", "Big button"]
    * **Desktop:** [How does it look on PC? e.g., "Table Action Menu"]

3.  **Security & RBAC (Crucial):**
    * **Admin:** [What can they do? e.g., "Edit anything"]
    * **Staff:** [What are they RESTRICTED from? e.g., "Can only update their own assigned jobs"]

4.  **Logic & Constraints:**
    * **Architecture:** Must use the "Database Lookup" pattern for `orgId`. NO `auth.token` usage.
    * **State:** [Real-time updates required?]

**🛑 STOP & THINK: Architectural Options**
Before writing any code, please propose **3 Distinct Approaches** to implementing this feature:

1.  **The "Direct/Inline" Approach:** Logic inside components. Fast, but hard to test/reuse.
2.  **The "Custom Hook" Approach (Recommended):** Logic extracted to `use[Feature]`. Handles DB subscriptions, loading states, and RBAC checks internally. Keeps UI clean.
3.  **The "Complex/Global" Approach:** Uses global context providers or cloud functions for simple logic. Overkill?

**Your Task:**
1.  Briefly describe these 3 options (Pros/Cons).
2.  Recommend which one fits our current architecture best.
3.  **List exact Schema Changes** (New fields/Collections).
4.  **WAIT** for my confirmation before generating code.

