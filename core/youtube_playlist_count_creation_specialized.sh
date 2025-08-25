#!/bin/bash

# YouTube Playlist Count Creation Specialized Module
# Handles specialized playlist creation functions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_count_helpers.sh"

create_recent_videos_playlist() {
    local channel_input="$1"
    local playlist_file="$2"
    local video_count="${3:-10}"
    
    echo "🎬 Creating playlist with $video_count most recent videos from channel: $channel_input"
    echo ""
    
    local channel_id=$(resolve_channel_id "$channel_input") || return 1
    local recent_videos=$(get_channel_videos_for_count "$channel_id" "$video_count" "recent")
    if [[ -z "$recent_videos" ]]; then
        log "ERROR: No recent videos found in channel"
        return 1
    fi
    
    create_count_based_playlist "$recent_videos" "$playlist_file" "$video_count"
}

create_video_range_playlist() {
    local channel_input="$1"
    local playlist_file="$2"
    local start_index="$3"
    local end_index="$4"
    
    local video_count=$((end_index - start_index + 1))
    
    echo "🎬 Creating playlist with videos $start_index-$end_index from channel: $channel_input"
    echo ""
    
    local channel_id=$(resolve_channel_id "$channel_input") || return 1
    local ranged_videos=$(get_channel_videos_for_count "$channel_id" "$video_count" "range" "$start_index" "$end_index")
    if [[ -z "$ranged_videos" ]]; then
        log "ERROR: No videos found in channel"
        return 1
    fi
    create_count_based_playlist "$ranged_videos" "$playlist_file" "$video_count"
}
