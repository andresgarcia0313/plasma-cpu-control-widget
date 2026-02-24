.pragma library

// Builds a shell command that finds the real CPU thermal zone dynamically
// and reads temp + intel_pstate values in a single call
function buildReadCommand() {
    return "bash -c '"
        + "TEMP=0; "
        + "for z in /sys/class/thermal/thermal_zone*/type; do "
        + "  t=$(cat \"$z\" 2>/dev/null); "
        + "  if [ \"$t\" = \"x86_pkg_temp\" ] || [ \"$t\" = \"TCPU\" ]; then "
        + "    TEMP=$(cat \"${z%type}temp\" 2>/dev/null); break; "
        + "  fi; "
        + "done; "
        + "[ \"$TEMP\" -eq 0 ] 2>/dev/null && TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null); "
        + "PERF=$(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct 2>/dev/null); "
        + "echo \"${TEMP}:${PERF}\"'"
}

// Parses the output of the read command into a structured object
// Input: "94000:85" → { tempRaw: 94000, tempC: 94, perf: 85, valid: true }
function parseOutput(stdout) {
    var parts = (stdout || "").trim().split(":")
    if (parts.length < 2) return { tempC: 0, perf: 100, valid: false }

    var tempRaw = parseInt(parts[0]) || 0
    var perf = parseInt(parts[1]) || 100

    return {
        tempRaw: tempRaw,
        tempC: Math.round(tempRaw / 1000),
        perf: clampPerf(perf),
        valid: tempRaw > 0
    }
}

// Returns a color hex based on temperature thresholds
function tempColor(tempC) {
    if (tempC < 50) return "#34c759"       // green - cool
    if (tempC < 65) return "#ffcc00"       // yellow - warm
    if (tempC < 80) return "#ff9500"       // orange - hot
    return "#ff3b30"                        // red - critical
}

// Returns a human label for the temperature range
function tempLabel(tempC) {
    if (tempC < 50) return "Cool"
    if (tempC < 65) return "Normal"
    if (tempC < 80) return "Warm"
    return "Hot"
}

// Clamps performance value to valid range
function clampPerf(value) {
    return Math.max(10, Math.min(100, value))
}
