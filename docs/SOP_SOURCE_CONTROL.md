# 🛡️ Source Control & CI/CD Protocol

## 1. The Environment Pipeline

| Environment | URL | Trigger Branch | Deployed By |
| :--- | :--- | :--- | :--- |
| **DEV** | `fresh-nest-dev` | `dev` | **Auto** (Push to dev) |
| **UAT** | `fresh-nest-uat` | `release/*` | **Script** (`release_to_uat.sh`) |
| **PROD** | `fresh-nest-prod` | `main` | **Script** (`promote_to_prod.sh`) |

## 2. Daily Workflow
1.  **Start:** `git checkout main` -> `git pull` -> `./scripts/start-feature.sh`
2.  **Work:** Commit often to `feature/...`
3.  **Test Cloud:** Run `./scripts/merge_to_dev.sh` to deploy to Dev.
4.  **Finish:** Run `./scripts/close_feature.sh` (or merge PR) to close.

## 3. Releases
* **To UAT:** Run `./scripts/release_to_uat.sh`
* **To Prod:** Run `./scripts/promote_to_prod.sh` (Must be on release branch)

## 4. Emergency Fixes (Hotfix)
1.  Branch from `main`: `git checkout -b fix/critical-bug main`
2.  Fix and Commit.
3.  Merge to `main` and `dev`.
