//storage.js

function getDatabase() {
     return openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
}

function getSetting(setting) {
   var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
   var res="";
   db.transaction(function(tx) {
     var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
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
       var rs = tx.executeSql('SELECT * FROM rilArticles');
       for(var i = 0; i < rs.rows.length; i++) {
                console.log(rs.rows.item(i).url+ ", " + rs.rows.item(i).title + "\n");
       }
    });
}

function setSetting(setting, value) {
   var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
   var res = "";
   db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
              //console.log(rs.rowsAffected)
              if (rs.rowsAffected > 0) {
                res = "OK";
              } else {
                res = "Error";
              }
        }
  );
  //console.log(setting+" "+res)
  return res;
}

function getRilArticle(url) {
   var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
   var res="";
   db.transaction(function(tx) {
     var rs = tx.executeSql('SELECT article FROM rilArticles WHERE url=?;', [url,]);
     if (rs.rows.length > 0) {
          res = rs.rows.item(0).article;
     } else {
         res = "Unknown";
     }
  })
  return res
}

function saveRilArticle(url, title, article, unread) {
   var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
   var res = "";
   db.transaction(function(tx) {
                      var rs = tx.executeSql('INSERT OR REPLACE INTO rilArticles VALUES (?,?,?,?,date(\'now\'));', [url,title,article,unread]);
                       if (rs.rowsAffected > 0) {
                          res = "OK";
                       } else {
                        res = "Error";
                       }
                  }
  );
  return res;
}

function updateRilArticle(url, article) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
                       var rs = tx.executeSql('UPDATE rilArticles SET article=? WHERE url=?;', [article,url]);
                        if (rs.rowsAffected > 0) {
                           res = "OK";
                        }
                        res = "Error";
                   }
   );
   return res;
}

function getRilList() {
    var db = getDatabase();
    var xml;
    db.transaction(function(tx) {
                        var rs = tx.executeSql('SELECT url,title,unread FROM rilArticles');
                        //console.log(rs.rowsAffected);
                        if (rs.rows.length > 0) {
                            xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><xml>"
                            for(var i = 0; i < rs.rows.length; i++) {
                                xml += "<article>";
                                xml += "<title>"+rs.rows.item(i).title+"</title>";
                                xml += "<articleid>"+rs.rows.item(i).url+"</articleid>";
                                xml += "<unread>"+rs.rows.item(i).unread+"</unread>";
                                xml += "</article>";
                            }
                            xml += "</xml>";
                        } else {
                            xml = "Error";
                        }
                   }
   );
   return xml;
}

function initialize() {
    var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);

    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            //tx.executeSql('DROP TABLE settings;');
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS rilArticles(url TEXT UNIQUE, title TEXT, article TEXT, unread INTEGER, updateTime TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS feeds(feeid TEXT UNIQUE,title TEXT, url TEXT)')

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
    //return db;
}
