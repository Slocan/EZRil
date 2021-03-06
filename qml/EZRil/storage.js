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
                console.log(rs.rows.item(i).url+ ", " + rs.rows.item(i).unread + "\n");
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
  //console.log(res)
  return res
}

function getDownloadedStatus(url) {
   var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
   var res="";
   db.transaction(function(tx) {
     var rs = tx.executeSql('SELECT downloaded FROM rilArticles WHERE url=?;', [url,]);
     if (rs.rows.length > 0) {
          res = rs.rows.item(0).downloaded;
     } else {
         res = "Unknown";
     }
  })
  //console.log(res)
  return res
}

function getListOfDownloadables() {
    var db = getDatabase();
    var res;
    db.transaction(function(tx) {
      res = tx.executeSql('SELECT url FROM rilArticles WHERE downloaded=0;');
    })
    //console.log(res)
    return res
}

function saveRilArticle(url, title, article, unread) {
   var db = getDatabase(); //openDatabaseSync("EZRil", "1.0", "StorageDatabase", 1000000);
   var res = "";
   db.transaction(function(tx) {
                      var rs = tx.executeSql('INSERT OR REPLACE INTO rilArticles VALUES (?,?,?,?,0,date(\'now\'));', [url,title,article,unread]);
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
                            tx.executeSql('UPDATE rilArticles SET downloaded=1 WHERE url=?;',[url]);
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
                        var rs = tx.executeSql('SELECT url,title,unread,downloaded FROM rilArticles');
                        //console.log(rs.rowsAffected);
                        if (rs.rows.length > 0) {
                            xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><xml>"
                            for(var i = 0; i < rs.rows.length; i++) {
                                xml += "<article>";
                                xml += "<title>"+rs.rows.item(i).title+"</title>";
                                xml += "<articleid>"+rs.rows.item(i).url+"</articleid>";
                                xml += "<unread>"+rs.rows.item(i).unread+"</unread>";
                                xml += "<downloaded>"+rs.rows.item(i).downloaded+"</downloaded>"
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

function createFeedDatabase(feedid,title,url) {
    var db = getDatabase();
    db.transaction(
        function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS ?(url TEXT UNIQUE, title TEXT, article TEXT, unread INTEGER, downloaded INTEGER, updateTime TEXT)', [feedid]);
                    tx.executeSql('INSERT OR REPLACE INTO feeds VALUES (?,?,?);',[feedid,title,url]);
                });
}

function deleteFeedDatabase(feedid) {
    var db = getDatabase();
    db.transaction(
        function(tx) {
                    tx.executeSql('DELETE FROM feeds WHERE feedid = ?;', [feedid]);
                    tx.executeSql('DROP TABLE ?;', [feedid]);
                });
}

function initialize() {
    var db = getDatabase();

    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            //tx.executeSql('DROP TABLE rilArticles;');
            //tx.executeSql('DROP TABLE settings;');
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS rilArticles(url TEXT UNIQUE, title TEXT, article TEXT, unread INTEGER, downloaded INTEGER, updateTime TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS feeds(feedid TEXT UNIQUE,title TEXT, url TEXT)');

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
