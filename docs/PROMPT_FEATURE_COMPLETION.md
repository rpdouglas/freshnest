# ✅ Feature Completion & Release Protocol

**Instructions:**
1.  When you have finished testing a feature in DEV and are ready to merge.
2.  Copy the **Prompt Template** below.
3.  Fill in the `[ ... ]` brackets.
4.  Paste it into the AI Chat.

---

### **Prompt Template**

**Action:** Close Feature & Prepare Release
**Feature Name:** [INSERT FEATURE NAME, e.g., Job Assignment]
**Current Branch:** [INSERT BRANCH NAME, e.g., feature/job-assignment]

**Context:**
I have successfully implemented and tested this feature in the DEV environment. It is ready to be merged into `main` and documented.

**Your Task:**
Please generate a single "Close-Out Script" (`scripts/close_feature.sh`) that performs the following actions:

1.  **Documentation Updates:**
    * Update `docs/PROJECT_STATUS.md`: Move the feature from "In Progress" to "Completed".
    * Update `docs/CONTEXT_DUMP.md`: If the schema or architecture changed, update the definitions to match the new reality.
    * *Note:* Use `cat << 'EOF'` to overwrite these files with the updated content.

2.  **Git Workflow:**
    * Stage and Commit any remaining changes.
    * Switch to `main`.
    * Pull the latest `main`.
    * Merge the feature branch.
    * Push `main` to origin.
    * Delete the local feature branch.

3.  **Deployment (UAT):**
    * Run the build script (to increment the version number).
    * Deploy the `main` branch to the **UAT** environment (`firebase deploy --only hosting:uat,firestore:rules`).

**Output Requirement:**
Provide the complete, executable bash script. Do not execute it yourself; just provide the code.
