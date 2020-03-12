import firebase from 'firebase/app';
import 'firebase/firestore';
import 'firebase/auth';
import 'firebase/functions';

const config = {
    apiKey: "XXXXXXX",
    authDomain: "app.firebaseapp.com",
    databaseURL: "https://app.firebaseio.com/",
    projectId: "apple-c8f4f"
};

if (!firebase.apps.length) {
    firebase.initializeApp(config);
}

export const database = firebase.firestore().settings;
export const auth = firebase.auth();
export const functions = firebase.functions();