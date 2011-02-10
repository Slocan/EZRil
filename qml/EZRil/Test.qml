import Qt 4.7
import "storage.js" as Storage

Rectangle {
    width: 360
    height: 360
    id: screen
    // Initialize a counter variable. If a value is already stored in the database, use it. Otherwise, starts at 0.
    property int counter: (Storage.getSetting("counter")=="Unknown") ? 0 : parseInt(Storage.getSetting("counter"))

    Text {
        id: textDisplay
        anchors.centerIn: parent
        // This text is updated every time the counter variable is updated
        text: "Current counter is: " + parent.counter
    }

    MouseArea {
        id: mouse_area1
        anchors.fill: parent

        onClicked: {
            // When the window is clicked, increase the counter, and save it into the database
            counter += 1
            Storage.setSetting("counter",counter);
        }
    }

    Component.onCompleted: {
        // Initialize the database. This needs to be done.
        Storage.initialize();
    }
}
