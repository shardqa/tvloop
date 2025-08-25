#!/bin/bash

# MPV Player Core Module
# Core mpv player launch functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/tvloop_channels.sh"
source "$PROJECT_ROOT/core/format_selection.sh"

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
    
    # For YouTube URLs, try multiple approaches
    if [[ "$actual_video_path" =~ youtube\.com ]]; then
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
