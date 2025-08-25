#!/bin/bash

# YouTube Channel Videos Utils Module
# Video utilities and helper functions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/youtube_channel_info.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Get recent videos from a channel
get_recent_channel_videos() {
    local channel_id="$1"
    local count="${2:-10}"
    
    local response=$(get_channel_videos "$channel_id" "$count")
    if [[ $? -eq 0 ]]; then
        local videos=$(echo "$response" | jq -r '.items[] | "\(.snippet.resourceId.videoId)|\(.snippet.title)|\(.snippet.publishedAt)"')
        echo "$videos"
        return 0
    fi
    
    log "ERROR: Could not get recent videos from channel: $channel_id"
    return 1
}

# Get video count for a channel
get_channel_video_count() {
    local channel_id="$1"
    
    local channel_info=$(get_detailed_channel_info "$channel_id")
    if [[ $? -eq 0 ]]; then
        local video_count=$(echo "$channel_info" | cut -d'|' -f5)
        echo "$video_count"
        return 0
    fi
    
    log "ERROR: Could not get video count for channel: $channel_id"
    return 1
}

# Check if channel has videos
has_channel_videos() {
    local channel_id="$1"
    
    local video_count=$(get_channel_video_count "$channel_id")
    if [[ $? -eq 0 && "$video_count" -gt 0 ]]; then
        return 0
    else
        return 1
    fi
}

# Get videos with duration information
get_channel_videos_with_duration() {
    local channel_id="$1"
    local max_results="${2:-50}"
    
    # Get basic video list
    local videos=$(get_all_channel_videos "$channel_id" "$max_results")
    if [[ $? -ne 0 ]]; then
        log "ERROR: Could not get videos with duration for channel: $channel_id"
        return 1
    fi
    
    # For each video, get duration (this would require additional API calls)
    # For now, return the basic video list
    echo "$videos"
    return 0
}

# Format video list for display
format_video_list() {
    local videos="$1"
    local max_display="${2:-10}"
    
    local count=0
    while IFS='|' read -r video_id title; do
        if [[ -z "$video_id" || -z "$title" ]]; then
            continue
        fi
        
        count=$((count + 1))
        if [[ $count -gt $max_display ]]; then
            echo "... and $(( $(echo "$videos" | wc -l) - max_display )) more videos"
            break
        fi
        
        echo "$count. $title (ID: $video_id)"
    done <<< "$videos"
}
