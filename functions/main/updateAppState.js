const firebase = require("firebase/app");
const util = require('../util');

const updateAppState = async (data, context) => {

    util.checkForManagerRole(context);

    firebase.initializeApp(config);

    if (!firebase.apps.length) {
        firebase.initializeApp(config);
    }
    const database = firebase.database();

    return await database.ref('app-settings').update(data.state);

};

module.exports = updateAppState;

