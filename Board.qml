import QtQuick 2.0
import "qrc:/scripts.js" as Script

Grid {
    id: board
    anchors.left: parent.left
    width: 480
    height: 480
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
