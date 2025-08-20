#!/bin/bash

# YouTube Player for tvloop
# Core utilities and orchestration for YouTube video playback

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Source the split modules
source "$PROJECT_ROOT/players/youtube_player_mpv.sh"
source "$PROJECT_ROOT/players/youtube_player_vlc.sh"
source "$PROJECT_ROOT/players/youtube_player_control.sh"

# Check if yt-dlp is available
check_yt_dlp() {
    if ! command -v yt-dlp >/dev/null 2>&1; then
        log "ERROR: yt-dlp not found. Please install yt-dlp for YouTube playback."
        log "Install with: pip install yt-dlp"
        return 1
    fi
    return 0
}

# Extract video ID from YouTube URL
extract_video_id() {
    local url="$1"
    local video_id=""
    
    # Handle various YouTube URL formats
    if [[ "$url" =~ youtube\.com/watch\?v=([a-zA-Z0-9_-]+) ]]; then
        video_id="${BASH_REMATCH[1]}"
    elif [[ "$url" =~ youtu\.be/([a-zA-Z0-9_-]+) ]]; then
        video_id="${BASH_REMATCH[1]}"
    elif [[ "$url" =~ youtube\.com/embed/([a-zA-Z0-9_-]+) ]]; then
        video_id="${BASH_REMATCH[1]}"
    fi
    
    echo "$video_id"
}

# Main function to launch YouTube video
launch_youtube() {
    local video_path="$1"
    local start_position="$2"
    local channel_dir="$3"
    local player_type="${4:-mpv}"
    
    # Extract video ID from youtube:// format
    local video_id=""
    if [[ "$video_path" == youtube://* ]]; then
        video_id="${video_path#youtube://}"
    else
        # Try to extract from URL
        video_id=$(extract_video_id "$video_path")
    fi
    
    if [[ -z "$video_id" ]]; then
        log "ERROR: Could not extract video ID from: $video_path"
        return 1
    fi
    
    case "$player_type" in
        "mpv")
            launch_youtube_mpv "$video_id" "$start_position" "$channel_dir"
            ;;
        "vlc")
            launch_youtube_vlc "$video_id" "$start_position" "$channel_dir"
            ;;
        *)
            log "ERROR: Unsupported player type: $player_type"
            return 1
            ;;
    esac
}
