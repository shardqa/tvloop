#!/bin/bash

# YouTube Channel Creator for tvloop
# Creates a 24-hour channel from a YouTube channel

CHANNEL_NAME="${1:-youtube_channel}"
YOUTUBE_CHANNEL="${2:-}"
TARGET_HOURS="${3:-24}"
AUTO_START="${4:-false}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_api_channel.sh"

show_usage() {
    echo "🎬 YouTube Channel Creator for tvloop"
    echo ""
    echo "Usage: $0 <channel_name> <youtube_channel> [target_hours] [auto_start]"
    echo ""
    echo "Parameters:"
    echo "  channel_name     - Name for the new channel (e.g., 'jovem_nerd', 'tech_channel')"
    echo "  youtube_channel  - YouTube channel (URL, @username, or channel ID)"
    echo "  target_hours     - Target duration in hours (default: 24)"
    echo "  auto_start       - 'true' to start playing immediately (optional)"
    echo ""
    echo "YouTube Channel Formats:"
    echo "  - Channel URL: https://www.youtube.com/@JovemNerd"
    echo "  - Username: @JovemNerd"
    echo "  - Channel ID: UC..."
    echo ""
    echo "Examples:"
    echo "  $0 jovem_nerd https://www.youtube.com/@JovemNerd"
    echo "  $0 tech_channel @JovemNerd 12"
    echo "  $0 gaming_channel UC1234567890 48 true"
    echo ""
    echo "This script will:"
    echo "  1. Create channel directory"
    echo "  2. Fetch videos from YouTube channel"
    echo "  3. Create 24-hour playlist automatically"
    echo "  4. Initialize channel with timing"
    echo "  5. Start playing (if auto_start=true)"
}

create_youtube_channel() {
    local channel_name="$1"
    local youtube_channel="$2"
    local target_hours="$3"
    local auto_start="$4"
    
    local channel_dir="channels/${channel_name}"
    
    echo "🎬 Creating YouTube channel: $channel_name"
    echo "📺 YouTube source: $youtube_channel"
    echo "⏱️  Target duration: ${target_hours}h"
    echo ""
    
    # Step 1: Check if YouTube API key is configured
    if ! check_youtube_api_key; then
        echo "Please set your YouTube API key:"
        echo "  export YOUTUBE_API_KEY='your_api_key_here'"
        echo ""
        echo "Get an API key from: https://console.cloud.google.com/apis/credentials"
        return 1
    fi
    
    # Step 2: Create channel directory
    echo "📂 Creating channel directory..."
    mkdir -p "$channel_dir"
    
    # Step 3: Create playlist from YouTube channel
    echo "📋 Creating playlist from YouTube channel..."
    create_24h_channel_playlist "$youtube_channel" "$channel_dir/playlist.txt" "$target_hours"
    
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
        echo "  ./scripts/create_youtube_channel.sh $channel_name $youtube_channel $target_hours"
    fi
}

# Main execution
if [[ $# -lt 2 ]]; then
    show_usage
    exit 1
fi

create_youtube_channel "$CHANNEL_NAME" "$YOUTUBE_CHANNEL" "$TARGET_HOURS" "$AUTO_START"
