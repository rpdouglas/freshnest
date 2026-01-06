/**
 * scripts/init-org.js
 * USAGE: 
 * 1. Ensure service-account.json is in this folder (scripts/).
 * 2. Run: node scripts/init-org.cjs
 */

const admin = require('firebase-admin');
// Ensure this file exists! You downloaded it from Firebase Console -> Project Settings -> Service Accounts
const serviceAccount = require('./service-account.json'); 

// --- CONFIGURATION ---
const TARGET_EMAIL = "FN_TEST_CLEANER@gmail.com"; // <--- The account you want to give a "Home" to
const ORG_NAME = "Cleaner Test Org";              // <--- The name of their new Organization
// ---------------------

// Initialize the Admin SDK
// Check if already initialized to avoid hot-reload errors (though rare in scripts)
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

    // 1. Find the user
    let user;
    try {
      user = await auth.getUserByEmail(TARGET_EMAIL);
      console.log(`✅ Found User: ${user.uid}`);
    } catch (e) {
      console.error(`❌ User ${TARGET_EMAIL} not found in Auth. Did you sign up in the browser first?`);
      process.exit(1);
    }

    // 2. Create the Organization
    const orgRef = await db.collection('organizations').add({
      name: ORG_NAME,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      plan: 'basic', // Default plan for new orgs
      settings: {
        currency: 'USD',
        geoFenceRadius: 200
      }
    });
    console.log(`✅ Created Organization: ${orgRef.id} (${ORG_NAME})`);

    // 3. Update the User Profile (Firestore)
    // We create a public profile for this user so we can find them easily later
    await db.collection('users').doc(user.uid).set({
      email: user.email,
      orgId: orgRef.id,
      role: 'admin', // First user is always admin
      fullName: 'Test User',
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

    console.log("\n🎉 SUCCESS! You MUST Sign Out and Sign In again on the app to refresh your token.");

  } catch (error) {
    console.error("❌ Error during bootstrap:", error);
  }
}

bootstrap();