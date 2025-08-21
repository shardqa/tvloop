#!/bin/bash

# YouTube yt-dlp Core Functions
# Core functions for yt-dlp integration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Check if yt-dlp is available
check_ytdlp() {
    if ! command -v yt-dlp >/dev/null 2>&1; then
        log "ERROR: yt-dlp not found. Please install yt-dlp:"
        echo "  pip install yt-dlp"
        echo "  or: sudo apt install yt-dlp"
        return 1
    fi
    return 0
}

# Get video information using yt-dlp
get_video_info_ytdlp() {
    local video_url="$1"
    
    if ! check_ytdlp; then
        return 1
    fi
    
    # Get video information in JSON format
    local info=$(yt-dlp --cookies-from-browser firefox --dump-json --no-playlist "$video_url" 2>/dev/null)
    
    if [[ $? -eq 0 && -n "$info" ]]; then
        local title=$(echo "$info" | jq -r '.title // "unknown"')
        local duration=$(echo "$info" | jq -r '.duration // "0"')
        local video_id=$(echo "$info" | jq -r '.id // "unknown"')
        
        # Clean up title to avoid special characters in shell operations
        title=$(echo "$title" | tr -d '"' | tr -d "'" | sed 's/[^a-zA-Z0-9 \-_().]/ /g')
        
        if [[ -n "$title" && -n "$duration" && -n "$video_id" && "$duration" =~ ^[0-9]+$ ]]; then
            echo "$video_id|$title|$duration"
            return 0
        fi
    fi
    
    return 1
}

# Get single video information for playlist entry
get_single_video_ytdlp() {
    local video_url="$1"
    
    local video_info=$(get_video_info_ytdlp "$video_url")
    if [[ $? -eq 0 ]]; then
        local video_id=$(echo "$video_info" | cut -d'|' -f1)
        local title=$(echo "$video_info" | cut -d'|' -f2)
        local duration=$(echo "$video_info" | cut -d'|' -f3)
        
        echo "youtube://$video_id|$title|$duration"
        return 0
    fi
    
    return 1
}
