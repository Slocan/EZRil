// ril.js

function populateListModel(url, listmodel) {
        //listmodel.clear()
        var xhr = new XMLHttpRequest;
        xhr.open("GET", url);
        console.log(url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                console.log(xhr.responseText)
                var a = JSON.parse(xhr.responseText)["list"];
                //console.log(a)
                for (var b in a) {
                    var o = a[b];
                    listmodel.append({id: o.item_id, title: o.title, url: o.url});
                    //console.log(o.title);
                }
            }
        }
        xhr.send();
    }

function rilGet(username,password,apikey) {
    var listmodel = Qt.createQmlObject('import Qt 4.7; ListModel {}', articleListing);
    var url="https://readitlaterlist.com/v2/get?username=slocan&password=craffe&apikey=dhvT2n8fg17e5N08fudKMY5Wl0p7q3cF";
    populateListModel(url, listmodel);
    return listmodel;
}
