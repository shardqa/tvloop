#!/bin/bash

# YouTube Playlist File Operations Module
# Core file operations for playlist management

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Process video entry for playlist
process_video_for_playlist() {
    local video_id="$1"
    local title="$2"
    local get_details_function="$3"  # Function to get video details
    
    if [[ -z "$video_id" || -z "$title" ]]; then
        return 1
    fi
    
    # Get video details using provided function
    local video_details=$($get_details_function "$video_id")
    if [[ $? -ne 0 ]]; then
        echo "⚠️  Skipping: $title (could not get details)" >&2
        return 1
    fi
    
    local duration=$(echo "$video_details" | cut -d'|' -f2)
    if [[ -z "$duration" || "$duration" == "0" ]]; then
        echo "⚠️  Skipping: $title (no duration)" >&2
        return 1
    fi
    
    # Return formatted entry
    echo "youtube://$video_id|$title|$duration"
    return 0
}

# Add video entry to playlist file
add_video_to_playlist() {
    local playlist_file="$1"
    local video_entry="$2"
    
    if [[ -z "$playlist_file" || -z "$video_entry" ]]; then
        return 1
    fi
    
    echo "$video_entry" >> "$playlist_file"
    return 0
}

# Initialize playlist file
initialize_playlist_file() {
    local playlist_file="$1"
    
    if [[ -z "$playlist_file" ]]; then
        return 1
    fi
    
    # Create empty playlist file
    > "$playlist_file"
    
    # Verify file was created
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Could not create playlist file: $playlist_file"
        return 1
    fi
    
    return 0
}

# Get playlist summary
get_playlist_summary() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "ERROR: Playlist file does not exist"
        return 1
    fi
    
    local total_videos=0
    local total_duration=0
    
    while IFS='|' read -r video_id title duration; do
        if [[ -n "$video_id" && -n "$title" && -n "$duration" ]]; then
            if [[ "$duration" =~ ^[0-9]+$ ]]; then
                total_videos=$((total_videos + 1))
                total_duration=$((total_duration + duration))
            fi
        fi
    done < "$playlist_file"
    
    echo "$total_videos|$total_duration"
    return 0
}

