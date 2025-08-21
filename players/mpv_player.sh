#!/bin/bash

# Source common functions
source "$(dirname "$0")/../core/common.bash"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

launch_mpv() {
    local video_path="$1"
    local start_position="$2"
    local channel_dir="$3"
    
    if ! command -v mpv >/dev/null 2>&1; then
        log "ERROR: mpv not found. Please install mpv or use VLC."
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
    
    # Check if we're in test mode for headless operation
    local headless_opts=""
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        log "Running mpv in headless test mode"
        headless_opts="--no-video --vo=null --no-terminal --no-osc --no-osd-bar --no-input-default-bindings --no-input-terminal"
    else
        headless_opts="--force-window --geometry=50%:50%"
    fi
    
    # For YouTube URLs, use mpv's built-in YouTube support
    if [[ "$actual_video_path" =~ youtube\.com ]]; then
        log "Using mpv's built-in YouTube support"
        # mpv will automatically use yt-dlp if available
        mpv --start="$start_position" \
            $headless_opts \
            --ytdl-raw-options="cookies-from-browser=firefox,format=134" \
            --msg-level=all=v \
            "$actual_video_path" &
        
        local mpv_pid=$!
        echo "$mpv_pid" > "$channel_dir/mpv.pid"
        log "mpv launched with PID: $mpv_pid"
        return 0
    fi
    
    # Ensure we have display environment (only needed for non-headless mode)
    if [[ "${TEST_MODE:-false}" != "true" ]]; then
        export DISPLAY="${DISPLAY:-:0}"
    fi
    
    # Run mpv with appropriate options
    mpv --start="$start_position" \
        $headless_opts \
        --msg-level=all=v \
        "$actual_video_path" &
    
    # Store PID for later management
    local mpv_pid=$!
    echo "$mpv_pid" > "$channel_dir/mpv.pid"
    log "mpv launched with PID: $mpv_pid"
    
    # Give mpv a moment to start
    sleep 2
    
    # Check if mpv is still running
    if ! kill -0 "$mpv_pid" 2>/dev/null; then
        log "ERROR: mpv failed to start or crashed"
        return 1
    fi
}
