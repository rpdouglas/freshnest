import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { execSync } from 'child_process';
import pkg from './package.json';

// 1. Get Git Hash
let commitHash = 'unknown';
try {
  commitHash = execSync('git rev-parse --short HEAD').toString().trim();
} catch (e) {
  console.warn('Git hash not found (not a git repo?)');
}

// 2. Get Environment (from CI/CD or .env)
// Note: VITE_APP_ENV is injected by our GitHub Actions
const appEnv = process.env.VITE_APP_ENV || 'local';

// 3. Format Version String
// e.g. "v1.2.0 (dev)" or "v1.2.0" for prod
const displayVersion = appEnv === 'production' 
  ? pkg.version 
  : `${pkg.version}-${appEnv}`;

export default defineConfig({
  plugins: [react()],
  define: {
    // Inject these global constants
    __APP_VERSION__: JSON.stringify(displayVersion),
    __COMMIT_HASH__: JSON.stringify(commitHash),
    __BUILD_DATE__: JSON.stringify(new Date().toISOString().split('T')[0]),
    __ENV_NAME__: JSON.stringify(appEnv),
  }
})
