#!/bin/bash

# YouTube Channel Creator for tvloop (yt-dlp version)
# Main module that sources YouTube channel creation functionality

CHANNEL_NAME="${1:-youtube_channel}"
YOUTUBE_CHANNEL="${2:-}"
TARGET_HOURS="${3:-24}"
AUTO_START="${4:-false}"
QUALITY="${5:-232,609}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_playlist.sh"
source "$PROJECT_ROOT/scripts/youtube_channel_usage.sh"

# Source modules
source "$(dirname "${BASH_SOURCE[0]}")/create_youtube_channel_ytdlp_core.sh"

show_usage() {
    show_youtube_channel_usage
}

# Main execution
if [[ $# -lt 2 ]]; then
    show_usage
    exit 1
fi

create_youtube_channel_ytdlp "$CHANNEL_NAME" "$YOUTUBE_CHANNEL" "$TARGET_HOURS" "$AUTO_START"
