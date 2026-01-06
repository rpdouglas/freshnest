#!/bin/bash

# ==========================================
# 🚀 FRESH NEST: FEATURE BRANCH STARTER
# ==========================================

# 1. Ensure we are on main and up to date
echo "🔄 Switching to main and syncing with remote..."
git checkout main
git pull origin main

if [ $? -ne 0 ]; then
    echo "❌ Error: Could not sync with main. Please check your internet or git status."
    exit 1
fi

# 2. Prompt for the feature name
echo ""
echo "📝 Enter a short description for this feature (e.g. 'Client List Page')"
read -p "Feature Name: " raw_input

# 3. Sanitize the input (Lower case, spaces to hyphens)
# Example: "Client List Page" -> "client-list-page"
clean_name=$(echo "$raw_input" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

# 4. Create and switch to the new branch
branch_name="feature/$clean_name"
echo ""
echo "🌿 Creating new branch: $branch_name"
git checkout -b "$branch_name"

echo ""
echo "✅ Ready to code! You are now on branch: $branch_name"
