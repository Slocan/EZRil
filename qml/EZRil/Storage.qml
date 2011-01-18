import Qt 4.7
import "ril.js" as RIL


Storage {
    property string username;
    property string password;
    property string apikey;

    function initialize() {
        var db = openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);

        db.transaction(
            function(tx) {
                // Create the database if it doesn't already exist
                tx.executeSql('CREATE TABLE IF NOT EXISTS Greeting(salutation TEXT, salutee TEXT)');

                // Add (another) greeting row
                tx.executeSql('INSERT INTO Greeting VALUES(?, ?)', [ 'hello', 'world' ]);

                // Show all added greetings
                var rs = tx.executeSql('SELECT * FROM Greeting');

                var r = ""
                for(var i = 0; i < rs.rows.length; i++) {
                    r += rs.rows.item(i).salutation + ", " + rs.rows.item(i).salutee + "\n"
                }
                text = r
            }
        )
    }

    Component.onCompleted: initialize()

}
