#!/bin/bash

# YouTube Channel Videos Module
# Handles video fetching from channels

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/youtube_channel_info.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Get videos from a channel's uploads playlist
get_channel_videos() {
    local channel_id="$1"
    local max_results="${2:-50}"
    local page_token="${3:-}"
    
    # First get the uploads playlist ID
    local channel_info=$(get_channel_info "$channel_id")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    local uploads_playlist=$(echo "$channel_info" | cut -d'|' -f3)
    
    # Build parameters for playlist items request
    local params="part=snippet&playlistId=$uploads_playlist&maxResults=$max_results"
    if [[ -n "$page_token" ]]; then
        params="$params&pageToken=$page_token"
    fi
    
    local response=$(youtube_api_request "playlistItems" "$params")
    
    if [[ $? -eq 0 ]]; then
        echo "$response"
        return 0
    fi
    
    log "ERROR: Could not get videos from channel: $channel_id"
    return 1
}

# Get all videos from a channel (with pagination)
get_all_channel_videos() {
    local channel_id="$1"
    local max_total="${2:-100}"
    
    local all_videos=""
    local page_token=""
    local total_count=0
    
    while [[ $total_count -lt $max_total ]]; do
        local max_results=$((max_total - total_count))
        if [[ $max_results -gt 50 ]]; then
            max_results=50
        fi
        
        local response=$(get_channel_videos "$channel_id" "$max_results" "$page_token")
        if [[ $? -ne 0 ]]; then
            break
        fi
        
        local videos=$(echo "$response" | jq -r '.items[] | "\(.snippet.resourceId.videoId)|\(.snippet.title)"')
        local next_page_token=$(echo "$response" | jq -r '.nextPageToken // empty')
        
        if [[ -n "$videos" ]]; then
            all_videos="$all_videos"$'\n'"$videos"
            total_count=$(echo "$all_videos" | wc -l)
        fi
        
        if [[ -z "$next_page_token" ]]; then
            break
        fi
        
        page_token="$next_page_token"
    done
    
    echo "$all_videos"
}

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

