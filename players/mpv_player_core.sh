#!/bin/bash

# MPV Player Core Module
# Main module that sources launch functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source the launch module
source "$(dirname "${BASH_SOURCE[0]}")/mpv_player_core_launch.sh"
