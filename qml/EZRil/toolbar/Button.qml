import Qt 4.7

Item {
    id: container

    signal clicked

    property string text
    property string imageSource: ""
    property int imageRotation: 0

    property alias iconRotation: icon.rotation

    BorderImage {
        id: buttonImage
        source: "images/toolbutton.sci"
        width: container.width; height: container.height
        //visible: (container.imageSource=="")
    }
    BorderImage {
        id: pressed
        opacity: 0
        source: "images/toolbutton.sci"
        width: container.width; height: container.height
        //visible: (container.imageSource=="")
    }
    Image {
        id: icon
        source: container.imageSource
        rotation: container.imageRotation
        //fillMode: Image.PreserveAspectFit
        smooth: true
        anchors.centerIn: buttonImage;
        //width: container.width; height: container.height
    }
    MouseArea {
        id: mouseRegion
        anchors.fill: buttonImage
        onClicked: { container.clicked(); }
    }
    Text {
        color: "white"
        anchors.centerIn: buttonImage; font.bold: true
        text: container.text; style: Text.Raised; styleColor: "black"
        visible: (container.imageSource=="")
    }
    states: [
        State {
            name: "Pressed"
            when: mouseRegion.pressed == true
            PropertyChanges { target: pressed; opacity: 1 }
        }
    ]
}
