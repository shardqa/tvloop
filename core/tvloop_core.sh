#!/bin/bash

# tvloop core functionality
# Main module that sources all tvloop components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source all tvloop modules
source "$PROJECT_ROOT/core/tvloop_channels.sh"
source "$PROJECT_ROOT/core/tvloop_commands.sh"
