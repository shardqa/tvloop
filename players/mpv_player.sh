#!/bin/bash

source "$(dirname "$0")/../core/logging.sh"

launch_mpv() {
    local video_path="$1"
    local start_position="$2"
    local channel_dir="$3"
    
    if ! command -v mpv >/dev/null 2>&1; then
        log "ERROR: mpv not found. Please install mpv or use VLC."
        return 1
    fi
    
    log "Launching mpv: $video_path at position ${start_position}s"
    
    mpv --start="$start_position" --no-osc --no-osd-bar --no-input-default-bindings \
        --no-input-vo-keyboard --no-input-terminal --no-input-media-keys \
        --no-input-right-alt-gr --no-input-cursor --no-input-mouse-cursor \
        --no-input-double-click-time --no-input-drag-start --no-input-drag-drop \
        --no-input-key-fifo-size --no-input-cmdlist --no-input-test \
        --no-input-keylist --no-input-mouse-button --no-input-joystick \
        --no-input-appleremote --no-input-cocoa-cb --no-input-vo-cursor \
        --no-input-vo-keyboard --no-input-vo-mouse --no-input-vo-touch \
        --no-input-vo-tablet --no-input-vo-pen --no-input-vo-eraser \
        --no-input-vo-cursor-visible --no-input-vo-cursor-visible-delay \
        --no-input-vo-cursor-visible-timeout --no-input-vo-cursor-visible-fade \
        --no-input-vo-cursor-visible-fade-delay --no-input-vo-cursor-visible-fade-timeout \
        --no-input-vo-cursor-visible-fade-duration --no-input-vo-cursor-visible-fade-easing \
        --no-input-vo-cursor-visible-fade-easing-param --no-input-vo-cursor-visible-fade-easing-param2 \
        --no-input-vo-cursor-visible-fade-easing-param3 --no-input-vo-cursor-visible-fade-easing-param4 \
        --no-input-vo-cursor-visible-fade-easing-param5 --no-input-vo-cursor-visible-fade-easing-param6 \
        --no-input-vo-cursor-visible-fade-easing-param7 --no-input-vo-cursor-visible-fade-easing-param8 \
        --no-input-vo-cursor-visible-fade-easing-param9 --no-input-vo-cursor-visible-fade-easing-param10 \
        "$video_path" &
    
    local mpv_pid=$!
    echo "$mpv_pid" > "$channel_dir/mpv.pid"
    log "mpv launched with PID: $mpv_pid"
}
