#!/bin/bash

echo "📚 Performing Comprehensive Documentation Update..."

# ==========================================
# 1. UPDATE PROJECT STATUS
# ==========================================
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 2 - Core Workflows
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment.
* **Worker View (RBAC):** * "Ghost Client" fix (DB Lookup vs Token).
    * Role-Aware Hooks (`useJobs`, `useClients`).
    * UI Restrictions (Hidden Prices, Hidden Buttons).
* **DevOps:** * 3-Environment CI/CD (Dev/UAT/Prod) with Firestore Rules/Indexes.
    * Environment-aware seeding scripts.

## 🚧 In Progress / Next Up
* [ ] **Job Workflow:** Allow staff to mark jobs as "In Progress" / "Completed".
* [ ] **Job Edit/Delete:** Full CRUD for Admins.
* [ ] **Google Maps Integration:** Visualizing daily routes.

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, fullName, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, price, ... }
* `clients/{clientId}`: { name, address, orgId, ... }
INNER_EOF

# ==========================================
# 2. UPDATE CONTEXT DUMP (The Architectural Rules)
# ==========================================
echo "📝 Updating docs/CONTEXT_DUMP.md..."
cat << 'INNER_EOF' > docs/CONTEXT_DUMP.md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- **CRITICAL:** `orgId` is stored in the **Firestore User Profile** (`users/{uid}`).

## Schema (Implemented)
- **organizations/{orgId}**: { name, settings }
- **users/{userId}**: { email, orgId, role, fullName }
- **invites/{inviteId}**: { email, orgId, role }
- **jobs/{jobId}**: { assignedTo: [userId], status, serviceType, ... }

## Rules for AI (STRICT)
1. **NO PLACEHOLDERS:** Provide COMPLETE FILES only.
2. **Icons:** Use `lucide-react`.
3. **Tailwind:** Mobile-first (`block md:flex`).
4. **Security & Data Access (CRITICAL):**
   - **NEVER use `request.auth.token.orgId` (Custom Claims) in React Code.** It is stale.
   - **ALWAYS** fetch `users/{uid}` from Firestore to get the current `orgId`.
   - All Firestore queries MUST filter by `.where("orgId", "==", currentOrgId)`.
   - All writes MUST include `orgId`.
5. **Date Handling:** Use `date-fns`.
INNER_EOF

# ==========================================
# 3. UPDATE DEVOPS MANUAL
# ==========================================
echo "📝 Updating docs/DEVOPS_MANUAL.md..."
cat << 'INNER_EOF' > docs/DEVOPS_MANUAL.md
# ☁️ DevOps & Infrastructure Manual

## 1. CI/CD Architecture
We use **GitHub Actions** for "Full Stack" deployments.
* **Workflows:** `.github/workflows/`
* **What Deploys:** Hosting + Firestore Security Rules + Firestore Indexes.
* **Triggers:**
  * `dev` branch -> **Dev** Environment
  * `release/*` branch -> **UAT** Environment
  * `main` branch -> **Production** Environment

## 2. Environment Management
We use "Environment-Aware" scripts. You must pass the target environment (`dev`, `uat`, `prod`) as an argument.

### A. Initialization (New Env)
Sets up the Admin User and Organization.
\`\`\`bash
node scripts/init-org.cjs uat
\`\`\`

### B. Seeding Staff Users
Creates a test staff account linked to the Admin's Org.
\`\`\`bash
node scripts/create_staff_user.cjs uat
\`\`\`

## 3. GitHub Secrets (Required)
| Secret Name | Content |
| :--- | :--- |
| `FIREBASE_SERVICE_ACCOUNT_DEV` | JSON key for Dev |
| `FIREBASE_SERVICE_ACCOUNT_UAT` | JSON key for UAT |
| `FIREBASE_SERVICE_ACCOUNT_PROD` | JSON key for Prod |
| `ENV_FILE_DEV` | `.env.development` content |
| `ENV_FILE_UAT` | `.env.uat` content |
| `ENV_FILE_PROD` | `.env.production` content |

## 4. Troubleshooting
**"Missing Permissions" in CI/CD?**
* Go to Google Cloud IAM.
* Find the Service Account (e.g., `github-actions@...`).
* Grant it the **"Editor"** role (or specifically Firestore Admin + Service Usage Admin).

**"Staff User Not Seeing Data"?**
* Ensure you aren't using `auth.token.orgId`.
* Check Firestore `users/{uid}` to ensure `orgId` matches the data.
INNER_EOF

# ==========================================
# 4. UPDATE INITIALIZATION PROMPT
# ==========================================
echo "📝 Updating docs/PROMPT_INITIALIZATION.md..."
cat << 'INNER_EOF' > docs/PROMPT_INITIALIZATION.md
# 🤖 AI Session Initialization Prompt

**Instructions:**
1.  Run `scripts/generate-context.sh` to copy your current codebase.
2.  Paste the **Codebase Context** into the bottom of this prompt.
3.  Send the *entire* block below to your AI assistant.

---

**Role:** You are the Senior Lead Developer and Architect for "Fresh Nest," a React + Firebase SaaS application.

**Input:** I am providing the full codebase context below.

**Your Goal:** Ingest this context to completely understand our:
* **Tech Stack:** React (Vite), Tailwind CSS, Firebase (Auth, Firestore, Functions).
* **Architecture:** Multi-Tenant SaaS.
* **CRITICAL ARCHITECTURE RULE:** We do **NOT** rely on Custom Claims for `orgId` in the frontend. We fetch the Firestore Profile.

**Critical Rules for Interaction:**
1.  **NO Placeholders:** Never use `// ... rest of code`. Provide **COMPLETE FILES**.
2.  **Mobile First:** All UI must be fully responsive.
3.  **Icons:** Use `lucide-react`.
4.  **Security & Data:**
    * **NEVER** use `idTokenResult.claims.orgId`. Fetch the user profile from DB.
    * Every query MUST filter by `.where("orgId", "==", user.orgId)`.
    * Every write must include `orgId`.
5.  **Quality:**
    * All buttons/inputs must be functional.
    * Adhere to HTML best practices.

**Codebase Context:**
[PASTE_FULL_CODEBASE_CONTEXT_HERE]

**Reply "Context Received. Ready for instructions." if you understand.**
INNER_EOF

echo "✅ Documentation Suite Updated Successfully."
