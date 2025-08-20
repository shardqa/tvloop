#!/bin/bash

# YouTube Playlist Manager for tvloop
# Main script for creating and managing playlists from YouTube URLs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source the split modules
source "$PROJECT_ROOT/scripts/youtube_playlist_help.sh"
source "$PROJECT_ROOT/scripts/youtube_playlist_creator.sh"
source "$PROJECT_ROOT/scripts/youtube_playlist_operations.sh"

# Default channel directory
CHANNEL_DIR="${1:-channels/channel_1}"

# Ensure channel directory exists
if [[ ! -d "$CHANNEL_DIR" ]]; then
    log "Creating channel directory: $CHANNEL_DIR"
    mkdir -p "$CHANNEL_DIR"
fi

# Main command processing
case "${2:-help}" in
    "create")
        create_playlist "$CHANNEL_DIR" "$3"
        ;;
    "add")
        add_video "$CHANNEL_DIR" "$3"
        ;;
    "list")
        list_playlists "$CHANNEL_DIR"
        ;;
    "info")
        show_playlist_info "$CHANNEL_DIR" "$3"
        ;;
    "help"|*)
        show_usage
        ;;
esac
