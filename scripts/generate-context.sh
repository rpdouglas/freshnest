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
