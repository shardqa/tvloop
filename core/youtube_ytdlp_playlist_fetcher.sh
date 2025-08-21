#!/bin/bash

# YouTube yt-dlp Playlist Fetcher
# Functions for fetching playlist videos

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_core.sh"

# Get playlist videos using yt-dlp
get_playlist_videos_ytdlp() {
    local playlist_url="$1"
    local max_videos="${2:-50}"
    
    if ! check_ytdlp; then
        return 1
    fi
    
    # Get playlist information - each line is a JSON object
    local video_urls=""
    local count=0
    
    while IFS= read -r line; do
        if [[ -n "$line" && $count -lt $max_videos ]]; then
            local url=$(echo "$line" | jq -r '.url // empty')
            if [[ -n "$url" ]]; then
                video_urls="$video_urls"$'\n'"$url"
                count=$((count + 1))
            fi
        fi
    done < <(yt-dlp --cookies-from-browser firefox --flat-playlist --dump-json --playlist-end "$max_videos" "$playlist_url" 2>/dev/null)
    
    if [[ -n "$video_urls" ]]; then
        echo "$video_urls"
        return 0
    fi
    
    return 1
}
