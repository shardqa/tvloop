#!/bin/bash

# MPV Player Module
# Main module that sources all mpv player components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/tvloop_channels.sh"
source "$PROJECT_ROOT/core/format_selection.sh"

# Source mpv player modules
source "$PROJECT_ROOT/players/mpv_player_core.sh"
