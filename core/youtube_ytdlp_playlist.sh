#!/bin/bash

# YouTube yt-dlp Playlist Functions
# Main playlist module - imports all playlist functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Import all playlist modules
source "$PROJECT_ROOT/core/youtube_ytdlp_playlist_fetcher.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_playlist_creator.sh"
