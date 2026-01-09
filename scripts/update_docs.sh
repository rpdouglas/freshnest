#!/bin/bash

echo "📚 Updating Documentation Suite..."

# 1. Update Context Generator to include Workflows
# We want the AI to be able to see your CI/CD pipelines in future sessions.
echo "⚙️ Updating scripts/generate-context.sh..."
cat << 'INNER_EOF' > scripts/generate-context.sh
#!/bin/bash

OUTPUT_FILE="docs/FULL_CODEBASE_CONTEXT.md"

echo "🔄 Generating Context Dump..."
echo "# FRESH NEST: CODEBASE DUMP" > "\$OUTPUT_FILE"
echo "**Date:** \$(date)" >> "\$OUTPUT_FILE"
echo "**Description:** Complete codebase context." >> "\$OUTPUT_FILE"
echo "" >> "\$OUTPUT_FILE"

ingest_file() {
    local filepath="\$1"
    if [[ "\$filepath" == *".env"* ]] || [[ "\$filepath" == *"service-account"* ]] || [[ "\$filepath" == *".DS_Store"* ]]; then return; fi
    if [ -f "\$filepath" ]; then
        echo "Processing: \$filepath"
        echo "## FILE: \$filepath" >> "\$OUTPUT_FILE"
        echo "\`\`\`\${filepath##*.}" >> "\$OUTPUT_FILE"
        cat "\$filepath" >> "\$OUTPUT_FILE"
        echo "" >> "\$OUTPUT_FILE"
        echo "\`\`\`" >> "\$OUTPUT_FILE"
        echo "---" >> "\$OUTPUT_FILE"
        echo "" >> "\$OUTPUT_FILE"
    fi
}

# Root Configs
ingest_file "package.json"
ingest_file "vite.config.js"
ingest_file "tailwind.config.js"
ingest_file "firebase.json"
ingest_file ".firebaserc"

# Source Code
find src -type f -not -path "*/.*" | sort | while read file; do ingest_file "\$file"; done

# Documentation
find docs -type f -name "*.md" -not -name "FULL_CODEBASE_CONTEXT.md" | sort | while read file; do ingest_file "\$file"; done

# Scripts
find scripts -type f \( -name "*.js" -o -name "*.cjs" -o -name "*.sh" \) | sort | while read file; do ingest_file "\$file"; done

# CI/CD Workflows (NEW)
find .github/workflows -type f -name "*.yml" | sort | while read file; do ingest_file "\$file"; done

echo "✅ Context Generated at: \$OUTPUT_FILE"
INNER_EOF
chmod +x scripts/generate-context.sh

# 2. Update Project Status
echo "📝 Updating docs/PROJECT_STATUS.md..."
cat << 'INNER_EOF' > docs/PROJECT_STATUS.md
# 📌 Project Status: Fresh Nest

**Current Phase:** Phase 1 Complete / Infrastructure Mature
**Last Updated:** $(date +%Y-%m-%d)

## ✅ Completed Features
* **Core:** Project Setup, Auth, Multi-Tenancy (Profile-based).
* **Clients:** CRUD, Filtering, Mobile/Desktop Views.
* **Jobs:** Scheduling, Relational Data, Assignment (`useStaff`).
* **DevOps (NEW):** * 3-Environment CI/CD (Dev/UAT/Prod).
    * Automated Build Versioning.
    * Secret Injection via GitHub Actions.

## 🚧 In Progress / Next Up
* [ ] **Worker View:** Restricted dashboard for staff.
* [ ] **Job Workflow:** Status transitions (Start/Finish).

## 🗄️ Database Schema
* `organizations/{orgId}`
* `users/{userId}`: { role: 'admin'|'staff', orgId, ... }
* `jobs/{jobId}`: { assignedTo: [userId], status, ... }
INNER_EOF

# 3. Update SOP (Source Control)
echo "📝 Updating docs/SOP_SOURCE_CONTROL.md..."
cat << 'INNER_EOF' > docs/SOP_SOURCE_CONTROL.md
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
INNER_EOF

# 4. Create DevOps Manual (NEW)
echo "📝 Creating docs/DEVOPS_MANUAL.md..."
cat << 'INNER_EOF' > docs/DEVOPS_MANUAL.md
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
INNER_EOF

echo "✅ Documentation Updated Successfully."
echo "👉 You should commit these changes now."
