const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.profileCreate = functions.auth.user().onCreate(async (user) => {
  try {
    await admin.auth().setCustomUserClaims(user.uid, { role: 'member' });

    await admin.firestore().collection('profiles').doc(user.uid).set({
      email: user.email,
      roleView: 'member',
    }, { merge: true });
  } catch (error) {
    console.error('Error creating profile or setting custom claims:', error);
  }
});

exports.profileDelete = functions.auth.user().onDelete(async (user) => {
  try {
    const doc = admin.firestore().collection('profiles').doc(user.uid);
    await doc.delete();
  } catch (error) {
    console.error('Error deleting profile:', error);
  }
});
