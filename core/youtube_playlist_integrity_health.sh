#!/bin/bash

# YouTube Playlist Integrity Health Module
# Health scoring and assessment functions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_format_validation.sh"
source "$PROJECT_ROOT/core/logging.sh"

get_playlist_health_score() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "0"
        return 1
    fi
    
    local total_lines=0
    local valid_lines=0
    local duplicate_count=0
    
    while IFS= read -r line; do
        total_lines=$((total_lines + 1))
        if validate_playlist_line "$line"; then
            valid_lines=$((valid_lines + 1))
        fi
    done < "$playlist_file"
    
    local video_ids=$(grep "^youtube://" "$playlist_file" | cut -d'|' -f1 | sed 's/^youtube:\/\///')
    local total_videos=$(echo "$video_ids" | wc -l)
    local unique_videos=$(echo "$video_ids" | sort -u | wc -l)
    duplicate_count=$((total_videos - unique_videos))
    
    local format_score=0
    local duplicate_score=0
    
    if [[ $total_lines -gt 0 ]]; then
        format_score=$(( (valid_lines * 100) / total_lines ))
    fi
    
    if [[ $total_videos -gt 0 ]]; then
        duplicate_score=$(( ((total_videos - duplicate_count) * 100) / total_videos ))
    fi
    
    local health_score=$(( (format_score + duplicate_score) / 2 ))
    
    echo "$health_score"
    return 0
}

assess_playlist_health() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "❌ File does not exist: $playlist_file"
        return 1
    fi
    
    local health_score=$(get_playlist_health_score "$playlist_file")
    
    echo "🏥 Health Score: ${health_score}/100"
    
    if [[ $health_score -ge 90 ]]; then
        echo "   Status: 🟢 Excellent - No action needed"
        return 0
    elif [[ $health_score -ge 75 ]]; then
        echo "   Status: 🟡 Good - Minor cleanup recommended"
        return 0
    elif [[ $health_score -ge 50 ]]; then
        echo "   Status: 🟠 Fair - Repair recommended"
        return 1
    else
        echo "   Status: 🔴 Poor - Major repair needed"
        return 1
    fi
}


