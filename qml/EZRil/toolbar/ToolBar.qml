import Qt 4.7

Item {
    id: toolbar

    property alias menuLabel: menuButton.text
    property alias backLabel: backButton.text
    property alias prevLabel: prevButton.text
    property alias nextLabel: nextButton.text
    property alias markAllLabel: markAllButton.text
    property alias zoomLabel: zoomButton.text
    property alias taskSwitcherLabel: taskSwitcherButton.text

    property alias backVisible: backButton.visible
    property alias nextVisible: nextButton.visible
    property alias prevVisible: prevButton.visible
    property alias markAllVisible: markAllButton.visible
    property alias zoomVisible: zoomButton.visible
    property alias quitVisible: quitButton.visible
    property alias addVisible: addButton.visible
    property alias updateVisible: updateFeedButton.visible

    property bool feedUpdating: false

    signal menuClicked
    signal backClicked
    signal prevClicked
    signal nextClicked
    signal markAllClicked
    signal zoomClicked
    signal taskSwitcherClicked
    signal addClicked
    signal updateClicked
    //signal rotateClicked

    //BorderImage { source: "images/titlebar.sci"; width: parent.width; height: parent.height + 14; y: -7 }
    Rectangle {
        anchors.fill: parent; color: "#343434";
        border.color: "black"
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#343434";
            }
            GradientStop {
                position: 1.00;
                color: "#ffffff";
            }
        }

        Row {
            anchors.fill: parent
            Button {
                id: taskSwitcherButton
                /*anchors.left: parent.left;*/ anchors.leftMargin: 5; y: 3; width: 116; height: 60
                onClicked: toolbar.taskSwitcherClicked()
                imageSource: "images/wmTaskLauncherIcon.png"
            }

            Button {
                id: menuButton
                /*anchors.left: taskSwitcherButton.right;*/ anchors.leftMargin: 5; y: 3; width: 60; height: 60
                visible: true;
                onClicked: toolbar.menuClicked()
                imageSource: "images/wmEditIcon.png"
            }

            Button {
                id: addButton
                visible: false; /*anchors.left: menuButton.right;*/
                anchors.rightMargin: 5; y: 3; width: 60; height: 60
                onClicked: toolbar.addClicked()
                imageSource: "images/plus.png"

            }

            Button {
                id: updateFeedButton
                visible: true; /*anchors.left: menuButton.right;*/
                anchors.rightMargin: 5; y: 3; width: 60; height: 60
                onClicked: toolbar.updateClicked()
                //imageSource: (!feedUpdating) ? "images/rotate.png" : "images/loading.png"
                NumberAnimation on iconRotation {
                    from: 0; to: 360; running: (visible == true) && (feedUpdating); loops: Animation.Infinite; duration: 900
                }
                state: "update"
                states : [State {name: "loading"; when: (feedUpdating);
                        PropertyChanges {target: updateFeedButton; imageSource: "images/loading2.png" }
                    }, State { name: "update"; when: (!feedUpdating);
                        PropertyChanges {target: updateFeedButton; iconRotation: 0}
                        PropertyChanges {target: updateFeedButton; imageSource: "images/rotate.png"}
                    }
                ]
            }

            Button {
                id: markAllButton
                visible: false
                /*anchors.left: updateFeedButton.right;*/ anchors.rightMargin: 5; y: 3; width: 60; height: 60
                onClicked: toolbar.markAllClicked()
                imageSource: "images/checkmark.png"
            }

            Button {
                id: prevButton
                visible: false
                /*anchors.left: menuButton.right;*/ anchors.rightMargin: 5; y: 3; width: 120; height: 60
                onClicked: toolbar.prevClicked()
                imageSource: "images/InputMethodShiftButtonNormal.png"
                imageRotation: -90;
            }

            Button {
                id: zoomButton
                visible: false
                /*anchors.right: backButton.left; */anchors.rightMargin: 5; y: 3; width: 80; height: 60
                onClicked: toolbar.zoomClicked()
                imageSource: "images/Zoom-In-icon.png"
            }

            Button {
                id: nextButton
                visible: false
                /*anchors.right: zoomButton.left;*/ anchors.rightMargin: 5; y: 3; width: 120; height: 60
                onClicked: toolbar.nextClicked()
                imageSource: "images/InputMethodShiftButtonNormal.png"
                imageRotation: 90
            }

            Button {
                id: backButton
                anchors.right: parent.right; anchors.rightMargin: 5; y: 3; width: 116; height: 60
                onClicked: toolbar.backClicked()
                imageSource: "images/wmBackIcon.png"
            }

            Button {
                id: quitButton
                visible: false
                anchors.right: parent.right; anchors.rightMargin: 5; y: 3; width: 116; height: 60
                onClicked: toolbar.backClicked()
                imageSource: "images/wmCloseIcon.png"
            }
        }
    }
}
