#!/bin/bash

# tvloop command functionality
# Main module that sources all command components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/channel_state.sh"
source "$PROJECT_ROOT/core/playlist_parser.sh"
source "$PROJECT_ROOT/core/time_utils.sh"
source "$PROJECT_ROOT/core/tvloop_channels.sh"

# Source command modules
source "$PROJECT_ROOT/core/tvloop_commands_tune.sh"
source "$PROJECT_ROOT/core/tvloop_commands_create.sh"
source "$PROJECT_ROOT/core/tvloop_commands_remove.sh"
