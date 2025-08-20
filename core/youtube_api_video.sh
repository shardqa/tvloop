#!/bin/bash

# YouTube API Video Functions for tvloop
# Handles video-related operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/youtube_api_parsing.sh"

# Get video details
get_video_details() {
    local video_id="$1"
    
    if [[ -z "$video_id" ]]; then
        log "ERROR: Video ID is required"
        return 1
    fi
    
    local response=$(youtube_api_request "videos" "part=snippet,contentDetails&id=$video_id")
    
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    # Extract video information
    local title=$(echo "$response" | jq -r '.items[0].snippet.title // ""')
    local duration=$(echo "$response" | jq -r '.items[0].contentDetails.duration // ""')
    
    if [[ -z "$title" ]]; then
        log "ERROR: Video not found or access denied"
        return 1
    fi
    
    # Convert ISO 8601 duration to seconds
    local duration_seconds=$(convert_iso_duration_to_seconds "$duration")
    
    echo "$title|$duration_seconds"
}

# Get single video details and create playlist entry
get_single_video_playlist_entry() {
    local video_url="$1"
    
    if [[ -z "$video_url" ]]; then
        log "ERROR: Video URL is required"
        return 1
    fi
    
    local video_id=$(extract_video_id "$video_url")
    
    if [[ -z "$video_id" ]]; then
        log "ERROR: Could not extract video ID from URL: $video_url"
        return 1
    fi
    
    local video_details=$(get_video_details "$video_id")
    
    if [[ $? -eq 0 ]]; then
        IFS='|' read -r title duration <<< "$video_details"
        echo "youtube://$video_id|$title|$duration"
    else
        return 1
    fi
}
