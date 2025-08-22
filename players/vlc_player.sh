#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

launch_vlc() {
    local video_path="$1"
    local start_position="$2"
    local channel_dir="$3"
    
    # Check if we're in test mode - use mock launch
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        log "Running in test mode - using mock player launch"
        local mock_pid=999999
        echo "$mock_pid" > "$channel_dir/vlc.pid"
        log "Mock VLC launched with PID: $mock_pid"
        return 0
    fi
    
    if ! command -v vlc >/dev/null 2>&1; then
        log "ERROR: VLC not found. Please install VLC or use mpv."
        return 1
    fi
    
    log "Launching VLC: $video_path at position ${start_position}s"
    
    vlc --start-time="$start_position" --no-video-title-show --no-qt-name-in-title \
        --no-qt-system-tray --no-qt-notify-osd --no-qt-start-minimized \
        --no-qt-pause-minimized --no-qt-continue --no-qt-recentplay \
        --no-qt-automount --no-qt-fs-controller --no-qt-fs-controller-hide-mouse \
        --no-qt-fs-controller-show-on-fullscreen --no-qt-fs-controller-show-on-mouse-move \
        --no-qt-fs-controller-show-on-mouse-move-delay --no-qt-fs-controller-show-on-mouse-move-timeout \
        --no-qt-fs-controller-show-on-mouse-move-fade --no-qt-fs-controller-show-on-mouse-move-fade-delay \
        --no-qt-fs-controller-show-on-mouse-move-fade-timeout --no-qt-fs-controller-show-on-mouse-move-fade-duration \
        --no-qt-fs-controller-show-on-mouse-move-fade-easing --no-qt-fs-controller-show-on-mouse-move-fade-easing-param \
        --no-qt-fs-controller-show-on-mouse-move-fade-easing-param2 --no-qt-fs-controller-show-on-mouse-move-fade-easing-param3 \
        --no-qt-fs-controller-show-on-mouse-move-fade-easing-param4 --no-qt-fs-controller-show-on-mouse-move-fade-easing-param5 \
        --no-qt-fs-controller-show-on-mouse-move-fade-easing-param6 --no-qt-fs-controller-show-on-mouse-move-fade-easing-param7 \
        --no-qt-fs-controller-show-on-mouse-move-fade-easing-param8 --no-qt-fs-controller-show-on-mouse-move-fade-easing-param9 \
        --no-qt-fs-controller-show-on-mouse-move-fade-easing-param10 "$video_path" &
    
    local vlc_pid=$!
    echo "$vlc_pid" > "$channel_dir/vlc.pid"
    log "VLC launched with PID: $vlc_pid"
}
