#!/bin/bash

# YouTube Playlist Format Validation Module
# Main module that sources all validation components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source all validation modules
source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_playlist_format_validation_core.sh"
source "$PROJECT_ROOT/core/youtube_playlist_format_validation_duplicates.sh"
source "$PROJECT_ROOT/core/youtube_playlist_format_validation_line.sh"

