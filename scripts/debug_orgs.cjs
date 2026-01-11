const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json'); // Uses DEV key

const ADMIN_EMAIL = "rpdouglas@gmail.com";
const STAFF_EMAIL = "staff@freshnest.com";

if (!admin.apps.length) {
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}
const db = admin.firestore();
const auth = admin.auth();

async function debug() {
  console.log("🔍 Comparing Org IDs...");

  // 1. Check Admin
  try {
    const adminAuth = await auth.getUserByEmail(ADMIN_EMAIL);
    const adminDoc = await db.collection('users').doc(adminAuth.uid).get();
    
    if (!adminDoc.exists) {
      console.log(`❌ Admin Profile MISSING in Firestore!`);
    } else {
      console.log(`✅ Admin (${ADMIN_EMAIL}):`);
      console.log(`   - UID: ${adminAuth.uid}`);
      console.log(`   - OrgID: ${adminDoc.data().orgId}`);
      console.log(`   - Role:  ${adminDoc.data().role}`);
    }
  } catch (e) { console.error("Error fetching Admin:", e.message); }

  console.log("------------------------------------------------");

  // 2. Check Staff
  try {
    const staffAuth = await auth.getUserByEmail(STAFF_EMAIL);
    const staffDoc = await db.collection('users').doc(staffAuth.uid).get();

    if (!staffDoc.exists) {
      console.log(`❌ Staff Profile MISSING in Firestore!`);
    } else {
      console.log(`✅ Staff (${STAFF_EMAIL}):`);
      console.log(`   - UID: ${staffAuth.uid}`);
      console.log(`   - OrgID: ${staffDoc.data().orgId}`);
      console.log(`   - Role:  ${staffDoc.data().role}`);
    }
  } catch (e) { console.error("Error fetching Staff:", e.message); }
}

debug();
