# ☁️ DevOps & Infrastructure Manual

## 1. CI/CD Architecture
We use **GitHub Actions** for all deployments.
* **Workflows:** Located in `.github/workflows/`
* **Secrets:** Managed in GitHub Repo Settings -> Secrets -> Actions.

## 2. GitHub Secrets (Required)
If setting up a new repo, these secrets must be present:

| Secret Name | Content |
| :--- | :--- |
| `FIREBASE_SERVICE_ACCOUNT_DEV` | JSON key for Dev Project |
| `FIREBASE_SERVICE_ACCOUNT_UAT` | JSON key for UAT Project |
| `FIREBASE_SERVICE_ACCOUNT_PROD` | JSON key for Prod Project |
| `ENV_FILE_DEV` | Content of local `.env.development` |
| `ENV_FILE_UAT` | Content of local `.env.uat` |
| `ENV_FILE_PROD` | Content of local `.env.production` |

## 3. Versioning
* **SemVer:** Manually managed in `package.json` (e.g., `0.1.0`).
* **Build Number:** Auto-incremented via `scripts/increment-build.cjs` on every cloud build.
* **Git Hash:** Injected into the app footer for debugging.

## 4. Troubleshooting
**"Invalid API Key" in Production?**
* Check that `ENV_FILE_PROD` in GitHub Secrets is not empty.
* Check that the variable names in the secret start with `VITE_`.
* Re-run the workflow in the GitHub Actions tab.
