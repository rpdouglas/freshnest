#!/bin/bash

# Stop on error
set -e

# 1. Validation: Must be on a Release Branch
current_branch=$(git branch --show-current)

if [[ "$current_branch" != release/* ]]; then
  echo "❌ ERROR: You must be on a 'release/...' branch to promote to Prod."
  echo "   Current branch: $current_branch"
  echo "   Use: git checkout release/vX.X.X"
  exit 1
fi

# Extract Version from Branch Name (e.g., release/v0.1.1 -> v0.1.1)
VERSION_TAG=${current_branch#release/}

echo "🚀 Promoting Release $VERSION_TAG to Production..."

# 2. Safety Check: Clean Working Directory
if [ -n "$(git status --porcelain)" ]; then 
  echo "❌ ERROR: Your working directory is not clean. Commit or stash changes first."
  exit 1
fi

# 3. Switch to Main and Update
echo "🔄 Switching to main..."
git checkout main
git pull origin main

# 4. Merge the Release Branch
echo "🔀 Merging $current_branch into main..."
git merge --no-ff "$current_branch" -m "chore(release): promote $VERSION_TAG to production"

# 5. Create Immutable Git Tag
echo "🏷️  Tagging release: $VERSION_TAG"
# Delete tag if exists locally (edge case) to prevent collision
if git rev-parse "$VERSION_TAG" >/dev/null 2>&1; then
    echo "   (Tag exists locally, replacing...)"
    git tag -d "$VERSION_TAG"
fi
git tag -a "$VERSION_TAG" -m "Production Release $VERSION_TAG"

# 6. Push to Main (Triggers PROD Action)
echo "⬆️  Pushing code and tags to GitHub..."
git push origin main
git push origin "$VERSION_TAG"

# 7. Cleanup
echo "🧹 Cleaning up local release branch..."
git branch -d "$current_branch"

echo ""
echo "✅ SUCCESS! Production Deployment Triggered."
echo "👉 GitHub Action 'Deploy to PROD' is running."
echo "👉 Release Tag: $VERSION_TAG created."
