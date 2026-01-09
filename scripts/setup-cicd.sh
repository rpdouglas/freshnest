#!/bin/bash

# ====================================================
# FRESH NEST: CI/CD PIPELINE INSTALLER
# Sets up GitHub Actions for Dev, UAT, and Prod
# ====================================================

echo "🚀 Setting up GitHub Actions Workflows..."

# 1. Create the Workflows Directory
mkdir -p .github/workflows

# 2. Create DEV Pipeline
echo "📝 Writing .github/workflows/deploy-dev.yml..."
cat << 'EOF' > .github/workflows/deploy-dev.yml
name: Deploy to DEV

on:
  push:
    branches:
      - dev

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'development'

      - name: Deploy to Firebase Hosting (DEV)
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_DEV }}'
          channelId: live
          projectId: fresh-nest-dev
EOF

# 3. Create UAT Pipeline (Release Branches)
echo "📝 Writing .github/workflows/deploy-uat.yml..."
cat << 'EOF' > .github/workflows/deploy-uat.yml
name: Deploy to UAT

on:
  push:
    branches:
      - 'release/**'

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'uat'

      - name: Deploy to Firebase Hosting (UAT)
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_UAT }}'
          channelId: live
          projectId: fresh-nest-uat
EOF

# 4. Create PROD Pipeline (Main Branch)
echo "📝 Writing .github/workflows/deploy-prod.yml..."
cat << 'EOF' > .github/workflows/deploy-prod.yml
name: Deploy to PROD

on:
  push:
    branches:
      - main

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'production'

      - name: Deploy to Firebase Hosting (PROD)
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_PROD }}'
          channelId: live
          projectId: fresh-nest-prod
EOF

# 5. Create Local Helper Script
echo "📝 Writing scripts/merge_to_dev.sh..."
cat << 'EOF' > scripts/merge_to_dev.sh
#!/bin/bash
# Merges current feature into 'dev' and pushes to GitHub to trigger CI

current_branch=$(git branch --show-current)

if [ "$current_branch" == "dev" ] || [ "$current_branch" == "main" ]; then
  echo "❌ You are on $current_branch. Please checkout a feature branch first."
  exit 1
fi

echo "🚀 Merging $current_branch into dev..."

# 1. Switch to dev and pull latest
git checkout dev
git pull origin dev

# 2. Merge Feature
git merge "$current_branch"

# 3. Push to GitHub (TRIGGERS GITHUB ACTION for DEV)
git push origin dev

# 4. Return to feature branch
git checkout "$current_branch"

echo "✅ Merged and Pushed! GitHub Action is now deploying to Fresh-Nest-Dev."
echo "👉 Check status here: https://github.com/YOUR_GITHUB_USERNAME/fresh-nest/actions"
EOF

chmod +x scripts/merge_to_dev.sh

echo "✅ SUCCESS! CI/CD Pipelines Installed."
echo "👉 Run: git add . && git commit -m 'chore: setup github actions' && git push origin main"