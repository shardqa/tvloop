#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/logging.sh"
source "$SCRIPT_DIR/time_utils.sh"

parse_playlist() {
    local playlist_file="$1"
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file not found: $playlist_file"
        return 1
    fi
    
    local videos=()
    local durations=()
    local total_duration=0
    
    while IFS='|' read -r video_path title duration; do
        # Skip comment lines (starting with #)
        if [[ "$video_path" =~ ^# ]]; then
            continue
        fi
        
        if [[ "$video_path" =~ ^youtube:// ]]; then
            # YouTube video - use provided duration
            videos+=("$video_path")
            durations+=("${duration:-0}")
            total_duration=$((total_duration + ${duration:-0}))
        elif [[ -f "$video_path" ]]; then
            # Local file
            videos+=("$video_path")
            durations+=("${duration:-$(get_video_duration "$video_path")}")
            total_duration=$((total_duration + ${duration:-$(get_video_duration "$video_path")}))
        else
            log "WARNING: Video file not found: $video_path"
        fi
    done < "$playlist_file"
    
    echo "${videos[@]}" "${durations[@]}" "$total_duration"
}

get_current_video() {
    local position_in_cycle="$1"
    shift
    local videos=("${@:1:$((($#-1)/2))}")
    local durations=("${@:$((($#-1)/2+1)):$((($#-1)/2))}")
    local total_duration="${!#}"
    
    local current_time=0
    local video_index=0
    
    for duration in "${durations[@]}"; do
        if [[ $position_in_cycle -lt $((current_time + duration)) ]]; then
            local video_position=$((position_in_cycle - current_time))
            echo "$video_index|${videos[$video_index]}|$video_position|$duration"
            return
        fi
        current_time=$((current_time + duration))
        video_index=$((video_index + 1))
    done
    
    if [[ ${#videos[@]} -gt 0 ]]; then
        echo "0|${videos[0]}|0|${durations[0]}"
    else
        echo "0|unknown|0|0"
    fi
}
