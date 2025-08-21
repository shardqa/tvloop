#!/bin/bash

# YouTube yt-dlp Playlist Builder
# Core playlist building logic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_core.sh"

# Build playlist from video URLs
build_playlist_from_urls() {
    local video_urls="$1"
    local playlist_file="$2"
    local target_seconds="$3"
    local quality="$4"
    
    # Create playlist file with quality setting
    > "$playlist_file"
    echo "# Quality: $quality" > "$playlist_file"
    local playlist_duration=0
    local added_count=0
    local processed_count=0
    local video_count=$(echo "$video_urls" | wc -l)
    
    echo "🎯 Building playlist..." >&2
    
    # Process each video
    while IFS= read -r video_url; do
        if [[ -z "$video_url" ]]; then
            continue
        fi
        
        processed_count=$((processed_count + 1))
        echo "Processing video $processed_count/$video_count..." >&2
        
        # Get video information
        local video_info=$(get_video_info_ytdlp "$video_url")
        if [[ $? -ne 0 ]]; then
            echo "⚠️  Skipping: Could not get video info" >&2
            continue
        fi
        
        local video_id=$(echo "$video_info" | cut -d'|' -f1)
        local title=$(echo "$video_info" | cut -d'|' -f2)
        local duration=$(echo "$video_info" | cut -d'|' -f3)
        
        # Validate duration is a number
        if [[ -z "$duration" || "$duration" == "0" || "$duration" == "null" || ! "$duration" =~ ^[0-9]+$ ]]; then
            echo "⚠️  Skipping: $title (invalid duration: '$duration')" >&2
            continue
        fi
        
        # Check if adding this video would exceed target
        local new_duration=$((playlist_duration + duration))
        if [[ $new_duration -gt $target_seconds ]]; then
            echo "⏹️  Target duration reached (${playlist_duration}s)" >&2
            break
        fi
        
        # Add to playlist
        echo "youtube://$video_id|$title|$duration" >> "$playlist_file"
        playlist_duration=$new_duration
        added_count=$((added_count + 1))
        
        echo "✅ Added: $title (${duration}s) - Total: ${playlist_duration}s" >&2
    done <<< "$video_urls"
    
    echo "${playlist_duration}|${added_count}"
}
