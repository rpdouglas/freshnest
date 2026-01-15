# ✅ AI Approval & Execution Prompt (v9.0 Persona-Aware)

**Instructions:**
Use this prompt **after** the AI has presented the 3 Architectural Options. This signals approval for the **Recommended (Robust)** approach and enforces strict **Persona & Compliance** standards.

---

### **Prompt Template**

**Decision:** I approve the **Recommended (Robust) Approach**. Proceed with implementation.

**Strict Technical Constraints (The "Fresh Nest" Standard):**
1.  **React & Accessibility:** * Use functional components with **Icon-First Design** (Lucide React).
    * Ensure all text is wrapped for future **Localization (i18n)**.
    * **Mobile First:** Tailwind classes must be `block md:flex`.
2.  **Firebase & Security (CRITICAL):**
    * **NO AUTH TOKENS:** Do NOT use `idTokenResult` or `request.auth.token` for logic. Fetch the **User Profile** from Firestore.
    * **Privacy Map:** Adhere to strict visibility rules. (e.g., Financials are private to the user + Admin).
    * **Writes:** ALL `addDoc`/`updateDoc` calls must include `orgId` and `updatedAt` (serverTimestamp).
3.  **Code Quality:** No "placeholder" code. Complete files only.

**Persona & Compliance Checks (Mandatory):**
* **The "Ahmed" Check (Learner):** Is the UI simple enough? Did we rely too much on dense text?
* **The "Carla" Check (Financial):** Does this feature respect the **Earnings Cap** logic? (Never allow work that exceeds the limit).
* **The "Sarah" Check (Admin):** Is there an Audit Trail? (Who changed what and when?).

**Output Requirements:**

1.  **The "One-Shot" Installer:**
    * Provide a single bash script named `scripts/install_feature.sh`.
    * This script must use `cat << 'EOF' > path/to/file` to safely create/overwrite files.
    * *Note:* Escape special characters (`$`) in the bash script correctly.

2.  **QA Checklist (Manual Testing):**
    * Provide 3-5 specific tests.
    * **Mandatory:** Include a **"Persona Audit"** (e.g., "Log in as a Worker with a $500 cap -> Verify 'Claim' button is disabled if job > cap").
    * **Mandatory:** Include a **"Data Integrity"** test (e.g., "Verify Firestore Contract Ledger has the rate snapshot").

3.  **Firestore Indexes:**
    * Explicitly state if `firestore.indexes.json` needs an update.

4.  **Git Documentation:**
    * Provide a **Git Commit Comment Block** at the end.
    * Format: `feat: [summary]`, Description: Bullet points of changes.

*Please generate the installation script, test checklist, and git docs now.*
