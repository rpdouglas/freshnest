import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { execSync } from 'child_process';
import pkg from './package.json';
import buildMeta from './build-meta.json'; // Import the counter

// Get Git Hash
let commitHash = 'dev';
try {
  commitHash = execSync('git rev-parse --short HEAD').toString().trim();
} catch (e) {}

export default defineConfig({
  plugins: [react()],
  define: {
    __APP_VERSION__: JSON.stringify(pkg.version),
    __COMMIT_HASH__: JSON.stringify(commitHash),
    __BUILD_DATE__: JSON.stringify(new Date().toISOString().split('T')[0]),
    __BUILD_NUMBER__: JSON.stringify(buildMeta.buildNumber), // Inject the number
  }
})
