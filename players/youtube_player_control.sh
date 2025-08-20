#!/bin/bash

# YouTube Player Control for tvloop
# Handles YouTube player control operations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Stop YouTube player
stop_youtube_player() {
    local channel_dir="$1"
    local player_type="${2:-mpv}"
    local pid_file="$channel_dir/youtube_${player_type}.pid"
    
    if [[ -f "$pid_file" ]]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            log "Stopping YouTube $player_type (PID: $pid)"
            kill "$pid"
            rm -f "$pid_file"
        else
            log "WARNING: YouTube $player_type process (PID: $pid) not found"
            rm -f "$pid_file"
        fi
    else
        log "No YouTube $player_type PID file found"
    fi
}
