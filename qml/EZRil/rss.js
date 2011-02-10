//rss.js

//## API
//
// function addFeed(url)
// function updateFeed(feedid)
// function generateId(string)
//

function generateId(string) {
    // Returns a unique Id
    return Qt.md5(string);
}

function addFeed(url) {
    var feedid = generateId(url);
    Storage.createFeedDatabase(feedid,"Untitled",url);
}
