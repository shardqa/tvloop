#!/bin/bash

# Player Controller for tvloop
# Handles stopping players (both local and YouTube)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Stop a specific player
stop_player() {
    local channel_dir="$1"
    local player_type="${2:-mpv}"
    local pid_file="$channel_dir/${player_type}.pid"
    
    if [[ -f "$pid_file" ]]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            log "Stopping $player_type (PID: $pid)"
            kill "$pid"
            rm -f "$pid_file"
        else
            log "WARNING: $player_type process (PID: $pid) not found"
            rm -f "$pid_file"
        fi
    else
        log "No $player_type PID file found"
    fi
}

# Stop all players in a directory
stop_all_players() {
    local base_dir="${1:-channels}"
    
    find "$base_dir" -name "*.pid" -type f 2>/dev/null | while read -r pid_file; do
        local channel_dir=$(dirname "$pid_file")
        local player_type=$(basename "$pid_file" .pid)
        
        # Handle YouTube players
        if [[ "$player_type" == youtube_* ]]; then
            local actual_player_type="${player_type#youtube_}"
            source "$PROJECT_ROOT/players/youtube_player.sh"
            stop_youtube_player "$channel_dir" "$actual_player_type"
        else
            stop_player "$channel_dir" "$player_type"
        fi
    done
}
