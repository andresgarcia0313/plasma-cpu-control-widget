.pragma library

var MIN_PERF = 10
var MAX_PERF = 100
var STEP = 5

// Validates that a performance value is within allowed range
function isValidPerf(value) {
    var n = parseInt(value)
    return !isNaN(n) && n >= MIN_PERF && n <= MAX_PERF
}

// Builds the pkexec command to set max_perf_pct
// Returns null if value is invalid
function buildSetCommand(value) {
    var n = parseInt(value)
    if (!isValidPerf(n)) return null
    return "pkexec /usr/local/bin/cpu-perf-set " + n
}

// Calculates the new value after increasing by STEP
function increase(current) {
    var next = parseInt(current) + STEP
    return Math.min(next, MAX_PERF)
}

// Calculates the new value after decreasing by STEP
function decrease(current) {
    var next = parseInt(current) - STEP
    return Math.max(next, MIN_PERF)
}

// Returns true if the value can be increased
function canIncrease(current) {
    return parseInt(current) < MAX_PERF
}

// Returns true if the value can be decreased
function canDecrease(current) {
    return parseInt(current) > MIN_PERF
}
