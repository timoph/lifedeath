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
        //anchors.leftMargin: 5
        width: 480
        height: 480
        source: "qrc:/Board.qml"

        function handleStopped() {
            simulationRunning = false;
        }

        onLoaded: {
            item.stopped.connect(handleStopped)
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
        onClicked: {
            board.item.simulationRunning = !board.item.simulationRunning
            appWindow.simulationRunning = board.item.simulationRunning
        }
    }

    Button {
        id: clearButton
        width: appWindow.width - board.width - 10
        height: 40
        anchors.bottom: startStopButton.top
        anchors.bottomMargin: 5
        anchors.left: board.right
        anchors.leftMargin: 5
        text: "clear and init"
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
        width: appWindow.width - board.width - 10
        spacing: 5

        Text {
            id: colsText
            text: "Grid size"
            color: "#fff"
            width: parent.width / 4
            height: widthSpin.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        SpinBox {
            id: widthSpin
            width: parent.width - parent.width / 4
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
        width: startStopButton.width
        height: board.height - startStopButton.height - 10
        spacing: 20

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
