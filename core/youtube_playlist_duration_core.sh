#!/bin/bash

# YouTube Playlist Duration Core Module
# Core duration-based playlist creation functions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_video.sh"
source "$PROJECT_ROOT/core/youtube_channel_resolver.sh"
source "$PROJECT_ROOT/core/youtube_channel_info.sh"
source "$PROJECT_ROOT/core/youtube_channel_videos.sh"
source "$PROJECT_ROOT/core/logging.sh"

create_24h_channel_playlist() {
    local channel_input="$1"
    local playlist_file="$2"
    local target_hours="${3:-24}"
    local max_videos="${4:-200}"
    
    local target_seconds=$((target_hours * 3600))
    
    echo "🎬 Creating $target_hours-hour playlist from: $channel_input"
    
    local channel_id=$(get_channel_id "$channel_input") || return 1
    local channel_info=$(get_channel_info "$channel_id") || return 1
    local channel_title=$(echo "$channel_info" | cut -d'|' -f1)
    echo "📺 $channel_title → ${target_hours}h (${target_seconds}s)"
    local all_videos=$(get_all_channel_videos "$channel_id" "$max_videos")
    
    if [[ -z "$all_videos" ]]; then
        log "ERROR: No videos found in channel"
        return 1
    fi
    
    echo "📋 Found $(echo "$all_videos" | wc -l) videos"
    
    create_duration_based_playlist "$all_videos" "$playlist_file" "$target_seconds"
}

create_duration_playlist() {
    local channel_input="$1"
    local playlist_file="$2"
    local target_duration="$3"
    local max_videos="${4:-200}"
    
    local target_hours=$((target_duration / 3600))
    create_24h_channel_playlist "$channel_input" "$playlist_file" "$target_hours" "$max_videos"
}

create_duration_based_playlist() {
    local all_videos="$1"
    local playlist_file="$2"
    local target_seconds="$3"
    
    > "$playlist_file"
    local playlist_duration=0
    local added_count=0
    
    echo "🎯 Building playlist..."
    
    while IFS='|' read -r video_id title; do
        [[ -z "$video_id" || -z "$title" ]] && continue
        
        local video_details=$(get_video_details "$video_id")
        if [[ $? -ne 0 ]]; then
            echo "⚠️  Skipping: $title (no details)"
            continue
        fi
        
        local duration=$(echo "$video_details" | cut -d'|' -f2)
        if [[ -z "$duration" || "$duration" == "0" ]]; then
            echo "⚠️  Skipping: $title (no duration)"
            continue
        fi
        
        local new_duration=$((playlist_duration + duration))
        if [[ $new_duration -gt $target_seconds ]]; then
            echo "⏹️  Target reached (${playlist_duration}s)"
            break
        fi
        
        echo "youtube://$video_id|$title|$duration" >> "$playlist_file"
        playlist_duration=$new_duration
        added_count=$((added_count + 1))
        
        echo "✅ Added: $title (${duration}s) - Total: ${playlist_duration}s"
    done <<< "$all_videos"
    
    echo ""
    echo "🎉 Created: $added_count videos, ${playlist_duration}s total"
    echo "📁 File: $playlist_file"
    
    if [[ $playlist_duration -lt $target_seconds ]]; then
        local target_hours=$((target_seconds / 3600))
        echo "⚠️  Only reached ${playlist_duration}s (${target_hours}h target)"
    fi
    
    return 0
}
