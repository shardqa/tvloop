#!/bin/bash

# YouTube Channel Creator for tvloop (yt-dlp version)
# Creates a 24-hour channel from a YouTube channel without API keys

CHANNEL_NAME="${1:-youtube_channel}"
YOUTUBE_CHANNEL="${2:-}"
TARGET_HOURS="${3:-24}"
AUTO_START="${4:-false}"
QUALITY="${5:-232,609}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_ytdlp_playlist.sh"
source "$PROJECT_ROOT/scripts/youtube_channel_usage.sh"

show_usage() {
    show_youtube_channel_usage
}

create_youtube_channel_ytdlp() {
    local channel_name="$1"
    local youtube_channel="$2"
    local target_hours="$3"
    local auto_start="$4"
    
    local channel_dir="channels/${channel_name}"
    
    echo "🎬 Creating YouTube channel: $channel_name"
    echo "📺 YouTube source: $youtube_channel"
    echo "⏱️  Target duration: ${target_hours}h"
    echo "🔧 Using yt-dlp (no API key required)"
    echo ""
    
    # Step 1: Check if yt-dlp is available
    if ! check_ytdlp; then
        return 1
    fi
    
    # Step 2: Create channel directory
    echo "📂 Creating channel directory..."
    mkdir -p "$channel_dir"
    
    # Step 3: Create playlist from YouTube channel using yt-dlp
    echo "📋 Creating playlist from YouTube channel..."
    echo "🎥 Quality setting: $QUALITY"
    create_channel_playlist_ytdlp "$youtube_channel" "$channel_dir/playlist.txt" "$target_hours" "100" "$QUALITY"
    
    if [[ $? -ne 0 ]]; then
        log "ERROR: Failed to create playlist from YouTube channel"
        return 1
    fi
    
    # Step 4: Show playlist info
    echo ""
    echo "📊 Playlist created successfully!"
    ./scripts/playlist_manager.sh "$channel_dir/playlist.txt" info
    
    # Step 5: Initialize channel
    echo ""
    echo "🎯 Initializing channel..."
    ./scripts/channel_tracker.sh "$channel_dir" init
    
    if [[ $? -ne 0 ]]; then
        log "ERROR: Failed to initialize channel"
        return 1
    fi
    
    # Step 6: Show channel status
    echo ""
    echo "📺 Channel Status:"
    ./scripts/channel_tracker.sh "$channel_dir" status
    
    # Step 7: Auto-start if requested
    if [[ "$auto_start" == "true" ]]; then
        echo ""
        echo "▶️  Starting playback..."
        ./scripts/channel_player.sh "$channel_dir" tune mpv
    else
        echo ""
        echo "✅ YouTube channel created successfully!"
        echo ""
        echo "To start playing, run:"
        echo "  ./scripts/channel_player.sh $channel_dir tune mpv"
        echo ""
        echo "To check status, run:"
        echo "  ./scripts/channel_tracker.sh $channel_dir status"
        echo ""
        echo "To refresh playlist, run:"
        echo "  ./scripts/create_youtube_channel_ytdlp.sh $channel_name $youtube_channel $target_hours"
    fi
}

# Main execution
if [[ $# -lt 2 ]]; then
    show_usage
    exit 1
fi

create_youtube_channel_ytdlp "$CHANNEL_NAME" "$YOUTUBE_CHANNEL" "$TARGET_HOURS" "$AUTO_START"
