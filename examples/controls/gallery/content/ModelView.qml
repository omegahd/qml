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
import QtQuick.Layouts

Item {
    anchors.fill: parent

    ListModel {
        id: dummyModel
        Component.onCompleted: {
            for (var i = 0; i < 100; ++i)
                dummyModel.append({"title": "A title " + i, "credit": "Some credit"})
        }
    }

    Frame {
        anchors.fill: parent
        anchors.margins: 8
        padding: 1

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Label { text: "Index"; font.bold: true; padding: 4; Layout.preferredWidth: 80 }
                Label { text: "Title"; font.bold: true; padding: 4; Layout.preferredWidth: 200 }
                Label { text: "Credit"; font.bold: true; padding: 4; Layout.fillWidth: true }
            }

            ListView {
                id: view
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: dummyModel
                ScrollBar.vertical: ScrollBar { }
                delegate: Rectangle {
                    id: row
                    required property int index
                    required property string title
                    required property string credit
                    property bool selected: ListView.isCurrentItem
                    width: view.width
                    height: 22
                    color: selected ? "#448" : (index % 2 ? "#eee" : "#fff")
                    Row {
                        anchors.fill: parent
                        Text { width: 80; text: row.index; color: row.selected ? "white" : "black"; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                        Text { width: 200; text: row.title; color: row.selected ? "white" : "black"; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                        Text { width: 200; text: row.credit; color: row.selected ? "white" : "black"; anchors.verticalCenter: parent.verticalCenter; leftPadding: 4 }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: view.currentIndex = row.index
                    }
                }
            }
        }
    }
}
