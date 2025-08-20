#!/bin/bash

# Automated Channel Creator for tvloop
# Creates a new channel from a media folder automatically

CHANNEL_NAME="${1:-new_channel}"
MEDIA_FOLDER="${2:-}"
AUTO_START="${3:-false}"
MAX_SIZE_MB="${4:-0}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

show_usage() {
    echo "🎬 Automated Channel Creator for tvloop"
    echo ""
    echo "Usage: $0 <channel_name> <media_folder> [auto_start] [max_size_mb]"
    echo ""
    echo "Parameters:"
    echo "  channel_name  - Name for the new channel (e.g., 'movies', 'tv_shows')"
    echo "  media_folder  - Path to folder containing video files"
    echo "  auto_start    - 'true' to start playing immediately (optional)"
    echo "  max_size_mb   - Maximum file size in MB (0 = no limit, optional)"
    echo ""
    echo "Examples:"
    echo "  $0 movies /home/user/Videos/Movies"
    echo "  $0 tv_shows /mnt/data/Emby true"
    echo "  $0 anime /path/to/anime/folder"
    echo "  $0 small_videos /mnt/data/Emby false 500"
    echo ""
    echo "This script will:"
    echo "  1. Create channel directory"
    echo "  2. Scan media folder for videos"
    echo "  3. Create playlist automatically (with size filtering)"
    echo "  4. Initialize channel"
    echo "  5. Start playing (if auto_start=true)"
}

create_channel() {
    local channel_name="$1"
    local media_folder="$2"
    local auto_start="$3"
    local max_size_mb="$4"
    
    local channel_dir="channels/${channel_name}"
    
    echo "🎬 Creating channel: $channel_name"
    echo "📁 Media folder: $media_folder"
    echo ""
    
    # Step 1: Check if media folder exists
    if [[ ! -d "$media_folder" ]]; then
        log "ERROR: Media folder not found: $media_folder"
        echo "Please check the path and try again."
        return 1
    fi
    
    # Step 2: Create channel directory
    echo "📂 Creating channel directory..."
    mkdir -p "$channel_dir"
    
    # Step 3: Create playlist from media folder
    echo "📋 Creating playlist from media folder..."
    if [[ $max_size_mb -gt 0 ]]; then
        echo "📏 File size limit: ${max_size_mb}MB"
        ./scripts/playlist_manager.sh "$channel_dir/playlist.txt" "$media_folder" create "mp4,mkv,avi" "$max_size_mb"
    else
        ./scripts/playlist_manager.sh "$channel_dir/playlist.txt" "$media_folder" create
    fi
    
    if [[ $? -ne 0 ]]; then
        log "ERROR: Failed to create playlist"
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
        echo "✅ Channel created successfully!"
        echo ""
        echo "To start playing, run:"
        echo "  ./scripts/channel_player.sh $channel_dir tune mpv"
        echo ""
        echo "To check status, run:"
        echo "  ./scripts/channel_tracker.sh $channel_dir status"
    fi
}

# Main execution
if [[ $# -lt 2 ]]; then
    show_usage
    exit 1
fi

create_channel "$CHANNEL_NAME" "$MEDIA_FOLDER" "$AUTO_START" "$MAX_SIZE_MB"
