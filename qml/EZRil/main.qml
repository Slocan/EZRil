import Qt 4.7
import "ril.js" as RIL
import "storage.js" as Storage
import "toolbar" as ToolBar

Item {
    id: screen
    width: 480
    height: 360

    Rectangle {
        color: "#343434";
        id: container
        anchors.centerIn: parent
        transformOrigin: Item.Center

        Component.onCompleted: {
            Storage.initialize();
            if (Storage.getSetting("apikey")=="Unknown") {
                RIL.rilDownloadApiKey();
            }
            if (Storage.getSetting("username")=="Unknown") {
                loginPage.makeVisible();
            }

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
                    xml = RIL.rilGet();
                }

                id: articleViewer;
                //property string hideReadFeeds: config.hideReadFeeds

                visible: true;
                //property variant model

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

            Login {
                id: loginPage;
            }
        }

        ToolBar.ToolBar {
            id: toolBar; z: 7
            height: 66; anchors.top: parent.top; width: parent.width; opacity: 0.9

            onTaskSwitcherClicked: {
                utility.taskSwitcher();
            }
            onBackClicked: {
                if (loginPage.visible == true) {
                    loginPage.makeHidden();
                } else {
                    if (articleViewer.articleShown == true) {
                        articleViewer.back();

                } else {
                    if (articleViewer.visible == true) {
                        articleViewer.back();
                    } else {
                        Qt.quit();
                    }
                }
            }
            onMenuClicked: loginPage.makeVisible();
            onPrevClicked: articleViewer.prev();
            onNextClicked: articleViewer.next();
            onUpdateClicked: {
                    toolBar.feedUpdating = true;
                    RIL.updateList();
                    articleViewer.refreshList();
                    //toolBar.feedUpdating = false;
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

        property bool lockRotation: false
        //property variant selectedOrientation: Orientation.UnknownOrientation
        //property variant activeOrientation: selectedOrientation == Orientation.UnknownOrientation ? runtime.orientation : selectedOrientation
        property variant oldOrientation: "Portrait"
        state: utility.state
        property bool inPortrait: (state == "Portrait" || state == "PortraitInverted");

        // rotation correction for landscape devices like N900
        property bool landscapeWindow: screen.width > screen.height
        property variant rotationDelta: landscapeWindow ? -90 : 0
        rotation: rotationDelta

        // initial state is portrait
        property real baseWidth: landscapeWindow ? screen.height : screen.width
        property real baseHeight: landscapeWindow ? screen.width : screen.height

        width: baseWidth
        height: baseHeight

        function getAngle(orientation) {
            var angle;
            if (orientation == "Portrait") {
                angle = 0;
            } else if (orientation == "Landscape") {
                angle = 90;
            } else if (orientation == "PortraitInverted") {
                angle = 180;
            } else if (orientation == "LandscapeInverted") {
                angle = 270;
            } else {
                angle = getAngle(oldOrientation);
            }
            return angle;
        }

        states: [
            State {
                name: "Landscape"
                PropertyChanges {
                    target: container
                    rotation: getAngle("Landscape")+rotationDelta
                    width: baseHeight
                    height: baseWidth
                }
                //StateChangeScript { script: container.oldOrientation=Orientation.Landscape }
            },
            State {
                name: "PortraitInverted"
                PropertyChanges {
                    target: container
                    rotation: getAngle("PortraitInverted")+rotationDelta
                    width: baseWidth
                    height: baseHeight
                }
                //StateChangeScript { script: container.oldOrientation=Orientation.PortraitInverted }
            },
            State {
                name: "LandscapeInverted"
                PropertyChanges {
                    target: container
                    rotation: getAngle("LandscapeInverted")+rotationDelta
                    width: baseHeight
                    height: baseWidth
                }
                //StateChangeScript { script: container.oldOrientation=Orientation.LandscapeInverted }
            },
            State {
                name: "Portrait"
                PropertyChanges {
                    target: container
                    rotation: getAngle("Portrait")+rotationDelta
                    width: baseWidth
                    height: baseHeight
                }
                //StateChangeScript { script: container.oldOrientation=Orientation.Portrait }
            },
            State {
                name: "orientation 0"
                PropertyChanges {
                    target: container
                    rotation: getAngle(container.oldOrientation)+rotationDelta
                    width: container.inPortrait ? baseWidth : baseHeight
                    height: container.inPortrait ? baseHeight : baseWidth
                }
                //StateChangeScript {  }
            }
        ]
        transitions: Transition {
            ParallelAnimation {
                RotationAnimation {
                    direction: RotationAnimation.Shortest
                    duration: 300
                    easing.type: Easing.InOutQuint
                }
                NumberAnimation {
                    properties: "x,y,width,height"
                    duration: 300
                    easing.type: Easing.InOutQuint
                }
            }
        }
    }
}
