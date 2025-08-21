#!/bin/bash

# Source common functions
source "$(dirname "$0")/../core/common.bash"

CHANNEL_DIR="${1:-channels/channel_1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/players/player_utils.sh"
source "$PROJECT_ROOT/players/mpv_player.sh"
source "$PROJECT_ROOT/players/vlc_player.sh"

tune_in() {
    local player_type="${1:-mpv}"
    
    if [[ ! -f "$CHANNEL_DIR/state.json" ]]; then
        log "ERROR: Channel not initialized. Run: ./scripts/channel_tracker.sh $CHANNEL_DIR init"
        return 1
    fi
    
    # Calculate what should be playing now (on-demand)
    local video_data=$(get_current_video_position "$CHANNEL_DIR")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    IFS='|' read -r video_path start_position duration <<< "$video_data"
    
    if [[ ! -f "$video_path" && ! "$video_path" =~ ^youtube:// ]]; then
        log "ERROR: Video file not found: $video_path"
        return 1
    fi
    
    # Stop any existing players
    stop_all_players "$(dirname "$CHANNEL_DIR")"
    
    # Launch player starting from calculated position
    case "$player_type" in
        "mpv")
            launch_mpv "$video_path" "$start_position" "$CHANNEL_DIR"
            ;;
        "vlc")
            launch_vlc "$video_path" "$start_position" "$CHANNEL_DIR"
            ;;
        *)
            log "ERROR: Unsupported player: $player_type"
            return 1
            ;;
    esac
    
    echo "🎬 Tuned in to channel: $(basename "$video_path")"
    echo "⏱️  Position: ${start_position}s / ${duration}s"
    echo "🎮 Player: $player_type"
    echo "📺 Channel continues playing from calculated position"
}

case "${2:-tune}" in
    "tune")
        tune_in "${3:-mpv}"
        ;;
    "stop")
        stop_player "$CHANNEL_DIR" "mpv"
        stop_player "$CHANNEL_DIR" "vlc"
        log "All players stopped"
        ;;
    "status")
        show_player_status "$CHANNEL_DIR"
        ;;
    *)
        echo "Usage: $0 [channel_dir] [command] [player]"
        echo "Commands:"
        echo "  tune   - Tune in to channel (default)"
        echo "  stop   - Stop all players"
        echo "  status - Show player status"
        echo ""
        echo "Players:"
        echo "  mpv    - Use mpv player (default)"
        echo "  vlc    - Use VLC player"
        echo ""
        echo "Examples:"
        echo "  $0 channels/channel_1 tune mpv"
        echo "  $0 channels/channel_1 tune vlc"
        echo "  $0 channels/channel_1 stop"
        ;;
esac
