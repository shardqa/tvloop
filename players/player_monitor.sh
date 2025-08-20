#!/bin/bash

# Player Monitor for tvloop
# Handles monitoring player status (both local and YouTube)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Show status of all players in a channel
show_player_status() {
    local channel_dir="$1"
    
    # Check local mpv player
    if [[ -f "$channel_dir/mpv.pid" ]]; then
        local pid=$(cat "$channel_dir/mpv.pid")
        if kill -0 "$pid" 2>/dev/null; then
            echo "mpv running (PID: $pid)"
        else
            echo "mpv not running (stale PID file)"
            rm -f "$channel_dir/mpv.pid"
        fi
    else
        echo "mpv not running"
    fi
    
    # Check local VLC player
    if [[ -f "$channel_dir/vlc.pid" ]]; then
        local pid=$(cat "$channel_dir/vlc.pid")
        if kill -0 "$pid" 2>/dev/null; then
            echo "VLC running (PID: $pid)"
        else
            echo "VLC not running (stale PID file)"
            rm -f "$channel_dir/vlc.pid"
        fi
    else
        echo "VLC not running"
    fi
    
    # Check YouTube mpv player
    if [[ -f "$channel_dir/youtube_mpv.pid" ]]; then
        local pid=$(cat "$channel_dir/youtube_mpv.pid")
        if kill -0 "$pid" 2>/dev/null; then
            echo "YouTube mpv running (PID: $pid)"
        else
            echo "YouTube mpv not running (stale PID file)"
            rm -f "$channel_dir/youtube_mpv.pid"
        fi
    else
        echo "YouTube mpv not running"
    fi
    
    # Check YouTube VLC player
    if [[ -f "$channel_dir/youtube_vlc.pid" ]]; then
        local pid=$(cat "$channel_dir/youtube_vlc.pid")
        if kill -0 "$pid" 2>/dev/null; then
            echo "YouTube VLC running (PID: $pid)"
        else
            echo "YouTube VLC not running (stale PID file)"
            rm -f "$channel_dir/youtube_vlc.pid"
        fi
    else
        echo "YouTube VLC not running"
    fi
}
