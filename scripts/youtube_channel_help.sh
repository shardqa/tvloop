#!/bin/bash

# YouTube Channel Help for tvloop
# Provides help and usage information for YouTube channel operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Show usage information
show_usage() {
    echo "YouTube Channel Player for tvloop"
    echo ""
    echo "Usage: $0 [channel_dir] [command] [options]"
    echo ""
    echo "Commands:"
    echo "  play [player_type]        - Start playing the channel"
    echo "  stop                      - Stop the channel"
    echo "  status                    - Show channel status"
    echo "  init                      - Initialize channel state"
    echo "  help                      - Show this help message"
    echo ""
    echo "Player Types:"
    echo "  mpv                       - Use mpv player (default)"
    echo ""
    echo "Examples:"
    echo "  $0 channels/youtube_channel play mpv"
    echo "  $0 channels/youtube_channel stop"
    echo "  $0 channels/youtube_channel status"
    echo ""
    echo "Prerequisites:"
    echo "  - YouTube playlist must be created first using youtube_playlist_manager.sh"
    echo "  - yt-dlp must be installed for YouTube playback"
    echo "  - mpv must be installed"
}
