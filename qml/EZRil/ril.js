// ril.js

function rilPopulateListModel(url, params, listmodel) {
        //listmodel.clear()
        var xhr = new XMLHttpRequest;
        xhr.open("POST", url);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Content-length", params.length);
        xhr.setRequestHeader("Connection", "close");
        //xhr.send(params);
        //console.log(url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                console.log(xhr.responseText)
                var a = JSON.parse(xhr.responseText)["list"];
                //console.log(a)
                for (var b in a) {
                    var o = a[b];
                    listmodel.append({id: o.item_id, title: o.title, url: o.url, read: o.state});
                    //console.log(o.title);
                }
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
    var username = "";
    var password = "";
    var apikey = "dhvT2n8fg17e5N08fudKMY5Wl0p7q3cF";
    return "username=" + username + "&password=" + password + "&apikey=" + apikey;
}

function rilGet() {
    var listmodel = Qt.createQmlObject('import Qt 4.7; ListModel {}', articleListing);
    var params = rilGetParams();

    var url="https://readitlaterlist.com/v2/get";
    rilPopulateListModel(url, params, listmodel);
    return listmodel;
}

function rilMarkAsRead(item) {
    var params = rilGetParams();
    var url = "https://readitlaterlist.com/v2/send";
    item = "http:\/\/feedingit.marcoz.org\/news";
    
    var req = {"0" : { "url" : item } };
    console.log(req);
    var jreq = JSON.stringify(req);
    console.log(jreq);

    params = params + "&read=" + jreq;
    console.log(params);
    sendReq(url, params);
}
