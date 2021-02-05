class Elit extends Vendor {
    get id() {
        return 49;
    }
    getCleanQueries() {
        return [
            'DELETE FROM Prices WHERE ID = 10',
            'DELETE FROM Prices WHERE ID = 20 AND ID = 30'
        ]
    }
}