#!/bin/bash

# YouTube Player VLC for tvloop
# Handles YouTube video playback using yt-dlp and VLC

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Launch YouTube video with yt-dlp and VLC
launch_youtube_vlc() {
    local video_id="$1"
    local start_position="$2"
    local channel_dir="$3"
    
    # Check if yt-dlp is available
    if ! command -v yt-dlp >/dev/null 2>&1; then
        log "ERROR: yt-dlp not found. Please install yt-dlp for YouTube playback."
        log "Install with: pip install yt-dlp"
        return 1
    fi
    
    if ! command -v vlc >/dev/null 2>&1; then
        log "ERROR: VLC not found. Please install VLC for YouTube playback."
        return 1
    fi
    
    log "Launching YouTube video with VLC: $video_id at position ${start_position}s"
    
    # Use yt-dlp to get the direct stream URL and pipe to VLC
    yt-dlp -f "best[height<=1080]" --get-url "https://www.youtube.com/watch?v=$video_id" | \
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
        --no-qt-fs-controller-show-on-mouse-move-fade-easing-param10 - &
    
    local vlc_pid=$!
    echo "$vlc_pid" > "$channel_dir/youtube_vlc.pid"
    log "YouTube VLC launched with PID: $vlc_pid"
}
