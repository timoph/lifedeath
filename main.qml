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

    Grid {
        id: board
        anchors.left: parent.left
        anchors.leftMargin: 5
        width: 480
        height: 480
        columns: Script.cols

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
                if(Script.aliveCount() === 0) appWindow.simulationRunning = false
                else Script.progress()
            }
            running: appWindow.simulationRunning
        }
    }

    Button {
        id: startStopButton
        width: appWindow.width - board.width - 10
        height: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: board.right
        anchors.leftMargin: 5
        text: appWindow.simulationRunning ? "stop" : "start"
        onClicked: appWindow.simulationRunning = !appWindow.simulationRunning
    }

    Column {
        id: infoColumn
        anchors.left: board.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        width: startStopButton.width
        height: board.height - startStopButton.height - 10
        spacing: 30

        Text {
            width: parent.width
            id: titleText
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 20
            text: qsTr("Life (and some death)")
            color: "#fff"
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            wrapMode: Text.WordWrap
            color: "#fff"
            text: "* Any alive cell with fewer than two live neighbours dies to underpopulation."
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            wrapMode: Text.WordWrap
            color: "#fff"
            text: "* Any alive cell with more than three live neighbours dies to overpopulation."
        }

        Text {
            width: parent.width
            font.pointSize: 12
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            color: "#fff"
            text: "* Any alive cell with two or three live neighbours lives."
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            wrapMode: Text.WordWrap
            color: "#fff"
            text: "* Any dead cell with exactly three live neighbours becomes alive by reproduction."
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            wrapMode: Text.WordWrap
            color: "#fff"
            text: "Set alive cells and click start to begin."
        }
    }
}
