import firebase from 'firebase/app';
import 'firebase';
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

export const database = firebase.database();
export const auth = firebase.auth();
export const functions = firebase.functions();