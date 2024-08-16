const admin = require("firebase-admin");

let serAccount = require("../config/push-notification-key.json");

admin.initializeApp({
  credential: admin.credential.cert(serAccount),
});

module.exports = admin;