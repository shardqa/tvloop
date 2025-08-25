#!/bin/bash

# YouTube Playlist Format Validation Core Module
# Main module that sources validation functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Source validation modules
source "$(dirname "${BASH_SOURCE[0]}")/youtube_playlist_format_validation_analysis.sh"
source "$(dirname "${BASH_SOURCE[0]}")/youtube_playlist_format_validation_ids.sh"
