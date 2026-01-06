#!/bin/bash

echo "🔧 Starting Repair: CSS & Firebase..."

# ---------------------------------------------------------
# 1. FIX FIREBASE "NO APP" ERROR
# ---------------------------------------------------------
echo "🔥 Fixing DebugClaims.jsx imports..."

# We need to import 'auth' from our INITIALIZED lib file, 
# not the raw SDK.

cat <<EOF > src/components/debug/DebugClaims.jsx
import React, { useEffect, useState } from 'react';
// IMPORT FROM YOUR LIB, NOT THE SDK DIRECTLY
import { auth } from '../../lib/firebase'; 

const DebugClaims = () => {
  const [claims, setClaims] = useState(null);
  const [env, setEnv] = useState(import.meta.env.VITE_APP_ENV);

  useEffect(() => {
    const checkClaims = async () => {
      // Use the 'auth' instance we imported
      const user = auth.currentUser;
      if (user) {
        // Force refresh to get latest claims
        const tokenResult = await user.getIdTokenResult(true);
        setClaims(tokenResult.claims);
      }
    };

    // Check immediately and also set up a listener
    const unsubscribe = auth.onAuthStateChanged((user) => {
      if (user) {
        checkClaims();
      } else {
        setClaims(null);
      }
    });

    return () => unsubscribe();
  }, []);

  return (
    <div className="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded text-xs text-yellow-800 font-mono overflow-auto">
      <p className="mb-2"><strong>Environment:</strong> {env?.toUpperCase()}</p>
      {claims ? (
        <pre>{JSON.stringify(claims, null, 2)}</pre>
      ) : (
        <p>No User Signed In / No Claims Found</p>
      )}
    </div>
  );
};

export default DebugClaims;
EOF

# ---------------------------------------------------------
# 2. FIX TAILWIND (FORCE V3 & CONFIG)
# ---------------------------------------------------------
echo "🎨 Fixing Tailwind Configuration..."

# Ensure PostCSS Config exists (Vital for Vite)
cat <<EOF > postcss.config.js
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# Ensure Tailwind Config has the correct content paths
cat <<EOF > tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          500: '#0ea5e9', // Sky Blue (Primary)
          600: '#0284c7',
          900: '#0c4a6e',
        },
        slate: {
          800: '#1e293b', 
        }
      }
    },
  },
  plugins: [],
}
EOF

# ---------------------------------------------------------
# 3. REINSTALL DEPENDENCIES (Force Stable Versions)
# ---------------------------------------------------------
echo "📦 Re-installing CSS dependencies to ensure version match..."

# Uninstall current tailwind to remove v4 if present
npm uninstall tailwindcss postcss autoprefixer

# Install specific v3 versions
npm install -D tailwindcss@3.4.1 postcss@8.4.35 autoprefixer@10.4.17

echo "✅ Repair Complete."
echo "👉 Please restart your development server:"
echo "   Ctrl + C, then 'npm run dev'"