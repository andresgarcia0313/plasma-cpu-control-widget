import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import "components" as Components

Column {
    id: root

    property int temperature: 0
    property int currentPerf: 100
    signal perfChangeRequested(int newValue)

    width: 200
    spacing: 12

    Item { width: 1; height: 4 }

    Components.TemperatureDisplay {
        temperature: root.temperature
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        width: parent.width - 32
        height: 1
        color: PlasmaCore.Theme.textColor
        opacity: 0.1
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Components.PerfLimiter {
        currentPerf: root.currentPerf
        anchors.horizontalCenter: parent.horizontalCenter
        onPerfChangeRequested: root.perfChangeRequested(newValue)
    }

    Item { width: 1; height: 4 }
}
