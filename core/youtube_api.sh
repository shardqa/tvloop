#!/bin/bash

# YouTube Data API v3 integration for tvloop
# Main module that sources all YouTube API functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source all YouTube API modules
source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/youtube_api_parsing.sh"
source "$PROJECT_ROOT/core/youtube_api_video.sh"
source "$PROJECT_ROOT/core/youtube_api_playlist.sh"
