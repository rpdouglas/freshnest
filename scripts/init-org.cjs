const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// --- ARGS HANDLING ---
// Usage: node scripts/init-org.cjs [env]
// Example: node scripts/init-org.cjs uat
const env = process.argv[2] || 'dev';
const keyFilename = env === 'dev' ? 'service-account.json' : `service-account-${env}.json`;
const keyPath = path.join(__dirname, keyFilename);

// --- CONFIGURATION ---
const TARGET_EMAIL = "rpdouglas@gmail.com"; 
const ORG_NAME = "Fresh Nest (HQ)";
// ---------------------

if (!fs.existsSync(keyPath)) {
  console.error(`❌ ERROR: Could not find key file: ${keyFilename}`);
  console.error(`   Please download it from Firebase Console -> Project Settings -> Service Accounts`);
  console.error(`   and save it to the 'scripts/' folder.`);
  process.exit(1);
}

const serviceAccount = require(keyPath);

console.log(`🌍 Environment: ${env.toUpperCase()}`);
console.log(`🔑 Using Key: ${keyFilename}`);

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const db = admin.firestore();
const auth = admin.auth();

async function bootstrap() {
  try {
    console.log(`🚀 Starting bootstrap for: ${TARGET_EMAIL}`);

    // 1. Ensure Auth User Exists
    let user;
    try {
      user = await auth.getUserByEmail(TARGET_EMAIL);
      console.log(`✅ Found Existing Auth User: ${user.uid}`);
    } catch (e) {
      console.log(`👤 User not found in Auth. Creating new user...`);
      user = await auth.createUser({
        email: TARGET_EMAIL,
        password: 'password123', // Default password for new envs
        emailVerified: true
      });
      console.log(`✅ Created New Auth User: ${user.uid}`);
    }

    // 2. Create the Organization
    const orgRef = await db.collection('organizations').add({
      name: ORG_NAME,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      plan: 'enterprise',
      settings: {
        currency: 'USD',
        geoFenceRadius: 500
      }
    });
    console.log(`✅ Created Organization: ${orgRef.id} (${ORG_NAME})`);

    // 3. Create/Update User Profile
    await db.collection('users').doc(user.uid).set({
      email: user.email,
      orgId: orgRef.id,
      role: 'admin',
      fullName: 'Rob Douglas',
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
    console.log(`✅ Created/Updated Firestore Profile`);

    // 4. Set Custom Claims (Legacy support, though we use Profile now)
    await auth.setCustomUserClaims(user.uid, {
      orgId: orgRef.id,
      role: 'admin'
    });
    console.log(`✅ Claims set!`);

    console.log("\n🎉 SUCCESS! You can now log in to " + env.toUpperCase());
    console.log("👉 Login: " + TARGET_EMAIL);
    console.log("👉 Pass:  password123 (if newly created) or your existing pass");

  } catch (error) {
    console.error("❌ Error during bootstrap:", error);
  }
}

bootstrap();
