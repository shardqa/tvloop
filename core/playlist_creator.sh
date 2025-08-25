#!/bin/bash

# Playlist Creator Module
# Main module that sources playlist creation functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/time_utils.sh"
source "$SCRIPT_DIR/logging.sh"
source "$SCRIPT_DIR/playlist_utils.sh"

# Source modules
source "$(dirname "${BASH_SOURCE[0]}")/playlist_creator_core.sh"
source "$(dirname "${BASH_SOURCE[0]}")/playlist_creator_info.sh"
