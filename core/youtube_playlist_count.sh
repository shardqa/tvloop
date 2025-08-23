#!/bin/bash

# YouTube Playlist Count Module (Refactored)
# Main coordinator for video-count-based playlist operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load modules
source "$PROJECT_ROOT/core/youtube_playlist_count_creation.sh"
source "$PROJECT_ROOT/core/youtube_playlist_count_analysis.sh"
source "$PROJECT_ROOT/core/youtube_playlist_count_stats.sh"

# Main functions - these are now just wrappers that delegate to modules
# This maintains backward compatibility while using the new modular structure

# Note: The actual implementations are now in the individual modules
# This file serves as a compatibility layer and main coordinator
