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

Rectangle {
    id: rootItem
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    radius: 45
    color: "#0f0"
    opacity: 0.0
    state: "dead"

    states: [
        State {
            name: "alive"
            PropertyChanges {
                target: rootItem
                opacity: 0.8
                width: rootItem.parent.width
                height: rootItem.parent.height
            }
        },
        State {
            name: "dead"
            PropertyChanges {
                target: rootItem
                opacity: 0.0
                width: 1
                height: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "dead"
            to: "alive"
            ParallelAnimation {
                NumberAnimation { properties: "width"; duration: 500}
                NumberAnimation { properties: "height"; duration: 500}
            }
        },
        Transition {
            from: "alive"
            to: "dead"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { properties: "width"; duration: 300}
                    NumberAnimation { properties: "height"; duration: 300}
                }
                NumberAnimation { properties: "opacity"; duration: 0}
            }
        }
    ]
}
