This is the most critical step for a professional workflow. Getting your `.gitignore` wrong can lead to leaking your API keys or your Admin Service Account to the public.

Here is the complete setup to lock down your repository and connect it to GitHub.

### 1. Create the Security Files

Run these commands in your project root (`fresh-nest/`) to create the necessary files.

#### **A. The `.gitignore` (Critical Security)**

This file tells Git what **NOT** to upload. We must ensure your environment keys and service accounts never leave your computer.

Create a file named `.gitignore` and paste this content:

```text
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

#### **B. The `README.md**`

This serves as the landing page for your repo.

Create a file named `README.md` and paste this content:

```markdown
# Fresh Nest 🧹

A mobile-first SaaS Operations Manager for residential and commercial cleaning companies.

## 🏗 Tech Stack
- **Frontend:** React + Vite + Tailwind CSS
- **Backend:** Firebase (Auth, Firestore, Functions)
- **Deployment:** GitHub Actions -> Firebase Hosting
- **Architecture:** Multi-Tenant SaaS (Custom Claims)

## 🚀 Environment Setup

### Prerequisites
1. Node.js (v20+)
2. Firebase CLI (`npm install -g firebase-tools`)

### Installation
1. Clone the repo:
   ```bash
   git clone [https://github.com/YOUR_USERNAME/freshnest.git](https://github.com/YOUR_USERNAME/freshnest.git)

```

2. Install dependencies:
```bash
npm install

```


3. Configure Environment:
* Create `.env.development` with your Firebase Dev keys.
* Add `scripts/service-account.json` for backend scripts.



### Running Locally

```bash
npm run dev

```

## 🌳 Branching Strategy

* `main` -> Production (Locked)
* `feature/*` -> Development (PRs required)

```

---

### 2. Connect to GitHub (Terminal Commands)

Since you already have the empty repo `freshnest` created on GitHub, follow these steps to upload your code.

**Step 1: Initialize and Commit**
Open your terminal in `fresh-nest/`.

```bash
# 1. Initialize Git (if you haven't already)
git init

# 2. Add all files (This respects your new .gitignore)
git add .

# 3. Create the first commit
git commit -m "Initial commit: Fresh Nest scaffold + Auth + Security setup"

```

**Step 2: Link to Remote**
Replace `YOUR_USERNAME` with your actual GitHub username.

```bash
# 1. Rename the default branch to main (Standard practice)
git branch -M main

# 2. Link your local folder to the empty GitHub repo
git remote add origin https://github.com/YOUR_USERNAME/freshnest.git

# 3. Push your code
git push -u origin main

```

---

### 3. Source Control SOP (Standard Operating Procedure)

To keep your project clean and avoid "merge conflicts" (where code overwrites other code), follow these three golden rules.

#### **Rule 1: Never Code on Main**

The `main` branch is your "Safety Copy." If you break `main`, you break the app. Always create a new branch for every task.

* **Bad:** Editing `App.jsx` while on the `main` branch.
* **Good:** `git checkout -b feature/client-list`

#### **Rule 2: The "Feature Branch" Workflow**

Every time you start a new feature (like the "Client List" we are about to build), run this cycle:

1. **Sync:** Make sure you are starting from the latest code.
```bash
git checkout main
git pull origin main

```


2. **Branch:** Create a name describing the feature.
```bash
git checkout -b feature/client-list

```


3. **Code & Commit:**
```bash
git add .
git commit -m "feat: Added client list page and hooks"

```


4. **Push:**
```bash
git push origin feature/client-list

```


5. **Merge:** Go to GitHub, open a **Pull Request**, and merge it into `main`.

#### **Rule 3: Commit Messages Matter**

Use these prefixes to make your history readable:

* `feat:` for new features (e.g., `feat: added login page`)
* `fix:` for bug fixes (e.g., `fix: resolved css crash`)
* `docs:` for documentation updates
* `chore:` for maintenance (e.g., `chore: updated dependencies`)

---

