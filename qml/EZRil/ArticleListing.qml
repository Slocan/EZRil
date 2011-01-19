import Qt 4.7

Item {
    //anchors.fill: parent;
    width: parent.width; height: parent.height;
    //x: parent.width;
    anchors.top: parent.top; anchors.bottom: parent.bottom

    ListView {
        id: feedList; delegate: feedDelegate; z: 6
        width: parent.width; height: parent.height; /*x: 0;*/
        cacheBuffer: 100;
        flickDeceleration: 1500
        model: parent.model

    }

    Component {
        id: feedDelegate

        Item {
            id: wrapper; width: wrapper.ListView.view.width;
            visible: true
            height: (visible) ? 86 : 0

            Item {
                id: moveMe
                Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: 84; width: wrapper.width; y: 1 }
                Rectangle {
                    x: 3; y: 4; width: 77; height: 77; color: "#000000"; smooth: true
//                    Image { width:32; height: 32; anchors.verticalCenter: parent.verticalCenter; anchors.horizontalCenter: parent.horizontalCenter;
//                        source: (updating=="True")? "common/images/loading.png" : (icon == "False") ? "common/images/feedingit.png" : icon;
//                        NumberAnimation on rotation {
//                            from: 0; to: 360; running: (updating=="True"); loops: Animation.Infinite; duration: 900
//                        }
//                    }
                }

                Column {
                    x: 92; width: wrapper.ListView.view.width - 95; y: 5; spacing: 2
                    Text { text: title; color: "white"; width: parent.width; font.bold: true; elide: Text.ElideRight; style: Text.Raised; styleColor: "black" }
                    //Text { text: updatedDate + " / " + qsTr("%1 unread items").arg(unread); color: (unread=="0") ? "white" : "#7b97fd"; width: parent.width; font.bold: false; elide: Text.ElideRight; style: Text.Raised; styleColor: "black" }
                    //Text { text: feedname; width: parent.width; elide: Text.ElideLeft; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
                }
            }
            //MouseArea { anchors.fill: wrapper; onClicked: { container.feedClicked(feedid, updating=="True") } }
        }

    }

}
