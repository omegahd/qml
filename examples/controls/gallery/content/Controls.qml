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
import QtQuick.Controls
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts

Item {
    anchors.fill: parent

    property string loremIpsum:
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud "+
            "exercitation ullamco laboris nisi ut aliquip ex ea commodo cosnsequat. "

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        RowLayout {
            spacing: 8
            Button {
                text: "Button 1"
                ToolTip.visible: hovered
                ToolTip.text: "This is an interesting tool tip"
            }
            Button {
                id: menuButton
                text: "Button 2"
                onClicked: buttonMenu.open()
                Menu {
                    id: buttonMenu
                    y: menuButton.height
                    MenuItem { text: "This Button" }
                    MenuItem { text: "Happens To Have" }
                    MenuItem { text: "A Menu Assigned" }
                }
            }
            ComboBox {
                model: choices
                currentIndex: 2
                Layout.preferredWidth: 130
            }
            ComboBox {
                model: ["Apple", "Banana", "Coconut"]
                editable: true
                Layout.preferredWidth: 130
            }
            Item { Layout.fillWidth: true }
        }

        RowLayout {
            spacing: 8
            CheckBox {
                id: frameCheckbox
                text: "Text frame"
                checked: true
            }
            Switch { checked: true }
            RadioButton {
                text: "Radio 1"
                checked: true
                ButtonGroup.group: radioGroup
            }
            RadioButton {
                text: "Radio 2"
                ButtonGroup.group: radioGroup
            }
            ButtonGroup { id: radioGroup }
            Item { Layout.fillWidth: true }
        }

        RowLayout {
            spacing: 8
            TextField {
                text: "TextField"
                Layout.preferredWidth: 130
            }
            SpinBox {
                value: 50
                from: 0
                to: 100
                editable: true
            }
            Slider {
                id: slider
                value: 0.5
                Layout.preferredWidth: 130
            }
            ProgressBar {
                value: slider.value
                Layout.preferredWidth: 130
            }
            BusyIndicator {
                running: true
                Layout.preferredHeight: 28
                Layout.preferredWidth: 28
            }
            Item { Layout.fillWidth: true }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            // The customized background requires a non-native style.
            Basic.TextArea {
                text: loremIpsum + loremIpsum
                wrapMode: TextArea.Wrap
                background: Rectangle {
                    visible: frameCheckbox.checked
                    color: "white"
                    border.color: "#999"
                }
            }
        }
    }
}
