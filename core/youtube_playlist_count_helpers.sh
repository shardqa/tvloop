#!/bin/bash

# YouTube Playlist Count Helpers Module
# Helper functions for video processing and channel resolution

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_video.sh"
source "$PROJECT_ROOT/core/youtube_channel_resolver.sh"
source "$PROJECT_ROOT/core/youtube_channel_videos.sh"
source "$PROJECT_ROOT/core/logging.sh"

resolve_channel_id() {
    local channel_input="$1"
    local channel_id=$(get_channel_id "$channel_input")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    echo "$channel_id"
    return 0
}

process_video_with_details() {
    local video_id="$1"
    local title="$2"
    
    local video_details=$(get_video_details "$video_id")
    if [[ $? -ne 0 ]]; then
        echo "⚠️  Skipping: $title (could not get details)" >&2
        return 1
    fi
    
    local duration=$(echo "$video_details" | cut -d'|' -f2)
    if [[ -z "$duration" || "$duration" == "0" ]]; then
        echo "⚠️  Skipping: $title (no duration)" >&2
        return 1
    fi
    
    echo "youtube://$video_id|$title|$duration"
    return 0
}

get_channel_videos_for_count() {
    local channel_id="$1"
    local video_count="$2"
    local video_type="${3:-all}"
    
    case "$video_type" in
        "recent")
            get_recent_channel_videos "$channel_id" "$video_count"
            ;;
        "range")
            local start_index="$4"
            local end_index="$5"
            local max_videos=$((end_index + 10))
            local all_videos=$(get_all_channel_videos "$channel_id" "$max_videos")
            echo "$all_videos" | sed -n "${start_index},${end_index}p"
            ;;
        *)
            get_all_channel_videos "$channel_id" "$video_count"
            ;;
    esac
}

