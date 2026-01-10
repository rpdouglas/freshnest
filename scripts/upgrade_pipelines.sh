#!/bin/bash

echo "🚀 Upgrading CI/CD Pipelines to include Firestore..."

# 1. Update DEV Pipeline
cat << 'INNER_EOF' > .github/workflows/deploy-dev.yml
name: Deploy to DEV

on:
  push:
    branches:
      - dev

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      # 1. Inject Secrets
      - name: Create .env and Key Files
        run: |
          echo "${{ secrets.ENV_FILE_DEV }}" > .env
          echo '${{ secrets.FIREBASE_SERVICE_ACCOUNT_DEV }}' > service-account.json

      # 2. Build App
      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'development'

      # 3. Full Deployment (Hosting + Firestore)
      - name: Deploy to Firebase
        run: npx firebase deploy --project fresh-nest-dev --non-interactive
        env:
          GOOGLE_APPLICATION_CREDENTIALS: 'service-account.json'
INNER_EOF

# 2. Update UAT Pipeline
cat << 'INNER_EOF' > .github/workflows/deploy-uat.yml
name: Deploy to UAT

on:
  push:
    branches:
      - 'release/**'

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      # 1. Inject Secrets
      - name: Create .env and Key Files
        run: |
          echo "${{ secrets.ENV_FILE_UAT }}" > .env
          echo '${{ secrets.FIREBASE_SERVICE_ACCOUNT_UAT }}' > service-account.json

      # 2. Build App
      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'uat'

      # 3. Full Deployment (Hosting + Firestore)
      - name: Deploy to Firebase
        run: npx firebase deploy --project fresh-nest-uat --non-interactive
        env:
          GOOGLE_APPLICATION_CREDENTIALS: 'service-account.json'
INNER_EOF

# 3. Update PROD Pipeline
cat << 'INNER_EOF' > .github/workflows/deploy-prod.yml
name: Deploy to PROD

on:
  push:
    branches:
      - main

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      # 1. Inject Secrets
      - name: Create .env and Key Files
        run: |
          echo "${{ secrets.ENV_FILE_PROD }}" > .env
          echo '${{ secrets.FIREBASE_SERVICE_ACCOUNT_PROD }}' > service-account.json

      # 2. Build App
      - name: Build
        run: npm run build
        env:
          VITE_APP_ENV: 'production'

      # 3. Full Deployment (Hosting + Firestore)
      - name: Deploy to Firebase
        run: npx firebase deploy --project fresh-nest-prod --non-interactive
        env:
          GOOGLE_APPLICATION_CREDENTIALS: 'service-account.json'
INNER_EOF

echo "✅ Pipelines Upgraded to Full-Stack Deployment."
