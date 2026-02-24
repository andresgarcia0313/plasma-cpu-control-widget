import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import "logic/CpuReader.js" as Reader
import "logic/CpuWriter.js" as Writer

Item {
    id: root

    property int temperature: 0
    property int currentPerf: 100

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statusSource.connectSource(Reader.buildReadCommand())
    }

    PlasmaCore.DataSource {
        id: statusSource
        engine: "executable"
        onNewData: {
            var result = Reader.parseOutput(data["stdout"])
            if (result.valid) {
                root.temperature = result.tempC
                root.currentPerf = result.perf
            }
            disconnectSource(sourceName)
        }
    }

    PlasmaCore.DataSource {
        id: writeSource
        engine: "executable"
        onNewData: {
            disconnectSource(sourceName)
            statusSource.connectSource(Reader.buildReadCommand())
        }
    }

    function setPerf(value) {
        var cmd = Writer.buildSetCommand(value)
        if (cmd) writeSource.connectSource(cmd)
    }

    Plasmoid.compactRepresentation: MouseArea {
        implicitWidth: compactRow.implicitWidth
        implicitHeight: compactRow.implicitHeight
        onClicked: plasmoid.expanded = !plasmoid.expanded

        Row {
            id: compactRow
            spacing: 4
            anchors.centerIn: parent

            PlasmaCore.IconItem {
                source: "cpu"
                width: units.iconSizes.small
                height: units.iconSizes.small
                anchors.verticalCenter: parent.verticalCenter
            }

            PlasmaComponents.Label {
                text: root.temperature + "°C"
                color: Reader.tempColor(root.temperature)
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Plasmoid.fullRepresentation: FullView {
        temperature: root.temperature
        currentPerf: root.currentPerf
        onPerfChangeRequested: root.setPerf(newValue)
    }
}
