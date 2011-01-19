//storage.js

    //property string username;
    //property string password;
    //property string apikey;

    function getDatabase() {
         return openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
    }
    
    function getSetting(setting) {
       var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
       var res="";
       db.transaction(function(tx) {
         var rs = tx.executeSql('SELECT value FROM settings WHERE setting="' + setting + '";');
         if (rs.rows.length > 0) {
              res = rs.rows.item(0).value;
         } else {
             res = "Unknown";
         }
      })
      return res
    }

    function dump() {
        var db = getDatabase();
        db.transaction(function(tx) {
           var rs = tx.executeSql('SELECT * FROM settings');
           for(var i = 0; i < rs.rows.length; i++) {
                    console.log(rs.rows.item(i).setting+ ", " + rs.rows.item(i).value + "\n");
           }
        });
    }

    function setSetting(setting, value) {
       var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
       var res = "";
       db.transaction(function(tx) {
                           var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES ("'+setting+'","' + value + '");');
                           if (rs.rowsAffected > 0) {
                              res = "OK";
                           }
                           res = "Error";
                      }
      );
      return res;
    }

    function initialize() {
        var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);

        db.transaction(
            function(tx) {
                // Create the database if it doesn't already exist
                //tx.executeSql('DROP TABLE settings;');
                tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');

                // Add (another) greeting row
                //tx.executeSql('INSERT INTO Greeting VALUES(?, ?)', [ 'hello', 'world' ]);

                // Show all added greetings
                //var rs = tx.executeSql('SELECT * FROM Greeting');

                //var r = ""
                //for(var i = 0; i < rs.rows.length; i++) {
                //    r += rs.rows.item(i).salutation + ", " + rs.rows.item(i).salutee + "\n"
                //}
                //text = r
                //username = getSetting("username");
                //password = getSetting("password");
                //apikey = getSetting("apikey");
                
            }
        );
        return db;
    }
