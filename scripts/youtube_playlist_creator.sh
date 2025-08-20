#!/bin/bash

# YouTube Playlist Creator for tvloop
# Handles creating playlists from YouTube URLs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_api.sh"

# Create playlist from YouTube URL
create_playlist() {
    local channel_dir="$1"
    local youtube_url="$2"
    local playlist_file="$channel_dir/playlist.txt"
    
    if [[ -z "$youtube_url" ]]; then
        log "ERROR: YouTube URL is required"
        echo "Usage: $0 [channel_dir] create <youtube_url>"
        return 1
    fi
    
    log "Creating playlist from YouTube URL: $youtube_url"
    
    # Check if it's a playlist or single video
    local playlist_id=$(extract_playlist_id "$youtube_url")
    
    if [[ -n "$playlist_id" ]]; then
        # It's a playlist
        log "Detected YouTube playlist: $playlist_id"
        create_youtube_playlist "$youtube_url" "$playlist_file"
        local result=$?
        
        if [[ $result -eq 0 ]]; then
            log "Playlist created successfully: $playlist_file"
            echo "✅ Playlist created with $(cat "$playlist_file" | wc -l) videos"
        else
            log "ERROR: Failed to create playlist"
            return 1
        fi
    else
        # It's a single video
        local video_id=$(extract_video_id "$youtube_url")
        if [[ -n "$video_id" ]]; then
            log "Detected YouTube video: $video_id"
            local playlist_entry=$(get_single_video_playlist_entry "$youtube_url")
            
            if [[ $? -eq 0 ]]; then
                echo "$playlist_entry" > "$playlist_file"
                log "Single video playlist created: $playlist_file"
                echo "✅ Single video playlist created"
            else
                log "ERROR: Failed to get video details"
                return 1
            fi
        else
            log "ERROR: Could not extract video or playlist ID from URL: $youtube_url"
            return 1
        fi
    fi
}
