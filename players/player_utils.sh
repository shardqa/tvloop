#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/time_utils.sh"
source "$PROJECT_ROOT/core/playlist_parser.sh"

get_current_video_position() {
    local channel_dir="$1"
    local state_file="$channel_dir/state.json"
    local playlist_file="$channel_dir/playlist.txt"
    
    if [[ ! -f "$state_file" ]]; then
        log "ERROR: Channel state file not found: $state_file"
        return 1
    fi
    
    local start_time=$(jq -r '.start_time' "$state_file")
    local total_duration=$(jq -r '.total_duration' "$state_file")
    
    if [[ $total_duration -eq 0 ]]; then
        log "ERROR: Total duration is 0"
        return 1
    fi
    
    local elapsed_time=$(($(date +%s) - start_time))
    local position_in_cycle=$((elapsed_time % total_duration))
    
    local current_time=0
    local video_index=0
    
    while IFS='|' read -r video_path title duration; do
        if [[ -f "$video_path" ]]; then
            if [[ $position_in_cycle -lt $((current_time + duration)) ]]; then
                local video_position=$((position_in_cycle - current_time))
                echo "$video_path|$video_position|$duration"
                return 0
            fi
            current_time=$((current_time + duration))
            video_index=$((video_index + 1))
        fi
    done < "$playlist_file"
    
    log "ERROR: Could not determine current video position"
    return 1
}

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

stop_all_players() {
    local base_dir="${1:-channels}"
    
    find "$base_dir" -name "*.pid" -type f 2>/dev/null | while read -r pid_file; do
        local channel_dir=$(dirname "$pid_file")
        local player_type=$(basename "$pid_file" .pid)
        stop_player "$channel_dir" "$player_type"
    done
}

show_player_status() {
    local channel_dir="$1"
    
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
}
