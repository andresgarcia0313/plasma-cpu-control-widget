import QtQuick 2.15
import org.kde.plasma.components 2.0 as PlasmaComponents
import "logic/CpuReader.js" as Reader

Column {
    id: root

    property int temperature: 0
    spacing: 2

    PlasmaComponents.Label {
        text: root.temperature + "°C"
        font.pointSize: 28
        font.weight: Font.Light
        color: Reader.tempColor(root.temperature)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    PlasmaComponents.Label {
        text: Reader.tempLabel(root.temperature)
        font.pointSize: 10
        opacity: 0.6
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
