// Tests for CpuReader.js logic
// Run with: node test_CpuReader.js

// Load the module (strip .pragma library for Node.js)
const fs = require("fs")
let src = fs.readFileSync(__dirname + "/../contents/ui/logic/CpuReader.js", "utf8")
src = src.replace(".pragma library", "")
src += "\nmodule.exports = { parseOutput, tempColor, tempLabel, clampPerf, buildReadCommand };"
const tmpFile = "/tmp/test_CpuReader_tmp.js"
fs.writeFileSync(tmpFile, src)
const Reader = require(tmpFile)

let passed = 0
let failed = 0

function assert(condition, message) {
    if (condition) {
        passed++
        console.log("  PASS: " + message)
    } else {
        failed++
        console.error("  FAIL: " + message)
    }
}

function assertEqual(actual, expected, message) {
    assert(actual === expected, message + " (got " + actual + ", expected " + expected + ")")
}

// --- parseOutput tests ---
console.log("\n=== parseOutput ===")

var r1 = Reader.parseOutput("94000:85")
assertEqual(r1.tempC, 94, "Normal: temp 94000 → 94°C")
assertEqual(r1.perf, 85, "Normal: perf 85%")
assertEqual(r1.valid, true, "Normal: valid=true")

var r2 = Reader.parseOutput("45500:100")
assertEqual(r2.tempC, 46, "Rounding: 45500 → 46°C")
assertEqual(r2.perf, 100, "Full perf: 100%")

var r3 = Reader.parseOutput("")
assertEqual(r3.valid, false, "Empty string: valid=false")
assertEqual(r3.perf, 100, "Empty string: default perf=100")

var r4 = Reader.parseOutput("garbage")
assertEqual(r4.valid, false, "Garbage: valid=false")

var r5 = Reader.parseOutput("0:50")
assertEqual(r5.valid, false, "Zero temp: valid=false")

var r6 = Reader.parseOutput("72000:5")
assertEqual(r6.perf, 10, "Perf below min clamped to 10")

var r7 = Reader.parseOutput("72000:150")
assertEqual(r7.perf, 100, "Perf above max clamped to 100")

// --- tempColor tests ---
console.log("\n=== tempColor ===")

assertEqual(Reader.tempColor(30), "#34c759", "30°C → green")
assertEqual(Reader.tempColor(49), "#34c759", "49°C → green")
assertEqual(Reader.tempColor(50), "#ffcc00", "50°C → yellow")
assertEqual(Reader.tempColor(64), "#ffcc00", "64°C → yellow")
assertEqual(Reader.tempColor(65), "#ff9500", "65°C → orange")
assertEqual(Reader.tempColor(79), "#ff9500", "79°C → orange")
assertEqual(Reader.tempColor(80), "#ff3b30", "80°C → red")
assertEqual(Reader.tempColor(95), "#ff3b30", "95°C → red")

// --- tempLabel tests ---
console.log("\n=== tempLabel ===")

assertEqual(Reader.tempLabel(30), "Cool", "30°C → Cool")
assertEqual(Reader.tempLabel(55), "Normal", "55°C → Normal")
assertEqual(Reader.tempLabel(70), "Warm", "70°C → Warm")
assertEqual(Reader.tempLabel(85), "Hot", "85°C → Hot")

// --- clampPerf tests ---
console.log("\n=== clampPerf ===")

assertEqual(Reader.clampPerf(50), 50, "50 → 50 (no change)")
assertEqual(Reader.clampPerf(0), 10, "0 → 10 (clamped min)")
assertEqual(Reader.clampPerf(5), 10, "5 → 10 (clamped min)")
assertEqual(Reader.clampPerf(200), 100, "200 → 100 (clamped max)")
assertEqual(Reader.clampPerf(10), 10, "10 → 10 (exact min)")
assertEqual(Reader.clampPerf(100), 100, "100 → 100 (exact max)")

// --- buildReadCommand tests ---
console.log("\n=== buildReadCommand ===")

var cmd = Reader.buildReadCommand()
assert(cmd.indexOf("thermal_zone") > -1, "Command contains thermal_zone")
assert(cmd.indexOf("x86_pkg_temp") > -1, "Command searches for x86_pkg_temp")
assert(cmd.indexOf("TCPU") > -1, "Command searches for TCPU")
assert(cmd.indexOf("max_perf_pct") > -1, "Command reads max_perf_pct")

// --- Summary ---
console.log("\n=== Results: " + passed + " passed, " + failed + " failed ===")
fs.unlinkSync(tmpFile)
process.exit(failed > 0 ? 1 : 0)
