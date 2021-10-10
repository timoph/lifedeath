import QtQuick 2.0
import "qrc:/scripts.js" as Script

Rectangle {
    id: rootItem
    implicitHeight: 25
    implicitWidth: 25
    radius: 45
    color: "#000"
    state: "dead"

    states: [
        State {
            name: "alive"
            PropertyChanges {
                target: rootItem
                opacity: 0.8
                color: "#0f0"
            }
        },
        State {
            name: "dead"
            PropertyChanges {
                target: rootItem
                opacity: 0.0
            }
        }
    ]

//    transitions: [
//        Transition {
//            NumberAnimation { properties: "opacity"; duration: 500}
//        }
//    ]
}
