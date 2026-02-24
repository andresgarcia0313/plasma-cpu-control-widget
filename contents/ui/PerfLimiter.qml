import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import "logic/CpuWriter.js" as Writer

Column {
    id: root

    property int currentPerf: 100
    signal perfChangeRequested(int newValue)

    spacing: 8

    PlasmaComponents.Label {
        text: "CPU Limit"
        font.pointSize: 10
        opacity: 0.6
        anchors.horizontalCenter: parent.horizontalCenter
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12

        Rectangle {
            width: 44; height: 44
            radius: 22
            color: Writer.canDecrease(root.currentPerf)
                ? Qt.rgba(PlasmaCore.Theme.textColor.r,
                          PlasmaCore.Theme.textColor.g,
                          PlasmaCore.Theme.textColor.b, 0.1)
                : "transparent"
            opacity: Writer.canDecrease(root.currentPerf) ? 1.0 : 0.3

            PlasmaComponents.Label {
                text: "−5"
                font.pointSize: 12
                font.weight: Font.Medium
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                enabled: Writer.canDecrease(root.currentPerf)
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: root.perfChangeRequested(Writer.decrease(root.currentPerf))
            }
        }

        Column {
            spacing: 2

            PlasmaComponents.Label {
                text: root.currentPerf + "%"
                font.pointSize: 22
                font.weight: Font.DemiBold
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 80; height: 4
                radius: 2
                color: Qt.rgba(PlasmaCore.Theme.textColor.r,
                               PlasmaCore.Theme.textColor.g,
                               PlasmaCore.Theme.textColor.b, 0.1)
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: parent.width * root.currentPerf / 100
                    height: parent.height
                    radius: 2
                    color: root.currentPerf > 80 ? "#34c759"
                         : root.currentPerf > 50 ? "#ffcc00"
                         : "#ff9500"
                }
            }
        }

        Rectangle {
            width: 44; height: 44
            radius: 22
            color: Writer.canIncrease(root.currentPerf)
                ? Qt.rgba(PlasmaCore.Theme.textColor.r,
                          PlasmaCore.Theme.textColor.g,
                          PlasmaCore.Theme.textColor.b, 0.1)
                : "transparent"
            opacity: Writer.canIncrease(root.currentPerf) ? 1.0 : 0.3

            PlasmaComponents.Label {
                text: "+5"
                font.pointSize: 12
                font.weight: Font.Medium
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                enabled: Writer.canIncrease(root.currentPerf)
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: root.perfChangeRequested(Writer.increase(root.currentPerf))
            }
        }
    }
}
