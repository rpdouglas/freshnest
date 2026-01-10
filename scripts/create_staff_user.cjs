const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json');

// --- CONFIGURATION ---
const ADMIN_EMAIL = "rpdouglas@gmail.com"; // Your main account
const STAFF_EMAIL = "staff@freshnest.com"; // The test account
const STAFF_PASSWORD = "password123";
// ---------------------

if (!admin.apps.length) {
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}
const db = admin.firestore();
const auth = admin.auth();

async function createStaff() {
  try {
    console.log(`🔍 Finding Admin Org...`);
    const adminUser = await auth.getUserByEmail(ADMIN_EMAIL);
    const adminProfile = await db.collection('users').doc(adminUser.uid).get();
    const orgId = adminProfile.data().orgId;
    console.log(`✅ Found Org ID: ${orgId}`);

    console.log(`👤 Creating Staff User: ${STAFF_EMAIL}...`);
    let staffUser;
    try {
      staffUser = await auth.getUserByEmail(STAFF_EMAIL);
      console.log(`   User already exists (UID: ${staffUser.uid})`);
    } catch {
      staffUser = await auth.createUser({ email: STAFF_EMAIL, password: STAFF_PASSWORD });
      console.log(`   Created new Auth User (UID: ${staffUser.uid})`);
    }

    console.log(`📝 Writing Staff Profile to Firestore...`);
    await db.collection('users').doc(staffUser.uid).set({
      email: STAFF_EMAIL,
      fullName: "Test Staffer",
      role: "staff", // <--- THE KEY PART
      orgId: orgId,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log(`\n🎉 SUCCESS!`);
    console.log(`Login with: ${STAFF_EMAIL} / ${STAFF_PASSWORD}`);

  } catch (error) {
    console.error("❌ Error:", error.message);
  }
}

createStaff();
