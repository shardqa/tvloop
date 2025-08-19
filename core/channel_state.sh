#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/logging.sh"
source "$SCRIPT_DIR/time_utils.sh"
source "$SCRIPT_DIR/playlist_parser.sh"

initialize_channel() {
    local channel_dir="$1"
    local state_file="$channel_dir/state.json"
    local playlist_file="$channel_dir/playlist.txt"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file not found: $playlist_file"
        return 1
    fi
    
    local start_time=$(get_current_timestamp)
    local playlist_data=($(parse_playlist "$playlist_file"))
    local total_duration="${playlist_data[-1]}"
    
    cat > "$state_file" << EOF
{
    "start_time": $start_time,
    "total_duration": $total_duration,
    "playlist_file": "$playlist_file",
    "last_updated": $start_time
}
EOF
    
    log "Channel initialized: start_time=$start_time, total_duration=$total_duration"
}

get_channel_status() {
    local channel_dir="$1"
    local state_file="$channel_dir/state.json"
    local playlist_file="$channel_dir/playlist.txt"
    
    if [[ ! -f "$state_file" ]]; then
        log "ERROR: Channel state file not found: $state_file"
        return 1
    fi
    
    local start_time=$(jq -r '.start_time' "$state_file")
    local total_duration=$(jq -r '.total_duration' "$state_file")
    
    local playlist_data=($(parse_playlist "$playlist_file"))
    local position_data=$(calculate_current_position "$start_time" "$total_duration")
    IFS='|' read -r cycles position_in_cycle elapsed_time <<< "$position_data"
    
    local video_data=$(get_current_video "$position_in_cycle" "${playlist_data[@]}")
    IFS='|' read -r video_index current_video video_position video_duration <<< "$video_data"
    
    if [[ -z "$current_video" ]]; then
        current_video="unknown"
        video_position="0"
        video_duration="0"
    fi
    
    echo "Channel Status:"
    echo "  Start Time: $(date -d @$start_time '+%Y-%m-%d %H:%M:%S')"
    echo "  Elapsed Time: ${elapsed_time}s"
    echo "  Cycles Completed: $cycles"
    echo "  Current Video: $(basename "$current_video")"
    echo "  Video Position: ${video_position}s / ${video_duration}s"
    echo "  Total Playlist Duration: ${total_duration}s"
}
