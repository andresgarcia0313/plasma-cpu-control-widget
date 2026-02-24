#!/bin/bash
# Run all tests for CPU Control Widget
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
FAILED=0

echo "=== CPU Control Widget Tests ==="
echo ""

for test in "$DIR"/test_*.js; do
    echo "Running $(basename "$test")..."
    if node "$test"; then
        echo ""
    else
        FAILED=1
        echo ""
    fi
done

if [ $FAILED -eq 0 ]; then
    echo "=== ALL TESTS PASSED ==="
else
    echo "=== SOME TESTS FAILED ==="
    exit 1
fi
