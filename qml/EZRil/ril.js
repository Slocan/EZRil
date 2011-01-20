// ril.js

//############ Private functions###################

function rilPopulateListModel(list, listmodel) {
    //listmodel.clear()
    var a = JSON.parse(list)["list"];
    //console.log(a)
    for (var b in a) {
        var o = a[b];
        listmodel.append({id: o.item_id, title: o.title, url: o.url, unread: o.state});
        //console.log(o.title);
    }
}

function rilDownloadList() {
    var xhr = new XMLHttpRequest;
    var params = rilGetParams();
    var url="https://readitlaterlist.com/v2/get";
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("Content-length", params.length);
    xhr.setRequestHeader("Connection", "close");
    //xhr.send(params);
    //console.log(url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            //console.log(xhr.responseText)
            Storage.setSetting("rilList",xhr.responseText)
        }
    }
    xhr.send(params);
}

function rilDownloadArticle(articleUrl) {
    var xhr = new XMLHttpRequest;

    var params = "apikey=" + Storage.getSetting("apikey")+"&images=1&url="+articleUrl;
    var url="https://text.readitlaterlist.com/v2/text";
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("Content-length", params.length);
    xhr.setRequestHeader("Connection", "close");
    //xhr.send(params);
    //console.log(url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            //console.log(xhr.responseText)
            Storage.saveArticle(articleUrl,xhr.responseText)
        }
    }
    xhr.send(params);
}

function sendReq(url, params) {
        var xhr = new XMLHttpRequest;
        xhr.open("POST", url);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Content-length", params.length);
        xhr.setRequestHeader("Connection", "close");

        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
               console.log(xhr.responseText);
            }
        }
        xhr.send(params);
}

function rilGetParams() {
    var username = Storage.getSetting("username");
    var password = Storage.getSetting("password");
    var apikey = Storage.getSetting("apikey");
    return "username=" + username + "&password=" + password + "&apikey=" + apikey;
}

//########## End Of Private Functions #######

//###### Read It Later API ###########
function rilGet() {
    //Get the list of articles in the RIL account, and add it to a ListModel object
    var listmodel = Qt.createQmlObject('import Qt 4.7; ListModel {}', articleViewer);
    //var params = rilGetParams();
    var list = Storage.getSetting("rilList");

    rilPopulateListModel(list, listmodel);
    return listmodel;
}

function rilMarkAsRead(item) {
    // Mark an item as read. Parameter should be the URL of the item
    var params = rilGetParams();
    var url = "https://readitlaterlist.com/v2/send";
    
    var req = {"0" : { "url" : item } };
    var jreq = JSON.stringify(req);

    params = params + "&read=" + jreq;
    sendReq(url, params);
}

function updateList() {
    rilDownloadList();
    var list = Storage.getSetting("rilList");
    var a = JSON.parse(list)["list"];
    for (var b in a) {
        var o = a[b];
        //listmodel.append({id: o.item_id, title: o.title, url: o.url, unread: o.state});
        rilDownloadArticle(o.url)
        //console.log(o.title);
    }
}

//######### End of API #########
