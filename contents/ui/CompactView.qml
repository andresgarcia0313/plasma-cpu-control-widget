import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import "logic/CpuReader.js" as Reader

Row {
    id: root

    property int temperature: 0
    signal clicked()

    spacing: 4

    PlasmaCore.IconItem {
        source: "cpu"
        width: 16; height: 16
        anchors.verticalCenter: parent.verticalCenter
    }

    PlasmaComponents.Label {
        text: root.temperature + "°C"
        color: Reader.tempColor(root.temperature)
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
