#!/bin/bash

# YouTube Player MPV for tvloop
# Handles YouTube video playback using yt-dlp and mpv

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Launch YouTube video with yt-dlp and mpv
launch_youtube_mpv() {
    local video_id="$1"
    local start_position="$2"
    local channel_dir="$3"
    
    # Check if yt-dlp is available
    if ! command -v yt-dlp >/dev/null 2>&1; then
        log "ERROR: yt-dlp not found. Please install yt-dlp for YouTube playback."
        log "Install with: pip install yt-dlp"
        return 1
    fi
    
    if ! command -v mpv >/dev/null 2>&1; then
        log "ERROR: mpv not found. Please install mpv for YouTube playback."
        return 1
    fi
    
    log "Launching YouTube video with mpv: $video_id at position ${start_position}s"
    
    # Check if we're in test mode for headless operation
    local headless_opts=""
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        log "Running YouTube mpv in headless test mode"
        headless_opts="--no-video --vo=null --no-terminal --no-osc --no-osd-bar --no-input-default-bindings --no-input-terminal"
    else
        headless_opts="--no-osc --no-osd-bar --no-input-default-bindings"
    fi
    
    # Use yt-dlp to get the direct stream URL and pipe to mpv
    yt-dlp -f "best[height<=1080]" --get-url "https://www.youtube.com/watch?v=$video_id" | \
    mpv --start="$start_position" $headless_opts - &
    
    local mpv_pid=$!
    echo "$mpv_pid" > "$channel_dir/youtube_mpv.pid"
    log "YouTube mpv launched with PID: $mpv_pid"
}
