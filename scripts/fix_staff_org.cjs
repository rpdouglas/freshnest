const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json'); // Uses DEV key

const ADMIN_EMAIL = "rpdouglas@gmail.com";
const STAFF_EMAIL = "staff@freshnest.com";

if (!admin.apps.length) {
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}
const db = admin.firestore();
const auth = admin.auth();

async function fixOrg() {
  try {
    console.log(`🔧 Fixing Org Mismatch...`);

    // 1. Get Admin's Org ID (The Source of Truth)
    const adminAuth = await auth.getUserByEmail(ADMIN_EMAIL);
    const adminDoc = await db.collection('users').doc(adminAuth.uid).get();
    
    if (!adminDoc.exists) {
      console.error("❌ Admin profile not found. Cannot proceed.");
      return;
    }

    const correctOrgId = adminDoc.data().orgId;
    console.log(`✅ Admin Org ID: ${correctOrgId}`);

    // 2. Get Staff User
    const staffAuth = await auth.getUserByEmail(STAFF_EMAIL);
    const staffRef = db.collection('users').doc(staffAuth.uid);

    // 3. Force Update Staff
    await staffRef.set({
      orgId: correctOrgId
    }, { merge: true }); // 'merge: true' keeps other fields like email/role intact

    console.log(`✅ SUCCESS! Moved ${STAFF_EMAIL} into Org: ${correctOrgId}`);
    console.log("👉 Refresh your browser. You should see them in Settings now.");

  } catch (error) {
    console.error("❌ Error:", error.message);
  }
}

fixOrg();
