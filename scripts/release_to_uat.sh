#!/bin/bash

# ====================================================
# FRESH NEST: RELEASE MANAGER
# Goal: Cut a release branch from DEV and push to UAT
# ====================================================

# 1. Sync Dev
echo "🔄 Syncing Dev..."
git checkout dev
git pull origin dev

# 2. Generate Version Name (Time-based for now)
# In the future, we can use semantic versioning (v0.1.1, etc)
version="v0.1.0-rc-$(date +%s)"
branch_name="release/$version"

echo "🌿 Creating Release Branch: $branch_name"
git checkout -b "$branch_name"

# 3. Push to GitHub (Triggers UAT Action)
echo "🚀 Pushing to UAT..."
git push origin "$branch_name"

echo "✅ Release Pushed!"
echo "👉 GitHub Action is now deploying to Fresh-Nest-UAT."
echo "👉 When UAT is verified, merge this PR into 'main' to deploy to PROD."
