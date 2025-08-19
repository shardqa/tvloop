#!/bin/bash

source "$(dirname "$0")/time_utils.sh"
source "$(dirname "$0")/logging.sh"
source "$(dirname "$0")/playlist_utils.sh"

create_playlist_from_directory() {
    local videos_dir="$1"
    local playlist_file="$2"
    local extensions="${3:-mp4,mkv,avi,mov,wmv,flv,webm}"
    
    if [[ ! -d "$videos_dir" ]]; then
        log "ERROR: Videos directory not found: $videos_dir"
        return 1
    fi
    
    echo "Creating playlist from directory: $videos_dir"
    echo "Extensions: $extensions"
    
    > "$playlist_file"
    local count=0
    
    while IFS= read -r -d '' video_file; do
        local duration=$(get_video_duration "$video_file")
        local title=$(get_video_title "$video_file")
        
        if [[ $duration -gt 0 ]]; then
            echo "$video_file|$title|$duration" >> "$playlist_file"
            echo "Added: $(basename "$video_file") - ${duration}s"
            count=$((count + 1))
        else
            log "WARNING: Could not determine duration for: $video_file"
        fi
    done < <(find "$videos_dir" -type f \( $(echo "$extensions" | sed 's/,/ -o -name "*.&/g' | sed 's/^/-name "*.&/') \) -print0 | sort -z)
    
    echo "Playlist created with $count videos: $playlist_file"
}

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
        if [[ -f "$video_path" ]]; then
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
