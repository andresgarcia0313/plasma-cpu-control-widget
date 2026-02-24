import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
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

    Plasmoid.compactRepresentation: CompactView {
        temperature: root.temperature
        onClicked: plasmoid.expanded = !plasmoid.expanded
    }

    Plasmoid.fullRepresentation: FullView {
        temperature: root.temperature
        currentPerf: root.currentPerf
        onPerfChangeRequested: root.setPerf(newValue)
    }
}
