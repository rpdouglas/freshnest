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
