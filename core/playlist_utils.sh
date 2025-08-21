#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/time_utils.sh"
source "$SCRIPT_DIR/logging.sh"

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
        if [[ "$video_path" =~ ^youtube:// ]]; then
            # YouTube video - use provided duration
            local video_id=$(echo "$video_path" | sed 's|^youtube://||')
            if [[ -n "$duration" && "$duration" != "0" ]]; then
                echo "✅ YouTube: $title - ${duration}s"
                valid_count=$((valid_count + 1))
                total_duration=$((total_duration + duration))
            else
                echo "❌ YouTube: $title - Duration not available"
                invalid_count=$((invalid_count + 1))
            fi
        elif [[ -f "$video_path" ]]; then
            # Local file
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
