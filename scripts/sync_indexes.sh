#!/bin/bash

# ====================================================
# FRESH NEST: FIRESTORE INDEX SYNCHRONIZER
# Goal: Pull indexes from DEV (Source of Truth) and promote them.
# ====================================================

# 1. Pull from DEV
echo "⬇️  Fetching Indexes from 'fresh-nest-dev'..."
npx firebase firestore:indexes --project fresh-nest-dev > firestore.indexes.json

if [ $? -eq 0 ]; then
  echo "✅ Indexes saved to firestore.indexes.json"
else
  echo "❌ Failed to fetch indexes. Check your internet or permissions."
  exit 1
fi

# 2. Review (Optional Pause)
echo ""
echo "👀 Content of firestore.indexes.json (First 10 lines):"
head -n 10 firestore.indexes.json
echo "..."
echo ""

# 3. Deploy to UAT
echo "🚀 Deploying Indexes to UAT (fresh-nest-uat)..."
npx firebase deploy --only firestore:indexes --project fresh-nest-uat

# 4. Deploy to PROD (Optional - Uncomment to auto-deploy to prod)
# echo "🚀 Deploying Indexes to PROD (fresh-nest-prod)..."
# npx firebase deploy --only firestore:indexes --project fresh-nest-prod

# 5. Commit to Git
echo "🌿 Committing updated index definitions..."
git add firestore.indexes.json
git commit -m "chore: sync firestore indexes from dev cloud"

echo "🎉 Indexes Synced!"
