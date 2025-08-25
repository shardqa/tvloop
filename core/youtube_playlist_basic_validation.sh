#!/bin/bash

# YouTube Playlist Basic Validation Module
# Main module that sources playlist validation functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Source modules
source "$(dirname "${BASH_SOURCE[0]}")/youtube_playlist_basic_validation_core.sh"
source "$(dirname "${BASH_SOURCE[0]}")/youtube_playlist_basic_validation_utils.sh"
