import Qt 4.7
import "storage.js" as Storage

Item {
    id: articleViewer
    //width: 480; height: 360;
    width: parent.width; height: parent.height;
    //property string feedid: "61ac1458d761423344998dc76770e36e" //articlesItem.feedid;
    //property string hideReadArticles: "";
    property alias articleShown: articleView.visible;
    property bool zoomEnabled: false;
    property bool vertPanningEnabled: true
    property alias xml: articles.xml;

    function modulo(x,y) {
        // Fixes modulo for negative numbers
        return ((x%y)+y)%y;
    }

    function reload() {
        articles.reload()
    }

    function next() {
        if (articleView.visible) {
            //articleView.positionViewAtIndex(modulo(articleView.currentIndex+1, articleView.count), ListView.Contain);
            articleView.incrementCurrentIndex();
        }
    }

    function prev() {
        if (articleView.visible) {
            //articleView.positionViewAtIndex(modulo(articleView.currentIndex-1, articleView.count), ListView.Contain);
            articleView.decrementCurrentIndex();
        }
    }

    function markAllAsRead() {
//        if (feedid!="") {
//            var doc = new XMLHttpRequest();
//            //console.log(articlesItem.url+"&markAllAsRead=True")
//            var url = "http://localhost:8000/articles/" + feedid + "?markAllAsRead=True"
//            console.log(url)
//            doc.open("GET", url);
//            doc.send();
//            articles.reload();
//        }
    }

    function viewArticle(articleid) {
        var index = 0;
        for (var i=0; i<articleList.count; ++i) {
            if (articles.get(0).articleid==articleid) {
                index = i;
            }
        }
        articleView.positionViewAtIndex(index, ListView.Contain); articleView.visible = true;
    }

    function back() {
        if (articleView.visible) {
            articleView.visible = false;
        } else {
            articleViewer.visible = false;
        }
    }

    ListView {
        id: articleList; model: visualModel.parts.list; z: 6
        width: parent.width; height: parent.height; /*x: 0;*/
        cacheBuffer: 100;
        flickDeceleration: 1500
    }

    ListView {
        id: articleView; model: visualModel.parts.flip; orientation: ListView.Horizontal
        width: parent.width; height: parent.height; visible: false; z:8
        //onCurrentIndexChanged: photosGridView.positionViewAtIndex(currentIndex, GridView.Contain)
        highlightRangeMode: ListView.StrictlyEnforceRange; snapMode: ListView.SnapOneItem
        //cacheBuffer: 5;
        onMovementStarted: articleViewer.vertPanningEnabled=false;
        onMovementEnded: articleViewer.vertPanningEnabled=true;
        highlightMoveDuration: 300;
    }

    Rectangle {
        id: noArticle
        //width: parent.width; height: parent.height;
        //color: "#000000"
        anchors.centerIn: parent;
        visible: false;
        z:8;
        Text { id: noText; color: "#ffffff"; anchors.centerIn: parent; text: qsTr("No articles available"); }
        Image { id: loadingImage; anchors.centerIn: parent; source: "toolbar/images/loading.png";
            height: 96; width: 96;
            NumberAnimation on rotation {
                from: 0; to: 360; running: (loadingImage.visible == true); loops: Animation.Infinite; duration: 900
            }
        }

        states: [ State {
            name: "noArticle"; when: articles.count==0 && articles.status==XmlListModel.Ready
            PropertyChanges { target: noArticle; visible: true; }
            PropertyChanges { target: loadingImage; visible: false; }
            PropertyChanges { target: noText; visible: true; }
            }, State {
            name: "loading"; when: articles.count==0 && articles.status != XmlListModel.Ready
            PropertyChanges { target: noArticle; visible: true; }
            PropertyChanges { target: noText; visible: false; }
            PropertyChanges { target: loadingImage; visible: true; }
            }
        ]
    }

    VisualDataModel {
        id: visualModel;
        delegate: Package {
                        id: packageItem
                        Item { id: flipItem; Package.name: 'flip';  width: articleViewer.width; height: articleViewer.height;

                            //property string articleUrl: (articleView.visible && Math.abs(articleView.currentIndex-index)<2) ? "https://text.readitlaterlist.com/v2/text?apikey=yourapikey&mode=more&images=1&url="+url : ""; //http://localhost:8000/html/" + articleViewer.feedid + "/" + articleid : "";
                            property string html: (articleView.visible && Math.abs(articleView.currentIndex-index)<2) ? Storage.getRilArticle(articleid) : ""
                            ArticleDisplay {
                                //zoomEnabled: articleViewer.zoomEnabled;
                                property bool vertPanningEnabled: articleViewer.vertPanningEnabled;

                                states: [ State {
                                        name: 'articleIsRead';
                                    when: articleView.visible && articleView.currentIndex == index;
                                    StateChangeScript {
                                        name: "myScript"
                                        script: {
                                            //flipItem.url=path; //"http://localhost:8000/html/" + articleViewer.feedid + "/" + articleid;
                                            //var doc = new XMLHttpRequest();
                                            //var url = "http://localhost:8000/read/" + articleViewer.feedid + "/" + articleid;
                                            //console.log(url)
                                            //doc.open("GET", url);
                                            //doc.send();
                                            //var xmlDoc=doc.responseXML;
                                        }
                                    }
                                    }, State {
                                        name: 'articleIsClose'; when: articleView.visible && Math.abs(articleView.currentIndex-index)<2;
                                        StateChangeScript {
                                            //script: { flipItem.url=path; } //"http://localhost:8000/html/" + articleViewer.feedid + "/" + articleid;}
                                        }
                                    }
                                ]
                            }
                        }

                        Item { Package.name: 'list';
                                id: wrapper; width: articleViewer.width; height: 86
                                Item {
                                    id: moveMe
                                    Rectangle { id: backRect; color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: 84; width: wrapper.width; y: 1 }
                                    Text {
                                        anchors.fill: backRect
                                        anchors.margins: 5
                                        verticalAlignment: Text.AlignVCenter; text: title; color: (unread==1) ? "white" : "#7b97fd";
                                        width: wrapper.width; wrapMode: Text.WordWrap; font.bold: false;
                                    }
                                }
                                MouseArea { anchors.fill: wrapper;
                                    onClicked: { articleView.positionViewAtIndex(index, ListView.Contain); articleView.visible = true; }
                                }
                        }
                    }
        //model: articleViewer.model
        model: articles
    }

    XmlListModel {
        id: articles

        //source: articleViewer.feedid == "" ? "" : "http://localhost:8000/articles/" + feedid + "?onlyUnread=" + hideReadArticles
        //xml: parent.xml
        query: "/xml/article"

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "articleid"; query: "articleid/string()"; isKey: true }
        //XmlRole { name: "path"; query: "path/string()" }
        XmlRole { name: "unread"; query: "unread/string()"; isKey: true}
    }


//Item {
//     anchors.fill: parent;
//     Text {
//	text: visualModel.parts.list.count;
//     }
//}

}
