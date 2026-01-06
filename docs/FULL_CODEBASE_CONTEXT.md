# FRESH NEST: CODEBASE DUMP
**Date:** Mon Jan  5 20:48:30 EST 2026
**Description:** Complete codebase context excluding modules and secrets.

## FILE: package.json
```json
{
  "name": "fresh-nest",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint .",
    "preview": "vite preview"
  },
  "dependencies": {
    "clsx": "^2.1.1",
    "date-fns": "^4.1.0",
    "firebase": "^12.7.0",
    "firebase-admin": "^13.6.0",
    "lucide-react": "^0.562.0",
    "react": "^19.2.0",
    "react-dom": "^19.2.0",
    "react-router-dom": "^7.11.0",
    "tailwind-merge": "^3.4.0",
    "uuid": "^13.0.0"
  },
  "devDependencies": {
    "@eslint/js": "^9.39.1",
    "@types/react": "^19.2.5",
    "@types/react-dom": "^19.2.3",
    "@vitejs/plugin-react": "^5.1.1",
    "autoprefixer": "^10.4.17",
    "eslint": "^9.39.1",
    "eslint-plugin-react-hooks": "^7.0.1",
    "eslint-plugin-react-refresh": "^0.4.24",
    "firebase-tools": "^15.1.0",
    "globals": "^16.5.0",
    "postcss": "^8.4.35",
    "tailwindcss": "^3.4.1",
    "vite": "^7.2.4"
  }
}

```
---

## FILE: vite.config.js
```js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
})

```
---

## FILE: tailwind.config.js
```js
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

```
---

## FILE: postcss.config.js
```js
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}

```
---

## FILE: .firebaserc
```firebaserc
{
  "projects": {
    "default": "fresh-nest-dev",
    "dev": "fresh-nest-dev",
    "uat": "fresh-nest-uat",
    "prod": "fresh-nest-prod"
  }
}

```
---

## FILE: index.html
```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>fresh-nest</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>

```
---

## FILE: .gitignore
```gitignore
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
pnpm-debug.log*
lerna-debug.log*

# Dependencies
node_modules
dist
dist-ssr
*.local

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs
*.njsproj
*.sln
*.sw?

# Firebase
.firebase/
firebase-debug.log
firestore-debug.log
ui-debug.log

# SECURITY: Environment Variables & Keys
# NEVER COMMIT THESE FILES
.env
.env.development
.env.uat
.env.production
.env.local

# SECURITY: Admin SDK Keys
scripts/service-account.json
```
---

## FILE: src/App.css
```css
#root {
  max-width: 1280px;
  margin: 0 auto;
  padding: 2rem;
  text-align: center;
}

.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.react:hover {
  filter: drop-shadow(0 0 2em #61dafbaa);
}

@keyframes logo-spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

@media (prefers-reduced-motion: no-preference) {
  a:nth-of-type(2) .logo {
    animation: logo-spin infinite 20s linear;
  }
}

.card {
  padding: 2em;
}

.read-the-docs {
  color: #888;
}

```
---

## FILE: src/App.jsx
```jsx
import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import AppLayout from './components/layout/AppLayout';
import AuthGuard from './components/layout/AuthGuard';
import LoginPage from './features/auth/LoginPage';
import DebugClaims from './components/debug/DebugClaims';

// Placeholder Pages
const Dashboard = () => (
  <div>
    <h2 className="text-2xl font-bold mb-4">My Jobs Today</h2>
    <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
      <p className="text-gray-500">No jobs scheduled yet.</p>
    </div>
    <DebugClaims />
  </div>
);

const Schedule = () => <h2 className="text-2xl font-bold">Schedule View</h2>;

function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Public Route */}
        <Route path="/login" element={<LoginPage />} />

        {/* Protected Routes */}
        <Route path="/" element={
          <AuthGuard>
            <AppLayout />
          </AuthGuard>
        }>
          <Route index element={<Dashboard />} />
          <Route path="schedule" element={<Schedule />} />
          {/* Catch-all redirects to home */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
```
---

## FILE: src/components/debug/DebugClaims.jsx
```jsx
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

```
---

## FILE: src/components/layout/AppLayout.jsx
```jsx
import React from 'react';
import { Outlet } from 'react-router-dom';
import Sidebar from './Sidebar';
import BottomNav from './BottomNav';

const AppLayout = () => {
  return (
    <div className="min-h-screen bg-gray-50 flex">
      <Sidebar />
      <main className="flex-1 md:ml-64 pb-20 md:pb-0">
        <div className="p-4 md:p-8 max-w-7xl mx-auto">
          {/* Mobile Header */}
          <header className="md:hidden flex justify-between items-center mb-6">
            <h1 className="text-xl font-bold text-brand-600">Fresh Nest</h1>
            <div className="w-8 h-8 bg-gray-200 rounded-full"></div>
          </header>
          <Outlet />
        </div>
      </main>
      <BottomNav />
    </div>
  );
};

export default AppLayout;

```
---

## FILE: src/components/layout/AuthGuard.jsx
```jsx
import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { onAuthStateChanged } from 'firebase/auth';
import { auth } from '../../lib/firebase';

const AuthGuard = ({ children }) => {
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      if (!currentUser) {
        navigate('/login');
      } else {
        setUser(currentUser);
      }
      setLoading(false);
    });

    return () => unsubscribe();
  }, [navigate]);

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-brand-600"></div>
      </div>
    );
  }

  return user ? children : null;
};

export default AuthGuard;
```
---

## FILE: src/components/layout/BottomNav.jsx
```jsx
import React from 'react';
import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Calendar, Menu } from 'lucide-react';

const BottomNav = () => {
  return (
    <nav className="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-6 py-3 flex justify-between items-center z-50">
      <NavLink 
        to="/" 
        className={({ isActive }) => `flex flex-col items-center gap-1 ${isActive ? 'text-brand-600' : 'text-gray-400'}`}
      >
        <LayoutDashboard size={24} />
        <span className="text-xs">Jobs</span>
      </NavLink>

      <NavLink 
        to="/schedule" 
        className={({ isActive }) => `flex flex-col items-center gap-1 ${isActive ? 'text-brand-600' : 'text-gray-400'}`}
      >
        <Calendar size={24} />
        <span className="text-xs">Schedule</span>
      </NavLink>

      <button className="flex flex-col items-center gap-1 text-gray-400">
        <Menu size={24} />
        <span className="text-xs">More</span>
      </button>
    </nav>
  );
};

export default BottomNav;

```
---

## FILE: src/components/layout/Sidebar.jsx
```jsx
import React from 'react';
import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Calendar, Users, Settings, LogOut } from 'lucide-react';

const Sidebar = () => {
  const navItems = [
    { icon: LayoutDashboard, label: 'Dashboard', path: '/' },
    { icon: Calendar, label: 'Schedule', path: '/schedule' },
    { icon: Users, label: 'Clients', path: '/clients' },
    { icon: Settings, label: 'Settings', path: '/settings' },
  ];

  return (
    <aside className="hidden md:flex flex-col w-64 bg-slate-800 text-white h-screen fixed left-0 top-0">
      <div className="p-6">
        <h1 className="text-2xl font-bold text-brand-500">Fresh Nest</h1>
        <p className="text-xs text-slate-400">Operations Manager</p>
      </div>
      
      <nav className="flex-1 px-4 space-y-2">
        {navItems.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            className={({ isActive }) =>
              `flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${
                isActive ? 'bg-brand-600 text-white' : 'text-slate-300 hover:bg-slate-700'
              }`
            }
          >
            <item.icon size={20} />
            <span>{item.label}</span>
          </NavLink>
        ))}
      </nav>

      <div className="p-4 border-t border-slate-700">
        <button className="flex items-center gap-3 px-4 py-2 text-slate-300 hover:text-white w-full">
          <LogOut size={20} />
          <span>Sign Out</span>
        </button>
      </div>
    </aside>
  );
};

export default Sidebar;

```
---

## FILE: src/features/auth/LoginPage.jsx
```jsx
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { createUserWithEmailAndPassword, signInWithEmailAndPassword } from 'firebase/auth';
import { auth } from '../../lib/firebase';
import { Lock, Mail, UserPlus, LogIn, AlertCircle } from 'lucide-react';

const LoginPage = () => {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleAuth = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      if (isLogin) {
        await signInWithEmailAndPassword(auth, email, password);
      } else {
        await createUserWithEmailAndPassword(auth, email, password);
      }
      navigate('/'); // Redirect to Dashboard on success
    } catch (err) {
      console.error(err);
      let msg = "An error occurred.";
      if (err.code === 'auth/invalid-credential') msg = "Invalid email or password.";
      if (err.code === 'auth/email-already-in-use') msg = "Email already in use.";
      if (err.code === 'auth/weak-password') msg = "Password should be at least 6 characters.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-brand-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl w-full max-w-md overflow-hidden">
        
        {/* Header */}
        <div className="bg-brand-600 p-8 text-center">
          <div className="mx-auto bg-white/20 w-16 h-16 rounded-full flex items-center justify-center mb-4 backdrop-blur-sm">
            <Lock className="text-white" size={32} />
          </div>
          <h1 className="text-2xl font-bold text-white">Fresh Nest</h1>
          <p className="text-brand-100">Operations Manager</p>
        </div>

        {/* Form */}
        <div className="p-8">
          <h2 className="text-xl font-bold text-slate-800 mb-6 text-center">
            {isLogin ? 'Welcome Back' : 'Create Account'}
          </h2>

          {error && (
            <div className="mb-4 p-3 bg-red-50 text-red-600 text-sm rounded-lg flex items-center gap-2">
              <AlertCircle size={16} />
              {error}
            </div>
          )}

          <form onSubmit={handleAuth} className="space-y-4">
            <div>
              <label className="block text-xs font-medium text-slate-500 mb-1 uppercase">Email Address</label>
              <div className="relative">
                <Mail className="absolute left-3 top-3 text-slate-400" size={20} />
                <input
                  type="email"
                  required
                  className="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500"
                  placeholder="name@company.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-medium text-slate-500 mb-1 uppercase">Password</label>
              <div className="relative">
                <Lock className="absolute left-3 top-3 text-slate-400" size={20} />
                <input
                  type="password"
                  required
                  className="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-brand-600 text-white py-3 rounded-lg font-semibold hover:bg-brand-700 transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
            >
              {loading ? 'Processing...' : (isLogin ? <><LogIn size={20} /> Sign In</> : <><UserPlus size={20} /> Create Account</>)}
            </button>
          </form>

          <div className="mt-6 text-center">
            <button
              onClick={() => setIsLogin(!isLogin)}
              className="text-sm text-slate-500 hover:text-brand-600 underline"
            >
              {isLogin ? "Don't have an account? Sign Up" : "Already have an account? Sign In"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
```
---

## FILE: src/index.css
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

html, body, #root {
  height: 100%;
}


```
---

## FILE: src/lib/firebase.js
```js
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getFunctions } from "firebase/functions";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
  measurementId: import.meta.env.VITE_FIREBASE_MEASUREMENT_ID
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const functions = getFunctions(app);

// Initialize Analytics only in browser context
export const analytics = typeof window !== 'undefined' ? getAnalytics(app) : null;

```
---

## FILE: src/main.jsx
```jsx
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)

```
---

## FILE: docs/CONTEXT_DUMP.md
```md
# Fresh Nest: Context Dump
**Stack:** React + Vite + Firebase (Auth, Firestore, Functions) + Tailwind CSS
**Architecture:** Multi-Tenant SaaS.
**Current State:**
- Auth is implemented (Login/Signup).
- User has `orgId` in Custom Claims.
- "fresh-nest-dev" Firestore is active.
- `AppLayout` is generic.

## Schema (Implemented)
- **organizations/{orgId}**: { name, plan, settings }
- **users/{userId}**: { email, orgId, role, fullName }

## Rules for AI
1. ALL code must be provided as COMPLETE FILES.
2. Use `lucide-react` for icons.
3. Tailwind Colors: `bg-brand-500` (Primary), `bg-slate-800` (Sidebar).
4. Security: All Firestore queries MUST filter by `where("orgId", "==", user.orgId)`.
```
---

## FILE: docs/PROMPT_INITIALIZATION.md
```md
# 🚀 AI Initialization Prompt

**Instructions:**
1.  Run `./scripts/generate-context.sh` to update your codebase context.
2.  Open a new AI Chat session (Gemini/ChatGPT).
3.  Copy the **Prompt Template** below.
4.  Replace the placeholder `[PASTE_FULL_CODEBASE_CONTEXT_HERE]` with the actual text content of `docs/FULL_CODEBASE_CONTEXT.md`.

---

### **Prompt Template**

**Role:** You are the Senior Lead Developer and Architect for "Fresh Nest," a React + Firebase SaaS application.

**Input:** I am providing the full codebase context below.

**Your Goal:** Ingest this context to completely understand our:
1.  **Tech Stack:** React (Vite), Tailwind CSS, Firebase (Auth, Firestore, Functions).
2.  **Architecture:** Multi-Tenant SaaS using `orgId` in Custom Claims for data isolation.
3.  **Current State:** File structure, existing components, and coding style.

**Critical Rules for Interaction:**
* **NO Placeholders:** Never use `// ... rest of code` or `// ... existing logic`. Always provide **COMPLETE, COPY-PASTEABLE FILES**.
* **Mobile First:** All UI must be fully responsive. Use Tailwind's `md:`, `lg:` prefixes.
* **Icons:** Use `lucide-react` for all icons.
* **Security:** Every Firestore query MUST filter by `where("orgId", "==", user.orgId)`. Every write must include `orgId`.
* **Style:** Use standard React Hooks patterns and clean, modular code.

**Codebase Context:**
[PASTE_FULL_CODEBASE_CONTEXT_HERE]

*Reply "Context Received. Ready for instructions." if you understand.*

```
---

## FILE: docs/SOP_SOURCE_CONTROL.md
```md
# 🛡️ Source Control & Development Protocol

**Version:** 1.0
**Last Updated:** 2026-01-05

## 1. The Golden Rules
1.  **NEVER commit directly to `main`.**
    * The `main` branch is "Production Ready." If it breaks, the app is broken.
2.  **NEVER commit API Keys or Secrets.**
    * Ensure `.env` files and `service-account.json` are always in `.gitignore`.
3.  **One Feature = One Branch.**
    * Do not mix "Fixing the CSS" with "Building the Database" in the same branch.

## 2. Branching Strategy

| Branch Prefix | Usage | Example |
| :--- | :--- | :--- |
| `main` | Production code only. Locked. | `main` |
| `feature/...` | New capabilities. | `feature/client-list` |
| `fix/...` | Bug repairs. | `fix/login-error` |
| `chore/...` | Maintenance (deps, docs). | `chore/update-readme` |

## 3. The Workflow Cycle

### Step 1: Sync & Start
Always pull the latest changes before starting.
```bash
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

### Step 2: Develop & Commit
Commit often locally. Use descriptive messages.
```bash
git add .
git commit -m "feat: implemented client table view"
```

### Step 3: Push & Merge
1.  Push your branch to GitHub.
    ```bash
    git push origin feature/your-feature-name
    ```
2.  Go to GitHub and open a **Pull Request (PR)**.
3.  Review the code (Self-Review).
4.  Merge into `main`.

## 4. Commit Message Convention
Follow this format to keep the history readable:
* **`feat:`** New features (e.g., `feat: added login page`)
* **`fix:`** Bug fixes (e.g., `fix: resolved css crash`)
* **`docs:`** Documentation only (e.g., `docs: added sop`)
* **`style:`** Formatting, missing semi-colons, etc.
* **`refactor:`** Refactoring code without changing logic.

## 5. Emergency Recovery
If you accidentally commit to `main` or commit a secret:
1.  **STOP.** Do not push.
2.  Reset the commit (keep changes): `git reset --soft HEAD~1`
3.  Fix the issue (remove the secret or switch branches).

```
---

## FILE: scripts/generate-context.sh
```sh
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
```
---

## FILE: scripts/init-org.cjs
```cjs
/**
 * scripts/init-org.js
 * USAGE: 
 * 1. Ensure service-account.json is in this folder.
 * 2. Run: node scripts/init-org.js
 */

const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json');

// --- CONFIGURATION ---
const TARGET_EMAIL = "rpdouglas@gmail.com"; // <--- 🔴 PUT YOUR EMAIL HERE
const ORG_NAME = "Fresh Nest HQ"; 
// ---------------------

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const auth = admin.auth();

async function bootstrap() {
  try {
    console.log(`🚀 Starting bootstrap for: ${TARGET_EMAIL}`);

    // 1. Find the user
    const user = await auth.getUserByEmail(TARGET_EMAIL);
    console.log(`✅ Found User: ${user.uid}`);

    // 2. Create the Organization
    const orgRef = await db.collection('organizations').add({
      name: ORG_NAME,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      plan: 'gold',
      settings: {
        currency: 'USD',
        geoFenceRadius: 200
      }
    });
    console.log(`✅ Created Organization: ${orgRef.id}`);

    // 3. Update the User Profile (Firestore)
    // We create a public profile for this user so we can find them easily later
    await db.collection('users').doc(user.uid).set({
      email: user.email,
      orgId: orgRef.id,
      role: 'admin',
      fullName: 'Admin User',
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
    console.log(`✅ Created User Profile in Firestore`);

    // 4. Set Custom Claims (The "Magic" Token)
    // This allows the frontend to know their role without querying the DB
    await auth.setCustomUserClaims(user.uid, {
      orgId: orgRef.id,
      role: 'admin'
    });
    console.log(`✅ Claims set on Auth Token!`);

    console.log("\n🎉 SUCCESS! You must Sign Out and Sign In again on the app to refresh your token.");

  } catch (error) {
    console.error("❌ Error:", error.message);
  }
}

bootstrap();
```
---

## FILE: scripts/start-feature.sh
```sh
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

```
---

