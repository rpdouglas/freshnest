#!/bin/bash

# ==========================================
# 🚀 FRESH NEST: DEEP CONTEXT GENERATOR
# ==========================================
# Generates a single markdown file containing the full source code
# of the application for AI analysis.

OUTPUT_FILE="docs/FULL_CODEBASE_CONTEXT.md"

# 1. Initialize the file
echo "🔄 Generating Context Dump..."
echo "# FRESH NEST: CODEBASE DUMP" > "$OUTPUT_FILE"
echo "**Date:** $(date)" >> "$OUTPUT_FILE"
echo "**Description:** Complete codebase context excluding modules and secrets." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 2. Helper Function to write file content safely
ingest_file() {
    local filepath="$1"
    
    # SECURITY CHECK: Skip if file matches sensitive patterns
    if [[ "$filepath" == *".env"* ]] || [[ "$filepath" == *"service-account"* ]] || [[ "$filepath" == *".DS_Store"* ]]; then
        return
    fi

    if [ -f "$filepath" ]; then
        echo "Processing: $filepath"
        
        # Markdown Header for the file
        echo "## FILE: $filepath" >> "$OUTPUT_FILE"
        echo "\`\`\`${filepath##*.}" >> "$OUTPUT_FILE" # Use extension for syntax highlighting
        
        # Cat the content
        cat "$filepath" >> "$OUTPUT_FILE"
        
        echo "" >> "$OUTPUT_FILE"
        echo "\`\`\`" >> "$OUTPUT_FILE"
        echo "---" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    fi
}

# 3. ROOT CONFIGURATION FILES (Explicit Allow-List)
# We only pick specific files from root to avoid scanning node_modules
echo "⚙️ Ingesting Root Configs..."
ingest_file "package.json"
ingest_file "vite.config.js"
ingest_file "tailwind.config.js"
ingest_file "postcss.config.js"
ingest_file "firebase.json"
ingest_file ".firebaserc"
ingest_file "index.html"
ingest_file ".gitignore"

# 4. SOURCE CODE (Recursive)
echo "💻 Ingesting src/ directory..."
# Find all code files, exclude standard noise
find src -type f \
    -not -path "*/.*" \
    \( -name "*.js" -o -name "*.jsx" -o -name "*.css" -o -name "*.json" \) \
    | sort | while read file; do ingest_file "$file"; done

# 5. DOCUMENTATION (Recursive)
echo "📄 Ingesting docs/ directory..."
find docs -type f -name "*.md" -not -name "FULL_CODEBASE_CONTEXT.md" | sort | while read file; do ingest_file "$file"; done

# 6. SCRIPTS (Recursive)
echo "Vg Ingesting scripts/ directory..."
find scripts -type f \( -name "*.js" -o -name "*.cjs" -o -name "*.sh" \) | sort | while read file; do ingest_file "$file"; done

echo "✅ SUCCESS! Context generated at: $OUTPUT_FILE"
echo "👉 Copy the contents of $OUTPUT_FILE and paste it into your AI chat."