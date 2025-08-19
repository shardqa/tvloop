#!/bin/bash

get_current_timestamp() {
    date +%s
}

calculate_elapsed_time() {
    local start_time="$1"
    local current_time=$(get_current_timestamp)
    echo $((current_time - start_time))
}

get_video_duration() {
    local video_path="$1"
    if command -v ffprobe >/dev/null 2>&1; then
        ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$video_path" 2>/dev/null | cut -d. -f1
    else
        echo "0"
    fi
}

calculate_current_position() {
    local start_time="$1"
    local total_duration="$2"
    local elapsed_time=$(calculate_elapsed_time "$start_time")
    
    if [[ $total_duration -eq 0 ]]; then
        echo "0|0|0"
        return
    fi
    
    local cycles=$((elapsed_time / total_duration))
    local position_in_cycle=$((elapsed_time % total_duration))
    
    echo "$cycles|$position_in_cycle|$elapsed_time"
}
