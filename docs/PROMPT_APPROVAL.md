# ✅ AI Approval & Execution Prompt

**Instructions:**
Use this prompt **after** the AI has presented the 3 Architectural Options. This signals approval for the **Recommended (Robust)** approach and enforces strict coding standards.

---

### **Prompt Template**

**Decision:** I approve the **Recommended (Robust) Approach**. Proceed with implementation.

**Strict Technical Constraints (Best Practices):**
1.  **React:** Use functional components. Isolate logic in Custom Hooks (e.g., `useJobWorkflow`).
2.  **Tailwind:** Use mobile-first classes (`block md:flex`). Avoid arbitrary values (e.g., `w-[350px]`) — use the theme.
3.  **Firebase & Security (CRITICAL):**
    * **NO AUTH TOKENS:** Do NOT use `idTokenResult` or `request.auth.token` to get `orgId` or `role`. You MUST fetch the **User Profile** from Firestore.
    * **Isolation:** ALL `onSnapshot` queries must filter by `.where("orgId", "==", currentOrgId)`.
    * **Writes:** ALL `addDoc`/`updateDoc` calls must be strictly validated.
    * **Timestamps:** Use `serverTimestamp()` for `createdAt`/`updatedAt`.
4.  **Code Quality:** No "placeholder" code. Complete files only.

**Output Requirements:**

1.  **The "One-Shot" Installer:**
    * Provide a single bash script named `scripts/install_feature.sh`.
    * This script must use `cat << 'EOF' > path/to/file` to safely create/overwrite files.
    * *Note:* Ensure you escape special characters (`$`) in the bash script correctly so the React code generates properly.

2.  **QA Checklist (Manual Testing):**
    * Provide 3-5 specific tests.
    * **Mandatory:** Include a **"Role Switching"** test (e.g., "Log in as Staff -> Verify Button X is hidden").
    * **Mandatory:** Include a **"Data Integrity"** test (e.g., "Verify Firestore document has 'startedAt' timestamp").

3.  **Firestore Indexes (If applicable):**
    * If your queries use `orderBy`, explicitly state if a new entry is needed in `firestore.indexes.json`.

4.  **Git Documentation:**
    * Provide a **Git Commit Comment Block** at the end.
    * Format:
        * **Message:** `feat: [summary]`
        * **Description:** Bullet points of changes.

*Please generate the installation script, test checklist, and git docs now.*
