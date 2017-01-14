import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 320
    height: 480
    title: qsTr("SpeedTap")

    id: root

    /**
      0 : start
      1 : yellow
      2 : red
      3 : error
      4 : winner
    */
    property int status: 0
    property double elapsed: 0

    Timer {
        id: timer
        repeat: false
        onTriggered: {
            status = 2
            elapsed = new Date().getTime()
            gameArea.color = "red"
        }
    }

    Timer {
        id: menuTimer
        repeat: false
        interval: 3333
        onTriggered: {
            status = 0
            gameArea.color = "white"
            circle.visible = false
        }
    }

    function go() {
        circle.visible = false
        timer.interval = Math.random() * 5000  + 2000
        timer.restart()

        gameArea.color = "yellow"

        status = 1
    }

    function end(x, y) {
        elapsed = new Date().getTime() - elapsed

        if (status > 0) {
            p.x = x - circle.width / 2
            p.y = y - circle.height / 2
            circle.visible = true
        }

        if (status == 2) {
            status = 4
            gameArea.color = "lightgreen"
        }
        else
            status = 3

        timer.stop()

        menuTimer.start()
    }

    Rectangle {
        id: gameArea
        anchors.fill: parent

        Item {
            id: p
        }

        Rectangle {
            id: circle
            anchors.centerIn: p
            height: visible ? parent.height * 0.2 : 0
            width: height
            visible: false
            radius: height / 2
            color: "transparent"

            border {
                color: "black"
                width: circle.width * 0.1
            }

            Behavior on height {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutBounce
                }
            }
        }

        Label {
            visible: circle.visible
            text: status == 4 ? qsTr("Winner (%1 s)").arg(elapsed / 1000) : (status == 3 ? "Too fast!" : "")
            font.bold: true
            font.pixelSize: 14
            anchors {
                verticalCenter: circle.verticalCenter
                horizontalCenter: circle.horizontalCenter
                verticalCenterOffset: -circle.height * 0.6
            }
        }

        MouseArea {
            id: m
            anchors.fill: parent
            enabled: status == 1 || status == 2
            onPressed: {
                end(mouseX, mouseY)
            }
        }
    }

    Rectangle {
        id: startButton
        visible: status == 0
        width: parent.width * 0.8
        height: width
        color: "transparent"
        border.color: "black"
        border.width: 5
        anchors.centerIn: parent
        radius: height / 2

        Label {
            text: "Play!"
            anchors.centerIn: parent
            fontSizeMode: Text.Fit
            font.bold: true
            font.pixelSize: parent.height * 0.1
        }

        MouseArea {
            anchors.fill: parent
            onClicked: go()
        }
    }
}
