#!/bin/bash

# YouTube Playlist Help for tvloop
# Provides help and usage information for YouTube playlist operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Show usage information
show_usage() {
    echo "YouTube Playlist Manager for tvloop"
    echo ""
    echo "Usage: $0 [channel_dir] [command] [options]"
    echo ""
    echo "Commands:"
    echo "  create <youtube_url>     - Create playlist from YouTube URL"
    echo "  add <youtube_url>        - Add single video to existing playlist"
    echo "  list                     - List existing playlists"
    echo "  info <playlist_file>     - Show playlist information"
    echo "  help                     - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 channels/youtube_channel create 'https://www.youtube.com/playlist?list=PLxxxxxxxx'"
    echo "  $0 channels/youtube_channel add 'https://www.youtube.com/watch?v=xxxxxxxx'"
    echo "  $0 channels/youtube_channel list"
    echo ""
    echo "Environment Variables:"
    echo "  YOUTUBE_API_KEY          - YouTube Data API v3 key (required)"
}
