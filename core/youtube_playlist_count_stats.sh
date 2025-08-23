#!/bin/bash

# YouTube Playlist Count Statistics Module
# Handles detailed playlist statistics and analysis

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

parse_playlist_entry() {
    local line="$1"
    if [[ "$line" =~ ^youtube://([^|]+)\|([^|]+)\|([0-9]+)$ ]]; then
        echo "${BASH_REMATCH[1]}|${BASH_REMATCH[2]}|${BASH_REMATCH[3]}"
        return 0
    fi
    return 1
}

get_playlist_video_stats() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist"
        return 1
    fi
    
    local total_videos=0
    local total_duration=0
    local shortest_duration=999999
    local longest_duration=0
    
    while IFS= read -r line; do
        local parsed_entry=$(parse_playlist_entry "$line")
        if [[ $? -eq 0 ]]; then
            local duration=$(echo "$parsed_entry" | cut -d'|' -f3)
            if [[ "$duration" =~ ^[0-9]+$ ]]; then
                total_videos=$((total_videos + 1))
                total_duration=$((total_duration + duration))
                
                if [[ $duration -lt $shortest_duration ]]; then
                    shortest_duration=$duration
                fi
                
                if [[ $duration -gt $longest_duration ]]; then
                    longest_duration=$duration
                fi
            fi
        fi
    done < "$playlist_file"
    
    if [[ $total_videos -eq 0 ]]; then
        echo "No valid videos found in playlist"
        return 1
    fi
    
    local average_duration=$((total_duration / total_videos))
    
    echo "📊 Playlist Statistics:"
    echo "   Videos: $total_videos"
    echo "   Total Duration: ${total_duration}s"
    echo "   Average Duration: ${average_duration}s"
    echo "   Shortest Video: ${shortest_duration}s"
    echo "   Longest Video: ${longest_duration}s"
}

get_playlist_duration_summary() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        return 1
    fi
    
    local total_duration=0
    local video_count=0
    
    while IFS= read -r line; do
        local parsed_entry=$(parse_playlist_entry "$line")
        if [[ $? -eq 0 ]]; then
            local duration=$(echo "$parsed_entry" | cut -d'|' -f3)
            if [[ "$duration" =~ ^[0-9]+$ ]]; then
                total_duration=$((total_duration + duration))
                video_count=$((video_count + 1))
            fi
        fi
    done < "$playlist_file"
    
    echo "$video_count|$total_duration"
    return 0
}
