#!/bin/bash

# ====================================================
# FRESH NEST: RELEASE MANAGER (With Version Bump)
# Goal: Bump version, tag it, and push to UAT
# ====================================================

# 1. Sync Dev
echo "🔄 Syncing Dev Branch..."
git checkout dev
git pull origin dev

# 2. Prompt for Version Bump
echo ""
echo "📊 Current Version: $(node -p "require('./package.json').version")"
echo "Select release type:"
echo "  1) Patch (0.1.0 -> 0.1.1) - Bug fixes"
echo "  2) Minor (0.1.0 -> 0.2.0) - New features"
echo "  3) Major (0.1.0 -> 1.0.0) - Breaking changes"
echo "  4) No Bump (Just redeploy current)"
read -p "Enter choice [1-4]: " choice

case $choice in
  1) npm version patch --no-git-tag-version ;;
  2) npm version minor --no-git-tag-version ;;
  3) npm version major --no-git-tag-version ;;
  4) echo "⚠️  Skipping version bump." ;;
  *) echo "❌ Invalid choice"; exit 1 ;;
esac

# 3. Read New Version
NEW_VERSION=$(node -p "require('./package.json').version")
BRANCH_NAME="release/v$NEW_VERSION"

echo ""
echo "🚀 Preparing Release: $BRANCH_NAME"

# 4. Commit the Version Bump (if changed)
if [ "$choice" != "4" ]; then
  git add package.json package-lock.json
  git commit -m "chore: bump version to $NEW_VERSION"
  git push origin dev
fi

# 5. Cut and Push Release Branch
git checkout -b "$BRANCH_NAME"
git push origin "$BRANCH_NAME"

echo ""
echo "✅ Release $NEW_VERSION Pushed!"
echo "👉 GitHub Action is now deploying to UAT."
echo "👉 Action: Merge this PR into 'main' later to deploy to PROD."
