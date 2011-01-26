import Qt 4.7
import "storage.js" as Storage
import "ril.js" as RIL

Rectangle {
    id: loginPage
    width: parent.width;
    height: parent.height;
    visible:false

    function makeVisible() {
        var username = Storage.getSetting("username");
        usernameInput.text = (username=="Unknown") ? "" : username;
        var password = Storage.getSetting("password");
        passwordInput.text = (password=="Unknown") ? "" : password;
        errorText.visible = false;
        loginPage.visible = true;
    }

    function makeHidden() {
        loginPage.visible = false;
    }

    Text {
        id: text3
        y: 20
        //width: 80
        height: 60
        text: "Log In to Read It Later"
        anchors.horizontalCenter: parent.horizontalCenter
        //font.pixelSize: 16
    }

    Text {
        id: errorText
        y: 65
        visible: false
        height: 60
        text: "Error: invalid username or password"
        anchors.horizontalCenter: parent.horizontalCenter
        //font.pixelSize: 16
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 125
        width: 160

        Text {
            id: text1
            anchors.left: parent.left
            //width: 80
            height: 60
            text: "Username: "
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            //font.pixelSize: 16
        }

        Rectangle {
            width: 86
            height: 60
            color: "#a8a7a7"
            anchors.right: parent.right

            TextInput {
                id: usernameInput
                width: parent.width-6
                height: parent.height-6
                font.pixelSize: 16
                font.bold: true
                color: "#151515";
                focus: true
                selectByMouse: true

                text: ""
                //font.pixelSize: 16
            }
        }
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 185
        width: 160

        Text {
            id: text2
            anchors.left: parent.left
            //width: 80
            height: 60
            text: "Password: "
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            //font.pixelSize: 16
        }

        Rectangle {
            width: 86
            height: 60
            color: "#a8a7a7"
            anchors.right: parent.right

            TextInput {
                id: passwordInput
                width: parent.width-6
                height: parent.height-6

                text: ""
                echoMode: TextInput.Password
                //font.pixelSize: 16
            }
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 245
        height: 60
        width: 80
        color: "#d1d1d1"
        border.color: "black"
        radius: 5

        Text {
            id: loginButton
            //width: 80
            anchors.fill: parent
            text: "Save"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //font.pixelSize: 16
        }

        MouseArea {
            id: mouse_area1
            anchors.fill: parent
            onClicked: {
                console.log("Login clicked")
                if (usernameInput.text != "") {
                    Storage.setSetting("username",usernameInput.text);
                    Storage.setSetting("password",passwordInput.text);
                    loginPage.makeHidden();
                } else {
                    errorText.text = "Please enter a valid username."
                    errorText.visible = true;
                }
            }
        }
    }

    Text {
        id: text4
        anchors.horizontalCenter: parent.horizontalCenter
        y: 305
        //width: 80
        height: 60
        text: "If you do not have an account, please sign up."
        wrapMode: Text.WordWrap
        //font.pixelSize: 16
    }

}
