#!/bin/bash

# Format Selection Module for tvloop
# Main module that sources all format selection components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/logging.sh"

# Source format selection modules
source "$PROJECT_ROOT/core/format_selection_core.sh"
source "$PROJECT_ROOT/core/format_selection_auto.sh"
source "$PROJECT_ROOT/core/format_selection_debug.sh"
