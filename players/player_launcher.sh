#!/bin/bash

# Player Launcher for tvloop
# Handles launching videos (both local and YouTube)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/players/youtube_player.sh"

# Launch video (local file or YouTube)
launch_video() {
    local video_path="$1"
    local start_position="$2"
    local channel_dir="$3"
    local player_type="${4:-mpv}"
    
    # Check if it's a YouTube video
    if [[ "$video_path" == youtube://* ]]; then
        log "Launching YouTube video: $video_path"
        launch_youtube "$video_path" "$start_position" "$channel_dir" "$player_type"
    else
        # Local file - use existing player scripts
        log "Launching local video: $video_path"
        case "$player_type" in
            "mpv")
                source "$PROJECT_ROOT/players/mpv_player.sh"
                launch_mpv "$video_path" "$start_position" "$channel_dir"
                ;;
            *)
                log "ERROR: Unsupported player type: $player_type"
                return 1
                ;;
        esac
    fi
}
