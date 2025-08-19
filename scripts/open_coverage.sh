#!/bin/bash

COVERAGE_HTML="coverage/index.html"

if [[ ! -f "$COVERAGE_HTML" ]]; then
    echo "No coverage report found. Run 'make test-coverage' first."
    exit 1
fi

echo "Opening coverage report: $COVERAGE_HTML"

if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$COVERAGE_HTML"
elif command -v open >/dev/null 2>&1; then
    open "$COVERAGE_HTML"
elif command -v firefox >/dev/null 2>&1; then
    firefox "$COVERAGE_HTML"
elif command -v google-chrome >/dev/null 2>&1; then
    google-chrome "$COVERAGE_HTML"
else
    echo "Could not open browser automatically."
    echo "Please open this file manually: $COVERAGE_HTML"
fi
