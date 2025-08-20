#!/bin/bash

# Core Player Utilities for tvloop
# Handles video position tracking and provides access to other player modules

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/time_utils.sh"
source "$PROJECT_ROOT/core/playlist_parser.sh"

# Source other player modules
source "$PROJECT_ROOT/players/player_launcher.sh"
source "$PROJECT_ROOT/players/player_controller.sh"
source "$PROJECT_ROOT/players/player_monitor.sh"

# Get current video position in playlist cycle
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
