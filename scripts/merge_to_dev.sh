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
echo "👉 Check status here: https://github.com/rpdouglas/fresh-nest/actions"
