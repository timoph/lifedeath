/*
 LifeDeath - A life game implementation
 Copyright (C) 2021 Timo Härkönen

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4
import "qrc:/scripts.js" as Script

Window {
    id: appWindow
    width: 800
    height: 480
    visible: true
    title: qsTr("Life (and some death)")

    property bool simulationRunning: false

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#000"
    }

    Loader {
        id: board
        anchors.left: parent.left
        width: appWindow.width - (appWindow.width / 2.5)
        height: width
        source: "qrc:/Board.qml"

        function handleStopped() {
            simulationRunning = false;
            Script.simRunning = false;
        }

        onLoaded: {
            item.stopped.connect(handleStopped)
        }
    }

    Button {
        id: stepButton
        width: startStopButton.width
        height: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: board.right
        anchors.leftMargin: 5
        text: qsTr("Step forward")
        enabled: !appWindow.simulationRunning
        onClicked: {
            Script.progress()
        }
    }

    Button {
        id: startStopButton
        width: (appWindow.width - board.width - anchors.leftMargin) / 2 - anchors.leftMargin
        height: 40
        anchors.top: stepButton.top
        anchors.left: stepButton.right
        anchors.leftMargin: 5
        text: appWindow.simulationRunning ? qsTr("Stop simulation") : qsTr("Run simulation")
        onClicked: {
            board.item.simulationRunning = !board.item.simulationRunning
            appWindow.simulationRunning = board.item.simulationRunning
            Script.simRunning = !Script.simRunning
        }
    }

    Button {
        id: clearButton
        width: appWindow.width - board.width - 2 * anchors.leftMargin
        height: 40
        anchors.bottom: startStopButton.top
        anchors.bottomMargin: 5
        anchors.left: board.right
        anchors.leftMargin: 5
        text: qsTr("Clear and init")
        enabled: !simulationRunning

        onClicked: {
            Script.clear()
            board.source = ""
            Script.init(widthSpin.value)
            board.source = "qrc:/Board.qml"
        }
    }

    Row {
        anchors.bottom: clearButton.top
        anchors.bottomMargin: 5
        anchors.left: board.right
        anchors.leftMargin: 5
        width: appWindow.width - board.width - 2 * anchors.leftMargin
        spacing: 5

        Text {
            id: colsText
            text: qsTr("Grid size")
            color: "#fff"
            width: parent.width / 4
            height: widthSpin.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        SpinBox {
            id: widthSpin
            width: (parent.width - parent.width / 4) - 5
            from: 10
            to: 200
            value: 30

            contentItem: Text {
                font: widthSpin.font
                text: widthSpin.value + "x" + widthSpin.value
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
            }
        }
    }

    Column {
        id: infoColumn
        anchors.left: board.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        width: clearButton.width
        height: board.height - startStopButton.height - 2 * anchors.leftMargin
        spacing: 5

        Text {
            width: parent.width
            id: titleText
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 20
            text: qsTr("Life")
            color: "#fff"
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            wrapMode: Text.WordWrap
            color: "#fff"
            text: qsTr("* Any alive cell with fewer than two live neighbours dies to underpopulation.")
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            wrapMode: Text.WordWrap
            color: "#fff"
            text: qsTr("* Any alive cell with more than three live neighbours dies to overpopulation.")
        }

        Text {
            width: parent.width
            font.pointSize: 12
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            color: "#fff"
            text: qsTr("* Any alive cell with two or three live neighbours lives.")
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            wrapMode: Text.WordWrap
            color: "#fff"
            text: qsTr("* Any dead cell with exactly three live neighbours becomes alive by reproduction.")
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            wrapMode: Text.WordWrap
            color: "#fff"
            text: qsTr("Select alive cells and click start to begin.")
        }
    }
}
