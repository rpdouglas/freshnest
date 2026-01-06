# ✅ AI Approval & Execution Prompt

**Instructions:**
Use this prompt **after** the AI has presented the 3 Architectural Options. This signals approval for the **Recommended (Robust)** approach and enforces strict coding standards.

---

### **Prompt Template**

**Decision:** I approve the **Recommended (Robust) Approach**. Proceed with implementation.

**Strict Technical Constraints (Best Practices):**
1.  **React:** Use functional components and proper Hook dependency arrays. Isolate logic in Custom Hooks.
2.  **Tailwind:** Use mobile-first classes (`block md:flex`). Avoid arbitrary values (e.g., `w-[350px]`) — use the theme.
3.  **Firebase:**
    * **Security:** ALL `addDoc` calls must include `orgId`. ALL `onSnapshot` queries must filter by `orgId`.
    * **Timestamps:** Use `serverTimestamp()` for `createdAt` fields.
4.  **Code Quality:** No "placeholder" code. Complete files only.

**Output Requirements:**

1.  **The "One-Shot" Installer:**
    * Provide a single bash script named `scripts/install_feature.sh`.
    * This script must use `cat << 'EOF' > path/to/file` to safely create the directories and write the file contents.
    * *Note:* Ensure you escape special characters in the bash script correctly so the React code generates properly.

2.  **Git Documentation:**
    * At the end of your response, provide a **Git Commit Comment Block**.
    * Format:
        * **Branch:** (Verify we are on `feature/...`)
        * **Message:** `feat: [summary]`
        * **Description:** Bullet points of changes.

*Please generate the installation script and git docs now.*
