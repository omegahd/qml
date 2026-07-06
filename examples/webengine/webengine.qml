import QtQuick
import QtWebEngine
import QtQuick.Controls

ApplicationWindow {
    id: root
    width: 1024
    height: 768

    WebEngineView {
        anchors.fill: parent
        url: "http://codingame.com"
    }
}
