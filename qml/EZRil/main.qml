import Qt 4.7
import "ril.js" as RIL
import "storage.js" as Settings


Rectangle {
    width: 360
    height: 360
    id: screen

    Component.onCompleted: { Settings.initialize();  
      //console.log(Settings.getSetting("username") + Settings.getSetting("password") + Settings.getSetting("apikey"));
      //Settings.dump();
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }

    ArticleViewer {

        id: articleViewer;
        //property string hideReadFeeds: config.hideReadFeeds

        visible: true;
        property variant model

        Component.onCompleted: {
            //model = RIL.rilMarkAsRead();
            model = RIL.rilGet();
        }

//        states: [
//            State { name: "articlesShown"; when: flipper.visible; PropertyChanges { target: feedsItem; x: -parent.width } },
//            State { name: "shown"; when: feedsItem.visible; PropertyChanges { target: feedsItem; x: 0 } }
//        ]

//        transitions: Transition {
//            NumberAnimation { properties: "x"; duration: 300; easing.type: "InOutQuad" }
//        }

    }
}
