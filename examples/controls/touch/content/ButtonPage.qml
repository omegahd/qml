/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick
import QtQuick.Controls.Basic

Item {
    width: parent.width
    height: parent.height

    component TouchButton: Button {
        id: control
        implicitWidth: 320
        implicitHeight: 50
        contentItem: Text {
            text: control.text
            color: "white"
            font.pixelSize: 23
            renderType: Text.NativeRendering
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: BorderImage {
            antialiasing: true
            border { left: 8; right: 8; top: 8; bottom: 8 }
            source: control.pressed ? "../images/button_pressed.png" : "../images/button_default.png"
        }
    }

    component TouchSwitch: Switch {
        id: control
        implicitWidth: 120
        implicitHeight: 50
        indicator: Rectangle {
            anchors.fill: parent
            color: "#222"
            border.color: "#444"
            border.width: 2

            Rectangle {
                width: parent.width / 2 - 2
                anchors { top: parent.top; bottom: parent.bottom; left: parent.left; margins: 2 }
                color: control.checked ? "#468bb7" : "#222"
                Behavior on color { ColorAnimation { } }
                Text {
                    font.pixelSize: 23
                    color: "white"
                    anchors.centerIn: parent
                    text: "ON"
                }
            }
            Item {
                width: parent.width / 2
                height: parent.height
                anchors.right: parent.right
                Text {
                    font.pixelSize: 23
                    color: "white"
                    anchors.centerIn: parent
                    text: "OFF"
                }
            }
            Rectangle {
                id: handle
                x: control.checked ? parent.width / 2 : 0
                width: parent.width / 2
                height: parent.height
                color: "#444"
                border.color: "#555"
                border.width: 2
                Behavior on x { NumberAnimation { duration: 100 } }
            }
        }
    }

    Column {
        spacing: 40
        anchors.centerIn: parent

        TouchButton {
            text: "Press me"
        }

        TouchButton {
            text: "Press me too"
        }

        TouchButton {
            text: "Don't press me"
            onClicked: if (stackView) stackView.pop()
        }

        Row {
            spacing: 20
            TouchSwitch { }
            TouchSwitch { }
        }
    }
}
