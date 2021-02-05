const {Datastore} = require('@google-cloud/datastore');

class Log {
    constructor(){
        this.datastore = new Datastore();
        this.vendor_ = '';
    }
    set vendor(value) {
        if(value) {
            this.vendor_ = value;
        }
    }
    async info(message) {
        await this.datastore.insert({
            data: {
                Company: this.vendor_,
                Date: new Date(),
                Level: 'INFO',
                Description: message
            },
            key: this.getKey()
        });
    }
    async warning(message) {
        await this.datastore.insert({
            data: {
                Company: this.vendor_,
                Date: new Date(),
                Level: 'WARNING',
                Description: message
            },
            key: this.getKey()
        });
    }
    async error(message) {
        await this.datastore.insert({
            data: {
                Company: this.vendor_,
                Date: new Date(),
                Level: 'ERROR',
                Description: message
            },
            key: this.getKey()
        });
    }

    getKey() {
        return this.datastore.key('import-log');
    }
}

module.exports = Log;