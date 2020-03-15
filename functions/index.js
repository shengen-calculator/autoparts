const functions = require('firebase-functions');
const admin = require('firebase-admin');
const processSignUp = require('./processSignUp');

admin.initializeApp();

exports.processSignUp = functions.auth.user().onCreate((user) => {
    return processSignUp(user);
});
