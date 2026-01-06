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

**Core Requirements:**
1.  **Data:** [Describe data needs, e.g., "Store Client details linked to orgId"]
2.  **UI:** [Describe UI needs, e.g., "Mobile cards, Desktop table"]
3.  **Logic:** [Describe logic, e.g., "Real-time updates, security filters"]

**🛑 STOP & THINK: Architectural Options**
Before writing any code, please propose **3 Distinct Approaches** to implementing this feature:

1.  **The "MVP" Approach:** Fastest to build, simplest code, uses basic HTML/Tailwind. Good for testing value quickly.
2.  **The " robust & Scalable" Approach (Recommended):** Best balance. Uses proper abstractions (custom hooks), error handling, and reusable components. Future-proofs for growth.
3.  **The "Over-Engineered" Approach:** Uses advanced libraries (e.g., React Query, Virtualized Tables) or complex patterns. best for massive scale but high initial complexity.

**Your Task:**
1.  Briefly describe these 3 options (Pros/Cons of each).
2.  Recommend which one fits our current "Mobile-First SaaS" stage best.
3.  **WAIT** for my confirmation on which approach to take before generating the code.

