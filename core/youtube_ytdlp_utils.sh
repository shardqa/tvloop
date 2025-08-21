#!/bin/bash

# YouTube yt-dlp Utility Functions
# Utility functions for yt-dlp integration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Get channel uploads playlist URL from channel URL
get_channel_uploads_url() {
    local channel_url="$1"
    
    # Handle different channel URL formats
    if [[ "$channel_url" =~ /channel/([a-zA-Z0-9_-]+) ]]; then
        local channel_id="${BASH_REMATCH[1]}"
        echo "https://www.youtube.com/channel/$channel_id/videos"
    elif [[ "$channel_url" =~ /@([a-zA-Z0-9_-]+) ]]; then
        local username="${BASH_REMATCH[1]}"
        echo "https://www.youtube.com/@$username/videos"
    elif [[ "$channel_url" =~ ^@([a-zA-Z0-9_-]+)$ ]]; then
        local username="${BASH_REMATCH[1]}"
        echo "https://www.youtube.com/@$username/videos"
    else
        # Assume it's already a videos URL or try to convert
        echo "$channel_url"
    fi
}
