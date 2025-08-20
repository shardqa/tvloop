#!/bin/bash

# YouTube Playlist Operations for tvloop
# Handles playlist management operations (add, list, info)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_api.sh"

# Add video to existing playlist
add_video() {
    local channel_dir="$1"
    local youtube_url="$2"
    local playlist_file="$channel_dir/playlist.txt"
    
    if [[ -z "$youtube_url" ]]; then
        log "ERROR: YouTube URL is required"
        echo "Usage: $0 [channel_dir] add <youtube_url>"
        return 1
    fi
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: No existing playlist found. Create one first with 'create' command."
        return 1
    fi
    
    log "Adding video to playlist: $youtube_url"
    
    local video_id=$(extract_video_id "$youtube_url")
    if [[ -z "$video_id" ]]; then
        log "ERROR: Could not extract video ID from URL: $youtube_url"
        return 1
    fi
    
    local playlist_entry=$(get_single_video_playlist_entry "$youtube_url")
    
    if [[ $? -eq 0 ]]; then
        echo "$playlist_entry" >> "$playlist_file"
        log "Video added to playlist: $playlist_file"
        echo "✅ Video added to playlist"
    else
        log "ERROR: Failed to get video details"
        return 1
    fi
}

# List existing playlists
list_playlists() {
    local channel_dir="$1"
    
    echo "YouTube Playlists in $channel_dir:"
    echo ""
    
    if [[ -f "$channel_dir/playlist.txt" ]]; then
        local video_count=$(wc -l < "$channel_dir/playlist.txt")
        local total_duration=0
        
        echo "📁 playlist.txt ($video_count videos)"
        
        # Calculate total duration
        while IFS='|' read -r path title duration; do
            if [[ "$duration" =~ ^[0-9]+$ ]]; then
                total_duration=$((total_duration + duration))
            fi
        done < "$channel_dir/playlist.txt"
        
        local hours=$((total_duration / 3600))
        local minutes=$(((total_duration % 3600) / 60))
        local seconds=$((total_duration % 60))
        
        echo "   Total Duration: ${hours}h ${minutes}m ${seconds}s"
        echo "   Format: $(head -1 "$channel_dir/playlist.txt" | cut -d'|' -f1 | cut -d'/' -f1)"
        echo ""
    else
        echo "No playlists found."
        echo ""
    fi
}

# Source additional operations
source "$PROJECT_ROOT/scripts/youtube_playlist_info.sh"
