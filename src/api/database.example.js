import firebase from 'firebase/comapt/app';
import 'firebase/compat/database';
import 'firebase/compat/auth';
import 'firebase/compat/functions';

const config = {
    apiKey: "XXXXXXX",
    authDomain: "app.firebaseapp.com",
    databaseURL: "https://app.firebaseio.com/",
    projectId: "apple-c8f4f"
};

if (!firebase.apps.length) {
    firebase.initializeApp(config);
}

export const database = firebase.database();
export const auth = firebase.auth();
export const functions = firebase.functions();
