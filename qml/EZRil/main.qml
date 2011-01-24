import Qt 4.7
import "ril.js" as RIL
import "storage.js" as Storage
import "toolbar" as ToolBar

Rectangle {
    width: 360
    height: 360
    id: screen
    color: "#343434";

    Component.onCompleted: {
        Storage.initialize();
        //loginPage.makeVisible();


        //RIL.updateList();

      //console.log(Settings.getSetting("username") + Settings.getSetting("password") + Settings.getSetting("apikey"));
      //Storage.dump();
        //utility.taskSwitcher();
    }

    Item {
        width: parent.width;
        height: parent.height-toolBar.height;
        anchors.top: toolBar.bottom; anchors.bottom: parent.bottom

        ArticleViewer {

            function refreshList() {
                model = RIL.rilGet();
            }

            id: articleViewer;
            //property string hideReadFeeds: config.hideReadFeeds

            visible: true;
            property variant model

            Component.onCompleted: {
                refreshList();
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

    ToolBar.ToolBar {
        id: toolBar; z: 7
        height: 66; anchors.top: parent.top; width: parent.width; opacity: 0.9

        onTaskSwitcherClicked: {
            utility.taskSwitcher();
        }
        onBackClicked: {
            if (articleViewer.visible == true) {
                articleViewer.back();
            } else {
                Qt.quit();
            }
        }
        onMenuClicked: loginPage.makeVisible();
        onPrevClicked: articleViewer.prev();
        onNextClicked: articleViewer.next();
        onUpdateClicked: {
                toolBar.feedUpdating = true;
                RIL.updateList();
                articleViewer.refreshList();
                toolBar.feedUpdating = false;
        }

        states: [ State {
            name: "navButtons"; when: articleViewer.articleShown
            //PropertyChanges { target: toolBar; nextVisible: !container.inPortrait; }
            //PropertyChanges { target: toolBar; prevVisible: !container.inPortrait; }
            //PropertyChanges { target: toolBar; zoomVisible: true; }
            //PropertyChanges { target: toolBar; addVisible: false; }
        },
            State {
                name: "feedButtons"; when: (articleViewer.visible)&&(!articleViewer.articleShown)
                //PropertyChanges { target: toolBar; markAllVisible: true; }
                //PropertyChanges { target: toolBar; addVisible: false; }
                PropertyChanges { target: toolBar; updateVisible: true; }
            },
            State {
                name: "quitButton"; when: (!articleViewer.articleShown)
                PropertyChanges { target: toolBar; quitVisible: true;}
                PropertyChanges { target: toolBar; backVisible: false; }
                PropertyChanges { target: toolBar; updateVisible: true; }
                //PropertyChanges { target: toolBar; addVisible: true; }
            }
        ]

    }
    Login {
        id: loginPage;
    }
}
