#!/bin/bash

# YouTube Playlist Creator Module (Refactored)
# Main coordinator for playlist creation operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load modules
source "$PROJECT_ROOT/core/youtube_playlist_duration.sh"
source "$PROJECT_ROOT/core/youtube_playlist_count.sh"
source "$PROJECT_ROOT/core/youtube_playlist_validation.sh"
source "$PROJECT_ROOT/core/youtube_playlist_common.sh"

# Main functions - these are now just wrappers that delegate to modules
# This maintains backward compatibility while using the new modular structure

# Note: The actual implementations are now in the individual modules
# This file serves as a compatibility layer and main coordinator
