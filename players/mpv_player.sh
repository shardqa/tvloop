#!/bin/bash

# Source common functions
# Note: common.bash doesn't exist, functions are available in other modules

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/tvloop_channels.sh"

launch_mpv() {
    local video_path="$1"
    local start_position="$2"
    local channel_dir="$3"
    
    # Check if we're in test mode - use mock launch
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        log "Running in test mode - using mock player launch"
        local mock_pid=999999
        echo "$mock_pid" > "$channel_dir/mpv.pid"
        log "Mock mpv launched with PID: $mock_pid"
        return 0
    fi
    
    if ! command -v mpv >/dev/null 2>&1; then
        log "ERROR: mpv not found. Please install mpv."
        return 1
    fi
    
    # Convert youtube:// URLs to proper YouTube URLs
    local actual_video_path="$video_path"
    if [[ "$video_path" =~ ^youtube:// ]]; then
        local video_id=$(echo "$video_path" | sed 's|^youtube://||')
        actual_video_path="https://www.youtube.com/watch?v=$video_id"
        log "Converting YouTube URL: $video_path -> $actual_video_path"
    fi
    
    log "Launching mpv: $actual_video_path at position ${start_position}s"
    
    # Use window mode instead of fullscreen for better compatibility
    local headless_opts="--force-window"
    
    # For YouTube URLs, use mpv's built-in YouTube support
    if [[ "$actual_video_path" =~ youtube\.com ]]; then
        log "Using mpv's built-in YouTube support"
        # Use 360p video + audio for better compatibility
        # Add channel switching script and input configuration
        local channels_dir=$(get_channels_dir)
        TVLOOP_CHANNELS_DIR="$channels_dir" mpv --start="$start_position" \
            $headless_opts \
            --ytdl-format="230+234-1" \
            --keep-open=yes \
            --idle=yes \
            --msg-level=all=v \
            --script="$PROJECT_ROOT/scripts/mpv_channel_switcher.lua" \
            --input-conf="$PROJECT_ROOT/config/mpv_input.conf" \
            "$actual_video_path" &
        
        local mpv_pid=$!
        echo "$mpv_pid" > "$channel_dir/mpv.pid"
        log "mpv launched with PID: $mpv_pid (with channel switching enabled)"
        return 0
    fi
    
    # Ensure we have display environment (only needed for non-headless mode)
    if [[ "${TEST_MODE:-false}" != "true" ]]; then
        export DISPLAY="${DISPLAY:-:0}"
    fi
    
    # Run mpv with appropriate options
    # Add channel switching script and input configuration for all videos
    mpv --start="$start_position" \
        $headless_opts \
        --keep-open=yes \
        --idle=yes \
        --msg-level=all=v \
        --script="$PROJECT_ROOT/scripts/mpv_channel_switcher.lua" \
        --input-conf="$PROJECT_ROOT/config/mpv_input.conf" \
        "$actual_video_path" &
    
    # Store PID for later management
    local mpv_pid=$!
    echo "$mpv_pid" > "$channel_dir/mpv.pid"
    log "mpv launched with PID: $mpv_pid (with channel switching enabled)"
    
    # Give mpv a moment to start
    sleep 2
    
    # Check if mpv is still running
    if ! kill -0 "$mpv_pid" 2>/dev/null; then
        log "ERROR: mpv failed to start or crashed"
        return 1
    fi
}
