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
    
    # For YouTube URLs, use yt-dlp to get the direct stream URL
    if [[ "$actual_video_path" =~ youtube\.com ]]; then
        log "Getting direct stream URL using yt-dlp"
        local stream_urls=$(yt-dlp --get-url "$actual_video_path" 2>/dev/null)
        if [[ $? -eq 0 && -n "$stream_urls" ]]; then
            # Take the first URL (usually the video stream)
            actual_video_path=$(echo "$stream_urls" | head -1)
            log "Using direct stream URL: $actual_video_path"
        else
            log "ERROR: Could not get stream URL from yt-dlp"
            return 1
        fi
    fi
    
    mpv --start="$start_position" --no-osc --no-osd-bar \
        --no-input-terminal --no-input-media-keys \
        --no-input-right-alt-gr \
        --geometry=50%:50% --autofit=1280x720 \
        "$actual_video_path" &
    
    local mpv_pid=$!
    echo "$mpv_pid" > "$channel_dir/mpv.pid"
    log "mpv launched with PID: $mpv_pid"
}
