class Elit extends Vendor {
    getCleanQueries() {
        return [
            'DELETE FROM Prices WHERE ID = 10',
            'DELETE FROM Prices WHERE ID = 20 AND ID = 30'
        ]
    }
}