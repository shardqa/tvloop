#!/bin/bash

# YouTube Playlist Count Creation Core Module
# Handles main video-count-based playlist creation logic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_count_helpers.sh"

create_video_count_playlist() {
    local channel_input="$1"
    local playlist_file="$2"
    local video_count="$3"
    
    echo "🎬 Creating playlist with $video_count videos from channel: $channel_input"
    echo ""
    
    local channel_id=$(resolve_channel_id "$channel_input") || return 1
    local all_videos=$(get_channel_videos_for_count "$channel_id" "$video_count" "all")
    if [[ -z "$all_videos" ]]; then
        log "ERROR: No videos found in channel"
        return 1
    fi
    
    create_count_based_playlist "$all_videos" "$playlist_file" "$video_count"
}

create_count_based_playlist() {
    local all_videos="$1"
    local playlist_file="$2"
    local target_count="$3"
    
    > "$playlist_file"
    local added_count=0
    
    echo "🎯 Building playlist..."
    
    while IFS='|' read -r video_id title; do
        if [[ -z "$video_id" || -z "$title" ]]; then
            continue
        fi
        
        if [[ $added_count -ge $target_count ]]; then
            break
        fi
        
        local video_entry=$(process_video_with_details "$video_id" "$title")
        if [[ $? -eq 0 ]]; then
            echo "$video_entry" >> "$playlist_file"
            added_count=$((added_count + 1))
            local duration=$(echo "$video_entry" | cut -d'|' -f3)
            echo "✅ Added: $title (${duration}s) - Count: $added_count/$target_count"
        fi
    done <<< "$all_videos"
    
    echo ""
    echo "🎉 Playlist created successfully!"
    echo "📊 Videos added: $added_count"
    echo "📁 Playlist file: $playlist_file"
    
    return 0
}
