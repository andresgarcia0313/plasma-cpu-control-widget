// Tests for CpuWriter.js logic
// Run with: node test_CpuWriter.js

const fs = require("fs")
let src = fs.readFileSync(__dirname + "/../contents/ui/logic/CpuWriter.js", "utf8")
src = src.replace(".pragma library", "")
src += "\nmodule.exports = { MIN_PERF, MAX_PERF, STEP, isValidPerf, buildSetCommand, increase, decrease, canIncrease, canDecrease };"
const tmpFile = "/tmp/test_CpuWriter_tmp.js"
fs.writeFileSync(tmpFile, src)
const Writer = require(tmpFile)

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

// --- Constants ---
console.log("\n=== Constants ===")

assertEqual(Writer.MIN_PERF, 10, "MIN_PERF = 10")
assertEqual(Writer.MAX_PERF, 100, "MAX_PERF = 100")
assertEqual(Writer.STEP, 5, "STEP = 5")

// --- isValidPerf tests ---
console.log("\n=== isValidPerf ===")

assertEqual(Writer.isValidPerf(50), true, "50 is valid")
assertEqual(Writer.isValidPerf(10), true, "10 (min) is valid")
assertEqual(Writer.isValidPerf(100), true, "100 (max) is valid")
assertEqual(Writer.isValidPerf(9), false, "9 is invalid (below min)")
assertEqual(Writer.isValidPerf(101), false, "101 is invalid (above max)")
assertEqual(Writer.isValidPerf(0), false, "0 is invalid")
assertEqual(Writer.isValidPerf(-5), false, "Negative is invalid")
assertEqual(Writer.isValidPerf("abc"), false, "String is invalid")
assertEqual(Writer.isValidPerf(null), false, "null is invalid")
assertEqual(Writer.isValidPerf(undefined), false, "undefined is invalid")

// --- buildSetCommand tests ---
console.log("\n=== buildSetCommand ===")

var cmd = Writer.buildSetCommand(85)
assert(cmd !== null, "Valid value returns command")
assert(cmd.indexOf("pkexec") > -1, "Command uses pkexec")
assert(cmd.indexOf("cpu-perf-set") > -1, "Command calls helper script")
assert(cmd.indexOf("85") > -1, "Command contains value 85")

assertEqual(Writer.buildSetCommand(5), null, "Below min returns null")
assertEqual(Writer.buildSetCommand(105), null, "Above max returns null")
assertEqual(Writer.buildSetCommand("abc"), null, "String returns null")

// --- increase/decrease tests ---
console.log("\n=== increase ===")

assertEqual(Writer.increase(50), 55, "50 + 5 = 55")
assertEqual(Writer.increase(95), 100, "95 + 5 = 100")
assertEqual(Writer.increase(100), 100, "100 capped at 100")
assertEqual(Writer.increase(98), 100, "98 + 5 = 100 (capped)")

console.log("\n=== decrease ===")

assertEqual(Writer.decrease(50), 45, "50 - 5 = 45")
assertEqual(Writer.decrease(15), 10, "15 - 5 = 10")
assertEqual(Writer.decrease(10), 10, "10 capped at 10")
assertEqual(Writer.decrease(12), 10, "12 - 5 = 10 (capped)")

// --- canIncrease/canDecrease tests ---
console.log("\n=== canIncrease ===")

assertEqual(Writer.canIncrease(50), true, "50 can increase")
assertEqual(Writer.canIncrease(99), true, "99 can increase")
assertEqual(Writer.canIncrease(100), false, "100 cannot increase")

console.log("\n=== canDecrease ===")

assertEqual(Writer.canDecrease(50), true, "50 can decrease")
assertEqual(Writer.canDecrease(11), true, "11 can decrease")
assertEqual(Writer.canDecrease(10), false, "10 cannot decrease")

// --- Summary ---
console.log("\n=== Results: " + passed + " passed, " + failed + " failed ===")
fs.unlinkSync(tmpFile)
process.exit(failed > 0 ? 1 : 0)
