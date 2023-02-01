////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////
const admin = require("firebase-admin");
const serviceAccount = require("./firebase-service-account.json");
// add your firebase db url here
//// const FIREBASE_DATABASE_URL = `https://${process.env.FIREBASE_PROJECT_ID}.firebaseio.com`;

////////////////////////////////////////////// FIREBASE ADMIN //////////////////////////////////////////////
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    // databaseURL: FIREBASE_DATABASE_URL
});


const firebaseAdmin = {};
firebaseAdmin.sendMulticastNotification = function (payload) {
    const message = {
        notification: {
            title: payload.title,
            body: payload.body
        },
        tokens: payload.tokens,
        data: payload.data || {}
    };
    return admin.messaging().sendMulticast(message); //notification to multiple users upto 500 at a time
};

module.exports = firebaseAdmin;