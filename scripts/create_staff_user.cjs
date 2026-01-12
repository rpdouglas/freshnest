const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

// --- ARGS HANDLING ---
// Usage: node scripts/create_staff_user.cjs [env]
const env = process.argv[2] || 'dev';
const keyFilename = env === 'dev' ? 'service-account.json' : `service-account-${env}.json`;
const keyPath = path.join(__dirname, keyFilename);

// --- CONFIGURATION ---
const ADMIN_EMAIL = "rpdouglas@gmail.com"; 
const STAFF_EMAIL = "staff@freshnest.com"; 
const STAFF_PASSWORD = "password123";
// ---------------------

if (!fs.existsSync(keyPath)) {
  console.error(`❌ ERROR: Could not find key file: ${keyFilename}`);
  process.exit(1);
}

const serviceAccount = require(keyPath);
console.log(`🌍 Environment: ${env.toUpperCase()}`);

if (!admin.apps.length) {
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}
const db = admin.firestore();
const auth = admin.auth();

async function createStaff() {
  try {
    console.log(`🔍 Finding Admin Org for: ${ADMIN_EMAIL}...`);
    
    // 1. Find Admin to get the correct Org ID
    let adminUser;
    try {
      adminUser = await auth.getUserByEmail(ADMIN_EMAIL);
    } catch (e) {
      console.error(`❌ Admin user ${ADMIN_EMAIL} not found in Auth! Run init-org.cjs first.`);
      return;
    }

    const adminProfile = await db.collection('users').doc(adminUser.uid).get();
    if (!adminProfile.exists) {
      console.error(`❌ Admin profile not found in Firestore.`);
      return;
    }

    const orgId = adminProfile.data().orgId;
    console.log(`✅ Found Org ID: ${orgId}`);

    // 2. Create/Get Staff User
    console.log(`👤 Creating/Updating Staff User: ${STAFF_EMAIL}...`);
    let staffUser;
    try {
      staffUser = await auth.getUserByEmail(STAFF_EMAIL);
      console.log(`   User already exists (UID: ${staffUser.uid})`);
    } catch {
      staffUser = await auth.createUser({ 
        email: STAFF_EMAIL, 
        password: STAFF_PASSWORD,
        emailVerified: true
      });
      console.log(`   Created new Auth User (UID: ${staffUser.uid})`);
    }

    // 3. Write Profile linked to Admin's Org
    await db.collection('users').doc(staffUser.uid).set({
      email: STAFF_EMAIL,
      fullName: "UAT Staffer",
      role: "staff", 
      orgId: orgId,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log(`\n🎉 SUCCESS! Staff created in ${env.toUpperCase()}`);
    console.log(`👉 Login: ${STAFF_EMAIL} / ${STAFF_PASSWORD}`);

  } catch (error) {
    console.error("❌ Error:", error.message);
  }
}

createStaff();
