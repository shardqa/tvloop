#!/bin/bash

# YouTube Playlist Repair Module (Refactored)
# Main coordinator for playlist repair operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load modules
source "$PROJECT_ROOT/core/youtube_playlist_repair_core.sh"
source "$PROJECT_ROOT/core/youtube_playlist_repair_cleanup.sh"
source "$PROJECT_ROOT/core/youtube_playlist_repair_backup.sh"

# Main functions - these are now just wrappers that delegate to modules
# This maintains backward compatibility while using the new modular structure

# Note: The actual implementations are now in the individual modules
# This file serves as a compatibility layer and main coordinator
