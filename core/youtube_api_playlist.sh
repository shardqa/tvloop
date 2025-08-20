#!/bin/bash

# YouTube API Playlist Functions for tvloop
# Handles playlist-related operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/youtube_api_parsing.sh"
source "$PROJECT_ROOT/core/youtube_api_video.sh"

# Get playlist items
get_playlist_items() {
    local playlist_id="$1"
    local max_results="${2:-50}"
    
    if [[ -z "$playlist_id" ]]; then
        log "ERROR: Playlist ID is required"
        return 1
    fi
    
    local response=$(youtube_api_request "playlistItems" "part=snippet,contentDetails&playlistId=$playlist_id&maxResults=$max_results")
    
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    # Extract video IDs from playlist
    local video_ids=$(echo "$response" | jq -r '.items[].contentDetails.videoId // empty')
    
    if [[ -z "$video_ids" ]]; then
        log "ERROR: No videos found in playlist or access denied"
        return 1
    fi
    
    echo "$video_ids"
}

# Create playlist from YouTube playlist
create_youtube_playlist() {
    local playlist_url="$1"
    local output_file="$2"
    
    if [[ -z "$playlist_url" || -z "$output_file" ]]; then
        log "ERROR: Playlist URL and output file are required"
        return 1
    fi
    
    local playlist_id=$(extract_playlist_id "$playlist_url")
    
    if [[ -z "$playlist_id" ]]; then
        log "ERROR: Could not extract playlist ID from URL: $playlist_url"
        return 1
    fi
    
    log "Creating playlist from YouTube playlist: $playlist_id"
    
    # Get playlist items
    local video_ids=$(get_playlist_items "$playlist_id")
    
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    # Create playlist file
    > "$output_file"
    
    # Get details for each video
    local count=0
    while IFS= read -r video_id; do
        if [[ -n "$video_id" ]]; then
            local video_details=$(get_video_details "$video_id")
            
            if [[ $? -eq 0 ]]; then
                IFS='|' read -r title duration <<< "$video_details"
                echo "youtube://$video_id|$title|$duration" >> "$output_file"
                count=$((count + 1))
                log "Added video: $title ($duration seconds)"
            else
                log "WARNING: Failed to get details for video: $video_id"
            fi
        fi
    done <<< "$video_ids"
    
    log "Created playlist with $count videos: $output_file"
    echo "$count"
}
