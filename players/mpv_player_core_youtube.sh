#!/bin/bash

# MPV Player Core YouTube Module
# Handles YouTube-specific launch functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/tvloop_channels.sh"

launch_youtube_video() {
    local actual_video_path="$1"
    local start_position="$2"
    local channel_dir="$3"
    local headless_opts="$4"
    
    log "Attempting to play YouTube video"
    
    # First try: Use mpv's built-in YouTube support with better user agent
    log "Trying mpv's built-in YouTube support..."
    local channels_dir=$(get_channels_dir)
    TVLOOP_CHANNELS_DIR="$channels_dir" mpv --start="$start_position" \
        $headless_opts \
        --ytdl-format="18" \
        --ytdl-raw-options=cookies-from-browser=firefox \
        --keep-open=yes \
        --idle=yes \
        --msg-level=all=v \
        --script="$PROJECT_ROOT/scripts/mpv_channel_switcher.lua" \
        --input-conf="$PROJECT_ROOT/config/mpv_input.conf" \
        "$actual_video_path" &
    
    # Wait a moment to see if it starts successfully
    sleep 2
    
    # Check if mpv is still running
    if ! ps -p $! > /dev/null 2>&1; then
        log "mpv failed to start, trying alternative approach..."
        
        # Second try: Use yt-dlp to download first
        local temp_dir="$channel_dir/downloads"
        mkdir -p "$temp_dir"
        
        log "Downloading video with yt-dlp..."
        if yt-dlp --format="230+234-1" --output="$temp_dir/video.%(ext)s" "$actual_video_path"; then
            local downloaded_file=$(find "$temp_dir" -name "video.*" -type f | head -1)
            if [[ -n "$downloaded_file" ]]; then
                log "Downloaded file: $downloaded_file"
                
                # Play the downloaded file with mpv
                TVLOOP_CHANNELS_DIR="$channels_dir" mpv --start="$start_position" \
                    $headless_opts \
                    --keep-open=yes \
                    --idle=yes \
                    --msg-level=all=v \
                    --script="$PROJECT_ROOT/scripts/mpv_channel_switcher.lua" \
                    --input-conf="$PROJECT_ROOT/config/mpv_input.conf" \
                    "$downloaded_file" &
            else
                log "ERROR: No downloaded file found"
                return 1
            fi
        else
            log "ERROR: Failed to download video with yt-dlp"
            log "This might be due to YouTube access restrictions or video unavailability"
            return 1
        fi
    fi
    
    local mpv_pid=$!
    echo "$mpv_pid" > "$channel_dir/mpv.pid"
    log "mpv launched with PID: $mpv_pid (with channel switching enabled)"
    return 0
}
