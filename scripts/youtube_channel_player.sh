#!/bin/bash

# YouTube Channel Player for tvloop
# Main script for playing YouTube videos using the existing channel system

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source the split modules
source "$PROJECT_ROOT/scripts/youtube_channel_help.sh"
source "$PROJECT_ROOT/scripts/youtube_channel_operations.sh"

# Default channel directory
CHANNEL_DIR="${1:-channels/youtube_channel}"

# Ensure channel directory exists
if [[ ! -d "$CHANNEL_DIR" ]]; then
    log "Creating channel directory: $CHANNEL_DIR"
    mkdir -p "$CHANNEL_DIR"
fi

# Main command processing
case "${2:-help}" in
    "play")
        play_youtube_channel "$CHANNEL_DIR" "$3"
        ;;
    "stop")
        stop_youtube_channel "$CHANNEL_DIR"
        ;;
    "status")
        show_youtube_channel_status "$CHANNEL_DIR"
        ;;
    "init")
        initialize_youtube_channel "$CHANNEL_DIR"
        ;;
    "help"|*)
        show_usage
        ;;
esac
