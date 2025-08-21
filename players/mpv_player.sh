#!/bin/bash

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
    
    # For YouTube URLs, let mpv handle them directly with yt-dlp integration
    if [[ "$actual_video_path" =~ youtube\.com ]]; then
        log "Using mpv's built-in yt-dlp integration for YouTube URL"
        # mpv will use yt-dlp automatically for YouTube URLs
    fi
    
    # Ensure we have display environment
    export DISPLAY="${DISPLAY:-:0}"
    
    # Run mpv with Wayland support
    mpv --start="$start_position" \
        --force-window \
        --geometry=50%:50% \
        --vo=gpu \
        --gpu-context=wayland \
        --msg-level=all=v \
        --no-terminal \
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
