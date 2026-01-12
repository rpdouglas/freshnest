# ☁️ DevOps & Infrastructure Manual

## 1. CI/CD Architecture
We use **GitHub Actions** for "Full Stack" deployments.
* **Workflows:** `.github/workflows/`
* **Triggers:** `dev` (Dev), `release/*` (UAT), `main` (Prod).

## 2. Environment Management
Scripts in `/scripts` handle data seeding. Always pass the env arg (e.g., `node scripts/init-org.cjs uat`).

## 3. GitHub Secrets (Required)
| Secret Name | Content |
| :--- | :--- |
| `FIREBASE_SERVICE_ACCOUNT_[ENV]` | JSON key for Firebase Admin |
| `ENV_FILE_[ENV]` | Full contents of `.env` |

## 4. Google Maps Setup (New Project)
If creating a new environment (e.g., Staging), you MUST:
1.  **GCP Console:** Enable "Maps JavaScript API" and "Geocoding API".
2.  **Billing:** Link the project to your Billing Account (Critical).
3.  **Credentials:** Create an API Key.
4.  **Secrets:** Add `VITE_GOOGLE_MAPS_API_KEY=...` to the `ENV_FILE_[ENV]` GitHub Secret.

## 5. Troubleshooting
**"Billing Not Setup" on Map:**
* Go to GCP Console -> Billing -> Link the project to your account.

**"Missing Permissions" in CI/CD:**
* Grant `firebase-adminsdk` Service Account "Editor" or "Cloud Datastore User" roles.
