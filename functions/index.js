const functions = require('firebase-functions');
const admin = require('firebase-admin');
const processSignUp = require('functions/processSignUp');

admin.initializeApp();

exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
    return processSignUp(user);
});
