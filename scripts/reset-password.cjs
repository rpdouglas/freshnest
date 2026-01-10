const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json');

// --- CONFIGURATION ---
const TARGET_EMAIL = "rpdouglas@gmail.com";
const NEW_PASSWORD = "password123"; 
// ---------------------

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const auth = admin.auth();

async function resetPassword() {
  try {
    console.log(`🔍 Looking for user: ${TARGET_EMAIL}...`);
    const user = await auth.getUserByEmail(TARGET_EMAIL);
    
    console.log(`👤 Found UID: ${user.uid}`);
    console.log(`🔐 Setting new password...`);

    await auth.updateUser(user.uid, {
      password: NEW_PASSWORD
    });

    console.log(`✅ SUCCESS! Password updated to: ${NEW_PASSWORD}`);
    console.log(`👉 You can now log in immediately.`);

  } catch (error) {
    console.error("❌ Error resetting password:", error.message);
  }
}

resetPassword();
