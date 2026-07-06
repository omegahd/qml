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

// In Qt Quick Controls 2 there is no separate Styles module; controls are
// customized by replacing their visual delegates (background, contentItem,
// handle, indicator, ...) directly. The native platform styles do not
// support customization, so this file imports the Basic style explicitly.

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        RowLayout {
            spacing: 12

            Button {
                id: styledButton
                text: "Push me"
                implicitWidth: 100
                implicitHeight: 25
                contentItem: Text {
                    text: styledButton.text
                    color: "#333"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: BorderImage {
                    source: styledButton.pressed ? "../images/button-pressed.png" : "../images/button.png"
                    border { left: 4; right: 4; top: 4; bottom: 4 }
                }
            }

            TextField {
                id: styledField
                text: "Custom text field"
                color: "#333"
                implicitWidth: 150
                implicitHeight: 25
                background: BorderImage {
                    source: "../images/textfield.png"
                    border { left: 4; right: 4; top: 4; bottom: 4 }
                }
            }

            Item { Layout.fillWidth: true }
        }

        RowLayout {
            spacing: 12

            Slider {
                id: styledSlider
                value: 0.5
                Layout.preferredWidth: 180
                background: BorderImage {
                    y: (styledSlider.height - height) / 2
                    width: styledSlider.availableWidth
                    height: 12
                    source: "../images/progress-background.png"
                    border { left: 4; right: 4; top: 4; bottom: 4 }
                }
                handle: Image {
                    x: styledSlider.leftPadding + styledSlider.visualPosition * (styledSlider.availableWidth - width)
                    y: (styledSlider.height - height) / 2
                    source: "../images/slider-handle.png"
                }
            }

            ProgressBar {
                id: styledProgress
                value: styledSlider.value
                implicitHeight: 12
                Layout.preferredWidth: 180
                background: BorderImage {
                    source: "../images/progress-background.png"
                    border { left: 4; right: 4; top: 4; bottom: 4 }
                }
                contentItem: Item {
                    implicitHeight: 12
                    BorderImage {
                        width: styledProgress.visualPosition * parent.width
                        height: parent.height
                        source: "../images/progress-fill.png"
                        border { left: 4; right: 4; top: 4; bottom: 4 }
                    }
                }
            }

            Item { Layout.fillWidth: true }
        }

        TabBar {
            id: styledTabs
            Layout.preferredWidth: 300

            component StyledTab: TabButton {
                id: tab
                contentItem: Text {
                    text: tab.text
                    color: "#333"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: BorderImage {
                    source: tab.checked ? "../images/tab_selected.png" : "../images/tab.png"
                    border { left: 4; right: 4; top: 4; bottom: 4 }
                }
            }

            StyledTab { text: "One" }
            StyledTab { text: "Two" }
            StyledTab { text: "Three" }
        }

        Item { Layout.fillHeight: true }
    }
}
