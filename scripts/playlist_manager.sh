#!/bin/bash

PLAYLIST_FILE="${1:-channels/channel_1/playlist.txt}"
VIDEOS_DIR="${2:-/home/richard/Videos}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/playlist_utils.sh"
source "$PROJECT_ROOT/core/playlist_creator.sh"

case "${3:-info}" in
    "validate")
        validate_playlist "$PLAYLIST_FILE"
        ;;
    "create")
        create_playlist_from_directory "$VIDEOS_DIR" "$PLAYLIST_FILE" "${4:-mp4,mkv,avi}"
        ;;
    "info")
        show_playlist_info "$PLAYLIST_FILE"
        ;;
    *)
        echo "Usage: $0 [playlist_file] [videos_dir] [command] [extensions]"
        echo "Commands:"
        echo "  validate  - Validate playlist and check video files"
        echo "  create    - Create playlist from directory"
        echo "  info      - Show playlist information (default)"
        echo ""
        echo "Examples:"
        echo "  $0 channels/channel_1/playlist.txt validate"
        echo "  $0 channels/channel_1/playlist.txt /home/richard/Videos create"
        echo "  $0 channels/channel_1/playlist.txt /home/richard/Videos create mp4,mkv"
        ;;
esac
