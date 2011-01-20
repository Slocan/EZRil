import Qt 4.7
import "ril.js" as RIL
import "storage.js" as Storage


Rectangle {
    width: 360
    height: 360
    id: screen
    color: "#343434";

    Component.onCompleted: { Storage.initialize();
        //RIL.updateList();

      //console.log(Settings.getSetting("username") + Settings.getSetting("password") + Settings.getSetting("apikey"));
      //Storage.dump();
    }

    ArticleViewer {

        id: articleViewer;
        //property string hideReadFeeds: config.hideReadFeeds

        visible: true;
        property variant model

        Component.onCompleted: {
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
