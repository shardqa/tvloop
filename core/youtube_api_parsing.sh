#!/bin/bash

# YouTube API URL Parsing Functions for tvloop
# Handles URL parsing and ID extraction

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Extract video ID from YouTube URL
extract_video_id() {
    local url="$1"
    local video_id=""
    
    # Handle various YouTube URL formats
    if [[ "$url" =~ youtube\.com/watch\?v=([a-zA-Z0-9_-]+) ]]; then
        video_id="${BASH_REMATCH[1]}"
    elif [[ "$url" =~ youtu\.be/([a-zA-Z0-9_-]+) ]]; then
        video_id="${BASH_REMATCH[1]}"
    elif [[ "$url" =~ youtube\.com/embed/([a-zA-Z0-9_-]+) ]]; then
        video_id="${BASH_REMATCH[1]}"
    fi
    
    echo "$video_id"
}

# Extract playlist ID from YouTube URL
extract_playlist_id() {
    local url="$1"
    local playlist_id=""
    
    if [[ "$url" =~ youtube\.com/playlist\?list=([a-zA-Z0-9_-]+) ]]; then
        playlist_id="${BASH_REMATCH[1]}"
    elif [[ "$url" =~ youtube\.com/watch\?.*list=([a-zA-Z0-9_-]+) ]]; then
        playlist_id="${BASH_REMATCH[1]}"
    fi
    
    echo "$playlist_id"
}

# Convert ISO 8601 duration to seconds
convert_iso_duration_to_seconds() {
    local duration="$1"
    local seconds=0
    
    # Parse ISO 8601 duration format (PT1H2M3S)
    if [[ "$duration" =~ PT(.*) ]]; then
        local time_part="${BASH_REMATCH[1]}"
        
        # Extract hours
        if [[ "$time_part" =~ ([0-9]+)H ]]; then
            local hours="${BASH_REMATCH[1]}"
            seconds=$((seconds + hours * 3600))
        fi
        
        # Extract minutes
        if [[ "$time_part" =~ ([0-9]+)M ]]; then
            local minutes="${BASH_REMATCH[1]}"
            seconds=$((seconds + minutes * 60))
        fi
        
        # Extract seconds
        if [[ "$time_part" =~ ([0-9]+)S ]]; then
            local secs="${BASH_REMATCH[1]}"
            seconds=$((seconds + secs))
        fi
    fi
    
    echo "$seconds"
}
