import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: root

    property string currentTemp: "..."
    property string currentProfile: "..."
    property string maxPerf: "..."
    property string turboState: "..."

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: readStatus.connectSource(readStatus.cmd)
    }

    PlasmaCore.DataSource {
        id: readStatus
        engine: "executable"
        property string cmd: "echo $(cat /sys/class/thermal/thermal_zone0/temp):$(powerprofilesctl get):$(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct):$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)"

        onNewData: {
            var out = data["stdout"].trim()
            var p = out.split(":")
            if (p.length >= 4) {
                root.currentTemp = Math.round(parseInt(p[0]) / 1000) + "°C"
                root.currentProfile = p[1]
                root.maxPerf = p[2] + "%"
                root.turboState = p[3] === "0" ? "ON" : "OFF"
            }
            disconnectSource(sourceName)
        }
    }

    PlasmaCore.DataSource {
        id: runCmd
        engine: "executable"
        onNewData: {
            disconnectSource(sourceName)
            readStatus.connectSource(readStatus.cmd)
        }
    }

    function setProfile(profile) {
        runCmd.connectSource("powerprofilesctl set " + profile)
    }

    Plasmoid.compactRepresentation: Row {
        spacing: 4

        PlasmaCore.IconItem {
            source: "cpu"
            width: 16
            height: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        PlasmaComponents.Label {
            text: root.currentTemp
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: plasmoid.expanded = !plasmoid.expanded
        }
    }

    Plasmoid.fullRepresentation: Column {
        width: 220
        spacing: 8

        PlasmaComponents.Label {
            text: "CPU Control"
            font.bold: true
            font.pointSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Grid {
            columns: 2
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter

            PlasmaComponents.Label { text: "Temp:"; opacity: 0.7 }
            PlasmaComponents.Label {
                text: root.currentTemp
                font.bold: true
                color: parseInt(root.currentTemp) < 60 ? "#27ae60" : parseInt(root.currentTemp) < 75 ? "#f39c12" : "#e74c3c"
            }

            PlasmaComponents.Label { text: "Perf:"; opacity: 0.7 }
            PlasmaComponents.Label { text: root.maxPerf; font.bold: true }

            PlasmaComponents.Label { text: "Turbo:"; opacity: 0.7 }
            PlasmaComponents.Label {
                text: root.turboState
                font.bold: true
                color: root.turboState === "ON" ? "#27ae60" : "#e74c3c"
            }

            PlasmaComponents.Label { text: "Profile:"; opacity: 0.7 }
            PlasmaComponents.Label {
                text: root.currentProfile
                font.bold: true
                color: root.currentProfile === "performance" ? "#27ae60" : root.currentProfile === "power-saver" ? "#3498db" : "#f39c12"
            }
        }

        Rectangle {
            width: parent.width - 20
            height: 1
            color: PlasmaCore.Theme.textColor
            opacity: 0.2
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            PlasmaComponents.Button {
                text: "Performance"
                width: 180
                checked: root.currentProfile === "performance"
                onClicked: root.setProfile("performance")
            }

            PlasmaComponents.Button {
                text: "Balanced"
                width: 180
                checked: root.currentProfile === "balanced"
                onClicked: root.setProfile("balanced")
            }

            PlasmaComponents.Button {
                text: "Power Saver"
                width: 180
                checked: root.currentProfile === "power-saver"
                onClicked: root.setProfile("power-saver")
            }
        }
    }
}
