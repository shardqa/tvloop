#!/bin/bash

# YouTube Playlist Common Module (Refactored)
# Main coordinator for playlist common operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load modules
source "$PROJECT_ROOT/core/youtube_playlist_file_ops.sh"
source "$PROJECT_ROOT/core/youtube_playlist_display.sh"
source "$PROJECT_ROOT/core/youtube_playlist_merge_split.sh"
source "$PROJECT_ROOT/core/youtube_playlist_backup_cleanup.sh"

# Main functions - these are now just wrappers that delegate to modules
# This maintains backward compatibility while using the new modular structure

# Note: The actual implementations are now in the individual modules
# This file serves as a compatibility layer and main coordinator
