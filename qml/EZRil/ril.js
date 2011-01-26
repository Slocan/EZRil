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
    //console.log(params);
    var url="https://readitlaterlist.com/v2/get";
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("Content-length", params.length);
    xhr.setRequestHeader("Connection", "close");

    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            //console.log(xhr.responseText)
            Storage.setSetting("rilList",xhr.responseText);
            var a = JSON.parse(xhr.responseText)["list"];
            for (var b in a) {
                var o = a[b];
                //listmodel.append({id: o.item_id, title: o.title, url: o.url, unread: o.state});
                console.log(o.title);
                var currentArticle = Storage.getRilArticle(o.url)
                if ((currentArticle=="Unknown") || (currentArticle=="Not downloaded yet")) {
                    Storage.saveRilArticle(o.url, o.title, "Not downloaded yet", o.unread)
                    rilDownloadRilArticle(o.url);
                }
                //console.log(o.title);
            }
        }
    }
    xhr.send(params);
}

function rilDownloadRilArticle(articleUrl) {
    console.log("Downloading "+articleUrl)
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
            Storage.updateRilArticle(articleUrl,xhr.responseText)
            console.log("Finished downloading "+articleUrl)
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
function rilGet(listmodel) {
    //Get the list of articles in the RIL account, and add it to a ListModel object
    //var listmodel = Qt.createQmlObject('import Qt 4.7; ListModel {}', articleViewer);
    //var params = rilGetParams();
    var xml = Storage.getRilList();
    //console.log(xml);
    if (xml=="Error") {
          return ""
    }
    return xml;
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
}

function checkLogin() {
    var params = rilGetParams();
    var url = "https://readitlaterlist.com/v2/auth"
    //console.log(params)

    var status = sendReq(url,params);
    // Currently, there is no way to check it was successful or not as the call is asynchronous
}

//######### End of API #########
