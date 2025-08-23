#!/bin/bash

# YouTube Playlist Validation Module (Refactored)
# Main coordinator for playlist validation operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load modules
source "$PROJECT_ROOT/core/youtube_playlist_basic_validation.sh"
source "$PROJECT_ROOT/core/youtube_playlist_format_validation.sh"
source "$PROJECT_ROOT/core/youtube_playlist_integrity.sh"
source "$PROJECT_ROOT/core/youtube_playlist_repair.sh"

# Main functions - these are now just wrappers that delegate to modules
# This maintains backward compatibility while using the new modular structure

# Note: The actual implementations are now in the individual modules
# This file serves as a compatibility layer and main coordinator
