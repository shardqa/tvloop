#!/bin/bash

# YouTube yt-dlp Playlist Creator
# Functions for creating playlists from channels

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_core.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_utils.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_playlist_builder.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_playlist_shuffle.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_playlist_fetcher.sh"

# Create playlist from channel using yt-dlp
create_channel_playlist_ytdlp() {
    local channel_input="$1"
    local playlist_file="$2"
    local target_hours="${3:-24}"
    local max_videos="${4:-100}"
    local quality="${5:-232,609}"  # Default to 720p
    
    local target_seconds=$((target_hours * 3600))
    
    echo "🎬 Creating $target_hours-hour playlist from channel: $channel_input"
    echo "📊 Target duration: ${target_hours}h (${target_seconds}s)"
    echo "🔧 Using yt-dlp (no API key required)"
    echo ""
    
    if ! check_ytdlp; then
        return 1
    fi
    
    # Get channel uploads URL
    local uploads_url=$(get_channel_uploads_url "$channel_input")
    echo "📺 Channel URL: $uploads_url"
    echo ""
    
    # Get playlist videos
    echo "📋 Fetching videos from channel..."
    local video_urls=$(get_playlist_videos_ytdlp "$uploads_url" "$max_videos")
    
    if [[ $? -ne 0 || -z "$video_urls" ]]; then
        log "ERROR: Could not fetch videos from channel"
        return 1
    fi
    
    local video_count=$(echo "$video_urls" | wc -l)
    echo "✅ Found $video_count videos"
    echo ""
    
    # Build playlist using the builder module
    local build_result=$(build_playlist_from_urls "$video_urls" "$playlist_file" "$target_seconds" "$quality")
    local playlist_duration=$(echo "$build_result" | cut -d'|' -f1)
    local added_count=$(echo "$build_result" | cut -d'|' -f2)
    
    # Validate the result
    if [[ ! "$playlist_duration" =~ ^[0-9]+$ ]] || [[ ! "$added_count" =~ ^[0-9]+$ ]]; then
        log "ERROR: Invalid build result: $build_result"
        return 1
    fi
    
    echo ""
    echo "🎉 Playlist created successfully!"
    echo "📊 Videos added: $added_count"
    echo "⏱️  Total duration: ${playlist_duration}s ($(date -u -d @$playlist_duration '+%H:%M:%S'))"
    echo "📁 Playlist file: $playlist_file"
    
    # Shuffle the playlist for TV-like randomness
    shuffle_playlist "$playlist_file"
    
    if [[ $playlist_duration -lt $target_seconds ]]; then
        echo "⚠️  Note: Could only reach ${playlist_duration}s (${target_hours}h target)"
    fi
}
