# 🛡️ Source Control & Development Protocol

**Version:** 1.0
**Last Updated:** 2026-01-05

## 1. The Golden Rules
1.  **NEVER commit directly to `main`.**
    * The `main` branch is "Production Ready." If it breaks, the app is broken.
2.  **NEVER commit API Keys or Secrets.**
    * Ensure `.env` files and `service-account.json` are always in `.gitignore`.
3.  **One Feature = One Branch.**
    * Do not mix "Fixing the CSS" with "Building the Database" in the same branch.

## 2. Branching Strategy

| Branch Prefix | Usage | Example |
| :--- | :--- | :--- |
| `main` | Production code only. Locked. | `main` |
| `feature/...` | New capabilities. | `feature/client-list` |
| `fix/...` | Bug repairs. | `fix/login-error` |
| `chore/...` | Maintenance (deps, docs). | `chore/update-readme` |

## 3. The Workflow Cycle

### Step 1: Sync & Start
Always pull the latest changes before starting.
```bash
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

### Step 2: Develop & Commit
Commit often locally. Use descriptive messages.
```bash
git add .
git commit -m "feat: implemented client table view"
```

### Step 3: Push & Merge
1.  Push your branch to GitHub.
    ```bash
    git push origin feature/your-feature-name
    ```
2.  Go to GitHub and open a **Pull Request (PR)**.
3.  Review the code (Self-Review).
4.  Merge into `main`.

## 4. Commit Message Convention
Follow this format to keep the history readable:
* **`feat:`** New features (e.g., `feat: added login page`)
* **`fix:`** Bug fixes (e.g., `fix: resolved css crash`)
* **`docs:`** Documentation only (e.g., `docs: added sop`)
* **`style:`** Formatting, missing semi-colons, etc.
* **`refactor:`** Refactoring code without changing logic.

## 5. Emergency Recovery
If you accidentally commit to `main` or commit a secret:
1.  **STOP.** Do not push.
2.  Reset the commit (keep changes): `git reset --soft HEAD~1`
3.  Fix the issue (remove the secret or switch branches).
