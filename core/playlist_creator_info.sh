#!/bin/bash

# Playlist Creator Info Module
# Handles playlist information display logic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/time_utils.sh"
source "$SCRIPT_DIR/logging.sh"
source "$SCRIPT_DIR/playlist_utils.sh"

show_playlist_info() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file not found: $playlist_file"
        return 1
    fi
    
    local total_duration=0
    local video_count=0
    
    echo "Playlist: $playlist_file"
    echo "----------------------------------------"
    
    while IFS='|' read -r video_path title duration; do
        if [[ "$video_path" =~ ^youtube:// ]]; then
            # YouTube video
            local video_id=$(echo "$video_path" | sed 's|^youtube://||')
            echo "$((video_count + 1)). YouTube: $title"
            echo "    Video ID: $video_id"
            echo "    Duration: ${duration}s"
            echo ""
            total_duration=$((total_duration + duration))
            video_count=$((video_count + 1))
        elif [[ -f "$video_path" ]]; then
            # Local file
            local actual_duration=$(get_video_duration "$video_path")
            echo "$((video_count + 1)). $(basename "$video_path")"
            echo "    Duration: ${actual_duration}s"
            echo "    Title: $title"
            echo ""
            total_duration=$((total_duration + actual_duration))
            video_count=$((video_count + 1))
        fi
    done < "$playlist_file"
    
    echo "----------------------------------------"
    echo "Total videos: $video_count"
    echo "Total duration: ${total_duration}s ($(date -u -d @$total_duration '+%H:%M:%S'))"
    if [[ $video_count -gt 0 ]]; then
        echo "Average duration: $((total_duration / video_count))s"
    else
        echo "Average duration: 0s (no videos)"
    fi
}
