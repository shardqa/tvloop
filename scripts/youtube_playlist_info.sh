#!/bin/bash

# YouTube Playlist Info for tvloop
# Handles playlist information display functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Show playlist information
show_playlist_info() {
    local channel_dir="$1"
    local playlist_file="$2"
    
    if [[ -z "$playlist_file" ]]; then
        playlist_file="$channel_dir/playlist.txt"
    fi
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file not found: $playlist_file"
        return 1
    fi
    
    echo "Playlist Information: $playlist_file"
    echo "=================================="
    echo ""
    
    local video_count=$(wc -l < "$playlist_file")
    local total_duration=0
    local youtube_count=0
    local local_count=0
    
    echo "Videos: $video_count"
    echo ""
    
    # Process each line
    local line_number=1
    while IFS='|' read -r path title duration; do
        if [[ -n "$path" && -n "$title" ]]; then
            echo "$line_number. $title"
            
            # Check if it's a YouTube video
            if [[ "$path" == youtube://* ]]; then
                echo "   📺 YouTube: ${path#youtube://}"
                youtube_count=$((youtube_count + 1))
            else
                echo "   📁 Local: $path"
                local_count=$((local_count + 1))
            fi
            
            if [[ "$duration" =~ ^[0-9]+$ ]]; then
                local hours=$((duration / 3600))
                local minutes=$(((duration % 3600) / 60))
                local seconds=$((duration % 60))
                echo "   ⏱️  Duration: ${hours}h ${minutes}m ${seconds}s"
                total_duration=$((total_duration + duration))
            else
                echo "   ⏱️  Duration: Unknown"
            fi
            echo ""
        fi
        line_number=$((line_number + 1))
    done < "$playlist_file"
    
    # Summary
    local total_hours=$((total_duration / 3600))
    local total_minutes=$(((total_duration % 3600) / 60))
    local total_seconds=$((total_duration % 60))
    
    echo "Summary:"
    echo "  Total Duration: ${total_hours}h ${total_minutes}m ${total_seconds}s"
    echo "  YouTube Videos: $youtube_count"
    echo "  Local Videos: $local_count"
}
