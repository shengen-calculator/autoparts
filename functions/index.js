const admin = require('firebase-admin');

admin.initializeApp();

exports.order = require('./orderFunc');
exports.search = require('./searchFunc');
exports.main = require('./mainFunc');
exports.statistic = require('./statisticFunc');
exports.history = require('./historyFunc');


