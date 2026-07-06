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
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.XmlListModel

ApplicationWindow {
    visible: true
    width: 570
    height: 420
    title: "Table views"

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            TabBar {
                id: bar
                Layout.fillWidth: true
                background: null
                TabButton { text: "XmlListModel" }
                TabButton { text: "Generated" }
                TabButton { text: "Editable" }
            }
            CheckBox {
                id: alternateCheck
                text: "Alternate"
                checked: true
            }
            CheckBox {
                id: enabledCheck
                text: "Enabled"
                checked: true
            }
        }
    }

    SystemPalette { id: syspal }
    color: syspal.window

    XmlListModel {
        id: feedModel
        source: "https://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=Qt"
        query: "/rss/channel/item"
        XmlListModelRole { name: "title"; elementName: "title" }
        XmlListModelRole { name: "pubDate"; elementName: "pubDate" }
        XmlListModelRole { name: "link"; elementName: "link" }
    }

    ListModel {
        id: largeModel
        Component.onCompleted: {
            for (var i = 0; i < 500; ++i)
                largeModel.append({"name": "Person " + i,
                                   "age": Math.round(Math.random() * 100),
                                   "gender": Math.random() > 0.5 ? "Male" : "Female"})
        }
    }

    component HeaderCell: BorderImage {
        property alias text: headerText.text
        height: 24
        source: "images/header.png"
        border { left: 2; right: 2; top: 2; bottom: 2 }
        Text {
            id: headerText
            anchors.centerIn: parent
            color: "#333"
        }
    }

    StackLayout {
        anchors.fill: parent
        anchors.margins: 8
        currentIndex: bar.currentIndex
        enabled: enabledCheck.checked

        // Rows fetched live from an RSS feed through XmlListModel.
        Frame {
            padding: 1
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    HeaderCell { text: "Title"; Layout.preferredWidth: 220 }
                    HeaderCell { text: "Published"; Layout.preferredWidth: 180 }
                    HeaderCell { text: "Link"; Layout.fillWidth: true }
                }
                ListView {
                    id: feedView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: feedModel
                    delegate: Rectangle {
                        id: feedRow
                        required property int index
                        required property string title
                        required property string pubDate
                        required property string link
                        property bool selected: ListView.isCurrentItem
                        width: feedView.width
                        height: 20
                        color: selected ? "#448"
                             : (alternateCheck.checked && index % 2 ? "#eee" : "#fff")
                        Row {
                            anchors.fill: parent
                            Text { width: 220; text: feedRow.title; elide: Text.ElideRight; color: feedRow.selected ? "white" : "black"; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                            Text { width: 180; text: feedRow.pubDate; elide: Text.ElideRight; color: feedRow.selected ? "white" : "black"; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                            Text { width: 160; text: feedRow.link; elide: Text.ElideRight; color: feedRow.selected ? "white" : "black"; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: feedView.currentIndex = feedRow.index
                        }
                    }
                }
            }
        }

        // A larger, locally generated model.
        Frame {
            padding: 1
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    HeaderCell { text: "Name"; Layout.preferredWidth: 120 }
                    HeaderCell { text: "Age"; Layout.preferredWidth: 120 }
                    HeaderCell { text: "Gender"; Layout.fillWidth: true }
                }
                ListView {
                    id: largeView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: largeModel
                    delegate: Rectangle {
                        required property int index
                        required property string name
                        required property int age
                        required property string gender
                        property bool selected: ListView.isCurrentItem
                        width: largeView.width
                        height: 20
                        color: alternateCheck.checked && index % 2 ? "#eee" : "#fff"
                        BorderImage {
                            anchors.fill: parent
                            source: "images/selectedrow.png"
                            visible: selected
                            border { left: 2; right: 2; top: 2; bottom: 2 }
                        }
                        Row {
                            anchors.fill: parent
                            Text { width: 120; text: name; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                            Text { width: 120; text: age; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                            Text { width: 120; text: gender; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: largeView.currentIndex = index
                        }
                    }
                }
            }
        }

        // The same model, with cells edited in place.
        Frame {
            padding: 1
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    HeaderCell { text: "Name"; Layout.preferredWidth: 160 }
                    HeaderCell { text: "Age"; Layout.preferredWidth: 120 }
                    HeaderCell { text: "Gender"; Layout.fillWidth: true }
                }
                ListView {
                    id: editView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: largeModel
                    delegate: Rectangle {
                        required property int index
                        required property string name
                        required property int age
                        required property string gender
                        width: editView.width
                        height: 24
                        color: alternateCheck.checked && index % 2 ? "#eee" : "#fff"
                        Row {
                            anchors.fill: parent
                            TextInput {
                                width: 160; text: name
                                anchors.verticalCenter: parent.verticalCenter; leftPadding: 4
                                onEditingFinished: largeModel.setProperty(index, "name", text)
                            }
                            TextInput {
                                width: 120; text: age
                                anchors.verticalCenter: parent.verticalCenter; leftPadding: 4
                                validator: IntValidator { bottom: 0; top: 150 }
                                onEditingFinished: largeModel.setProperty(index, "age", parseInt(text))
                            }
                            TextInput {
                                width: 120; text: gender
                                anchors.verticalCenter: parent.verticalCenter; leftPadding: 4
                                onEditingFinished: largeModel.setProperty(index, "gender", text)
                            }
                        }
                    }
                }
            }
        }
    }
}
