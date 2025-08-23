#!/bin/bash

# YouTube Playlist Display Module
# Display and formatting functions for playlists

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_file_ops.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Display playlist creation progress
display_progress() {
    local current="$1"
    local total="$2"
    local operation="${3:-Processing}"
    
    if [[ $total -gt 0 ]]; then
        local percentage=$(( (current * 100) / total ))
        echo "📊 $operation: $current/$total ($percentage%)"
    else
        echo "📊 $operation: $current"
    fi
}

# Format file size
format_file_size() {
    local file_path="$1"
    
    if [[ ! -f "$file_path" ]]; then
        echo "0B"
        return 1
    fi
    
    local size=$(stat -c%s "$file_path" 2>/dev/null || stat -f%z "$file_path" 2>/dev/null)
    
    if [[ $size -lt 1024 ]]; then
        echo "${size}B"
    elif [[ $size -lt 1048576 ]]; then
        echo "$(( size / 1024 ))KB"
    else
        echo "$(( size / 1048576 ))MB"
    fi
}

# Display playlist file info
display_playlist_info() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "❌ Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    local summary=$(get_playlist_summary "$playlist_file")
    local video_count=$(echo "$summary" | cut -d'|' -f1)
    local total_duration=$(echo "$summary" | cut -d'|' -f2)
    local file_size=$(format_file_size "$playlist_file")
    
    echo "📁 Playlist File Info:"
    echo "   File: $playlist_file"
    echo "   Size: $file_size"
    echo "   Videos: $video_count"
    echo "   Duration: ${total_duration}s"
    
    if [[ $total_duration -gt 0 ]]; then
        local hours=$((total_duration / 3600))
        local minutes=$(((total_duration % 3600) / 60))
        echo "   Duration (formatted): ${hours}h ${minutes}m"
    fi
}

# Format duration in human-readable format
format_duration() {
    local seconds="$1"
    
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local remaining_seconds=$((seconds % 60))
    
    if [[ $hours -gt 0 ]]; then
        printf "%dh %dm %ds" "$hours" "$minutes" "$remaining_seconds"
    elif [[ $minutes -gt 0 ]]; then
        printf "%dm %ds" "$minutes" "$remaining_seconds"
    else
        printf "%ds" "$remaining_seconds"
    fi
}


