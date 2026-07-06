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
import QtQuick.Dialogs
import "content"

ApplicationWindow {
    visible: true
    title: "Component Gallery"

    width: 640
    height: 420
    minimumHeight: 400
    minimumWidth: 600

    ImageViewer { id: imageViewer }

    FileDialog {
        id: fileDialog
        nameFilters: [ "Image files (*.png *.jpg)" ]
        onAccepted: imageViewer.open(selectedFile)
    }

    AboutDialog { id: aboutDialog }

    Action {
        id: openAction
        text: "&Open"
        shortcut: StandardKey.Open
        icon.source: "images/document-open.png"
        onTriggered: fileDialog.open()
    }

    Action {
        id: copyAction
        text: "&Copy"
        shortcut: StandardKey.Copy
        enabled: (!!activeFocusItem && !!activeFocusItem["copy"])
        onTriggered: activeFocusItem.copy()
    }

    Action {
        id: cutAction
        text: "Cu&t"
        shortcut: StandardKey.Cut
        enabled: (!!activeFocusItem && !!activeFocusItem["cut"])
        onTriggered: activeFocusItem.cut()
    }

    Action {
        id: pasteAction
        text: "&Paste"
        shortcut: StandardKey.Paste
        enabled: (!!activeFocusItem && !!activeFocusItem["paste"])
        onTriggered: activeFocusItem.paste()
    }

    Action {
        id: aboutAction
        text: "About"
        onTriggered: aboutDialog.open()
    }

    ActionGroup {
        id: textFormatGroup

        Action {
            id: a1
            text: "Align &Left"
            checkable: true
            checked: true
        }

        Action {
            id: a2
            text: "&Center"
            checkable: true
        }

        Action {
            id: a3
            text: "Align &Right"
            checkable: true
        }
    }

    ChildWindow { id: window1 }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 0
            ToolButton {
                icon.source: "images/window-new.png"
                onClicked: window1.visible = !window1.visible
                Accessible.name: "New window"
                ToolTip.visible: hovered
                ToolTip.text: "Toggle visibility of the second window"
            }
            ToolButton {
                action: openAction
                display: AbstractButton.IconOnly
                ToolTip.visible: hovered
                ToolTip.text: "Open an image"
            }
            ToolButton {
                Accessible.name: "Save as"
                icon.source: "images/document-save-as.png"
                ToolTip.visible: hovered
                ToolTip.text: "(Pretend to) Save as..."
            }
            Item { Layout.fillWidth: true }
            CheckBox {
                id: enabledCheck
                text: "Enabled"
                checked: true
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem { action: openAction }
            MenuItem {
                text: "Close"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: "&Edit"
            MenuItem { action: cutAction }
            MenuItem { action: copyAction }
            MenuItem { action: pasteAction }
            MenuSeparator { }
            Menu {
                title: "Text &Format"
                MenuItem { action: a1 }
                MenuItem { action: a2 }
                MenuItem { action: a3 }
                MenuSeparator { }
                MenuItem { text: "Allow &Hyphenation"; checkable: true }
            }
            Menu {
                title: "Font &Style"
                MenuItem { text: "&Bold"; checkable: true }
                MenuItem { text: "&Italic"; checkable: true }
                MenuItem { text: "&Underline"; checkable: true }
            }
        }
        Menu {
            title: "&Help"
            MenuItem { action: aboutAction }
        }
    }

    SystemPalette { id: syspal }
    color: syspal.window

    ListModel {
        id: choices
        ListElement { text: "Banana" }
        ListElement { text: "Orange" }
        ListElement { text: "Apple" }
        ListElement { text: "Coconut" }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 2
        spacing: 0
        enabled: enabledCheck.checked

        TabBar {
            id: bar
            Layout.fillWidth: true
            TabButton { text: "Controls" }
            TabButton { text: "Itemviews" }
            TabButton { text: "Styles" }
            TabButton { text: "Layouts" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: bar.currentIndex

            Item { Controls { } }
            Item { ModelView { } }
            Item { Styles { } }
            Item { Layouts { } }
        }
    }
}
