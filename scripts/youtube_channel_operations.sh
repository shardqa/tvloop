#!/bin/bash

# YouTube Channel Operations for tvloop
# Handles core YouTube channel operations (init, play, stop, status)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/channel_state.sh"
source "$PROJECT_ROOT/players/player_utils.sh"

# Initialize channel
initialize_youtube_channel() {
    local channel_dir="$1"
    local playlist_file="$channel_dir/playlist.txt"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: No playlist file found. Create one first using youtube_playlist_manager.sh"
        echo "Usage: $PROJECT_ROOT/scripts/youtube_playlist_manager.sh $channel_dir create <youtube_url>"
        return 1
    fi
    
    log "Initializing YouTube channel: $channel_dir"
    initialize_channel "$channel_dir"
}

# Play YouTube channel
play_youtube_channel() {
    local channel_dir="$1"
    local player_type="${2:-mpv}"
    local state_file="$channel_dir/state.json"
    local playlist_file="$channel_dir/playlist.txt"
    
    # Check if channel is initialized
    if [[ ! -f "$state_file" ]]; then
        log "Channel not initialized. Initializing now..."
        initialize_youtube_channel "$channel_dir"
        if [[ $? -ne 0 ]]; then
            return 1
        fi
    fi
    
    # Check if playlist exists
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: No playlist file found"
        return 1
    fi
    
    log "Starting YouTube channel playback with $player_type"
    
    # Get current video position
    local current_video_info=$(get_current_video_position "$channel_dir")
    
    if [[ $? -ne 0 ]]; then
        log "ERROR: Could not determine current video position"
        return 1
    fi
    
    IFS='|' read -r video_path start_position duration <<< "$current_video_info"
    
    if [[ -z "$video_path" ]]; then
        log "ERROR: No video found in playlist"
        return 1
    fi
    
    log "Playing: $video_path at position ${start_position}s"
    
    # Launch the video
    launch_video "$video_path" "$start_position" "$channel_dir" "$player_type"
    
    if [[ $? -eq 0 ]]; then
        echo "✅ YouTube channel started playing"
        echo "   Video: $video_path"
        echo "   Position: ${start_position}s / ${duration}s"
        echo "   Player: $player_type"
    else
        log "ERROR: Failed to start playback"
        return 1
    fi
}

# Source additional operations
source "$PROJECT_ROOT/scripts/youtube_channel_control.sh"
