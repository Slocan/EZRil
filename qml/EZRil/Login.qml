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

    Text {
        id: text3
        y: 20
        //width: 80
        height: 20
        text: "Log In to Read It Later"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
    }

    Text {
        id: errorText
        y: 45
        visible: false
        height: 20
        text: "Error: invalid username or password"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 65
        width: 160

        Text {
            id: text1
            anchors.left: parent.left
            width: 80
            height: 20
            text: "Username: "
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 12
        }

        TextInput {
            id: usernameInput
            anchors.right: parent.right
            width: 80
            height: 20
            font.pixelSize: 12
        }
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 95
        width: 160

        Text {
            id: text2
            anchors.left: parent.left
            width: 80
            height: 20
            text: "Password: "
            font.pixelSize: 12
        }

        TextInput {
            id: passwordInput

            anchors.right: parent.right
            width: 80
            height: 20
            text: ""
            echoMode: TextInput.Password
            font.pixelSize: 12
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 120
        height: 20
        width: 80
        color: "#d1d1d1"
        border.color: "black"

        Text {
            id: loginButton
            //width: 80
            anchors.fill: parent
            text: "Save"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
            states: [State {name: "loading";
                    PropertyChanges { target: loginButton; text: qsTr("Loading") }
                }
            ]
        }

        MouseArea {
            id: mouse_area1
            anchors.fill: parent
            onClicked: {
                console.log("Login clicked")
                if (usernameInput.text != "") {
//                    loginButton.state = "loading"
                    Storage.setSetting("username",usernameInput.text);
                    Storage.setSetting("password",passwordInput.text);
                    loginPage.visible = false;
//                    var res = RIL.checkLogin();
//                    console.log("Ril: "+res)
//                    if (res) {
//                        loginPage.visible = false;
//                        console.log("Closing login")
//                    } else {
//                        errorText.text = "Error: unable to login with these credentials."
//                        errorText.visible = true;
//                        console.log("Showing error 1")
//                    }
//                    loginButton.state = "";
                } else {
                    errorText.text = "Please enter a valid username."
                    errorText.visible = true;
                    //console.log("Showing error 2")
                }
            }
        }
    }

    Text {
        id: text4
        anchors.horizontalCenter: parent.horizontalCenter
        y: 150
        //width: 80
        height: 20
        text: "If you do not have an account, please sign up."
        wrapMode: Text.WordWrap
        font.pixelSize: 12
    }

}
