#!/bin/bash

source "$(dirname "$0")/time_utils.sh"
source "$(dirname "$0")/logging.sh"

get_video_title() {
    local video_path="$1"
    local filename=$(basename "$video_path")
    echo "${filename%.*}"
}

validate_playlist() {
    local playlist_file="$1"
    local valid_count=0
    local invalid_count=0
    local total_duration=0
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file not found: $playlist_file"
        return 1
    fi
    
    echo "Validating playlist: $playlist_file"
    echo "----------------------------------------"
    
    while IFS='|' read -r video_path title duration; do
        if [[ -f "$video_path" ]]; then
            local actual_duration=$(get_video_duration "$video_path")
            local expected_duration="${duration:-$actual_duration}"
            
            if [[ $actual_duration -eq 0 ]]; then
                echo "❌ $(basename "$video_path") - Duration could not be determined"
                invalid_count=$((invalid_count + 1))
            else
                echo "✅ $(basename "$video_path") - ${actual_duration}s"
                valid_count=$((valid_count + 1))
                total_duration=$((total_duration + actual_duration))
            fi
        else
            echo "❌ $video_path - File not found"
            invalid_count=$((invalid_count + 1))
        fi
    done < "$playlist_file"
    
    echo "----------------------------------------"
    echo "Valid videos: $valid_count"
    echo "Invalid videos: $invalid_count"
    echo "Total duration: ${total_duration}s ($(date -u -d @$total_duration '+%H:%M:%S'))"
    
    if [[ $invalid_count -gt 0 ]]; then
        return 1
    fi
    return 0
}
