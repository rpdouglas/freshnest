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