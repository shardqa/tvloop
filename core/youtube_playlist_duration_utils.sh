#!/bin/bash

# YouTube Playlist Duration Utils Module
# Duration utilities and helper functions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

calculate_playlist_duration() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        echo "0"
        return 1
    fi
    
    local total_duration=0
    
    while IFS='|' read -r video_id title duration; do
        if [[ -n "$duration" && "$duration" =~ ^[0-9]+$ ]]; then
            total_duration=$((total_duration + duration))
        fi
    done < "$playlist_file"
    
    echo "$total_duration"
    return 0
}

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

check_duration_target() {
    local playlist_file="$1"
    local target_duration="$2"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    local actual_duration=$(calculate_playlist_duration "$playlist_file")
    
    if [[ $actual_duration -ge $target_duration ]]; then
        echo "✅ Duration target met: $(format_duration $actual_duration) >= $(format_duration $target_duration)"
        return 0
    else
        echo "⚠️  Duration target not met: $(format_duration $actual_duration) < $(format_duration $target_duration)"
        return 1
    fi
}


