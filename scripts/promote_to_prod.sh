#!/bin/bash

# ====================================================
# FRESH NEST: PROD PROMOTER
# Goal: Merge the active Release branch into Main
# ====================================================

current_branch=$(git branch --show-current)

# Ensure we are on a release branch
if [[ "$current_branch" != release/* ]]; then
  echo "❌ You must be on a 'release/...' branch to promote to Prod."
  echo "   Current: $current_branch"
  exit 1
fi

echo "🚀 Promoting $current_branch to Production..."

# 1. Switch to Main and Sync
git checkout main
git pull origin main

# 2. Merge the Release
git merge "$current_branch"

# 3. Push to Main (Triggers PROD Action)
git push origin main

echo "✅ Promoted to Prod!"
echo "👉 GitHub Action is now deploying to Fresh-Nest-Prod."
