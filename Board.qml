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

import QtQuick 2.0
import "qrc:/scripts.js" as Script

Grid {
    id: board
    anchors.left: parent.left
    width: parent.width
    height: parent.height
    columns: Script.cols

    property bool simulationRunning: false
    signal stopped()
    signal started()

    Repeater {
        id: repeater
        model: board.columns * Script.rows

        Rectangle {
            id: blockContainer
            width: board.width / board.columns
            height: width
            border.width: appWindow.simulationRunning ? 1 : 1
            color: "#000"
            border.color: "#222"

            Component.onCompleted: Script.createBlock(blockContainer, width, index)

            MouseArea {
                anchors.fill: parent
                onClicked: Script.toggleState(index)
                enabled: !appWindow.simulationRunning
            }
        }
    }

    Timer {
        id: stepTimer
        interval: 1000
        repeat: true
        onTriggered: {
            if(Script.aliveCount() === 0) {
                board.simulationRunning = false
                stopped()
            }
            else Script.progress()
        }
        running: board.simulationRunning
    }
}
