import Qt 4.7
import QtWebKit 1.0
//import "common" as Common

Rectangle {
    /*x: parent.width; height: parent.height;*/
    width: parent.width;
    height: parent.height
    //property alias zoomEnabled: slider.visible;
    //property alias value: slider.value;
    //anchors.top: parent.top; anchors.bottom: parent.bottom;
    color: "white";

    Flickable {
        id: flickable
        //anchors.fill: screen;
        height: parent.height;
        width: parent.width;
        contentWidth: webView.width*webView.scale; //Math.max(screen.width,webView.width*webView.scale)
        contentHeight: Math.max(articleViewer.height,webView.height*webView.scale)
        //contentWidth: childrenRect.width; contentHeight: childrenRect.height
        interactive: parent.vertPanningEnabled;

        flickDeceleration: 1500;
        flickableDirection: Flickable.VerticalFlick
        WebView {
            id: webView
            //url: flipItem.articleUrl;
            html:  flipItem.html
            preferredWidth: flickable.width
            preferredHeight: flickable.height
            //scale: 1.25;
            transformOrigin: Item.TopLeft
            //scale: slider.value;
            settings.defaultFontSize: 24
        }

//        onFlickStarted: {
//            console.log("start contentx"+contentX)
//            console.log("start contenty"+contentY)
//        }
    }

//    Common.Slider {
//        id: slider; visible: false
//        minimum: 0.2;
//        maximum: 2;
//        property real prevScale: 1
//        anchors {
//            bottom: parent.bottom; bottomMargin: 65
//            left: parent.left; leftMargin: 25
//            right: parent.right; rightMargin: 25
//        }
//        onValueChanged: {
//            if (webView.width * value > flickable.width) {
//                var xoff = (flickable.width/2 + flickable.contentX) * value / prevScale;
//                flickable.contentX = xoff - flickable.width/2;
//            }
//            if (webView.height * value > flickable.height) {
//                var yoff = (flickable.height/2 + flickable.contentY) * value / prevScale;
//                flickable.contentY = yoff - flickable.height/2;
//            }
//            prevScale = value;
 //       }
//        Component.onCompleted: {value=0; value=1; }
//    }
}
