#!/bin/bash

# tvloop command functionality
# Tune and status commands

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/channel_state.sh"
source "$PROJECT_ROOT/core/playlist_parser.sh"
source "$PROJECT_ROOT/core/time_utils.sh"
source "$PROJECT_ROOT/core/tvloop_channels.sh"

# Tune in to a channel
tune_channel() {
    local player="$1"
    local channel_name="$2"
    
    # Validate player
    case "$player" in
        mpv|vlc)
            ;;
        *)
            echo "Unsupported player: $player"
            echo "Supported players: mpv, vlc"
            return 1
            ;;
    esac
    
    # Find channel if not specified
    if [[ -z "$channel_name" ]]; then
        channel_name=$(find_first_channel)
        if [[ $? -ne 0 ]]; then
            echo "No channels found"
            return 1
        fi
        echo "Found channel: $channel_name"
    fi
    
    # Validate channel
    local channel_dir
    channel_dir=$(validate_channel "$channel_name")
    if [[ $? -ne 0 ]]; then
        echo "$channel_dir"
        return 1
    fi
    
    # Start playback
    echo "Starting playback for channel: $channel_name"
    "$PROJECT_ROOT/scripts/channel_player.sh" "$channel_dir" tune "$player"
}

# Show channel status
show_status() {
    local channel_name="$1"
    
    # Find channel if not specified
    if [[ -z "$channel_name" ]]; then
        channel_name=$(find_first_channel)
        if [[ $? -ne 0 ]]; then
            echo "No channels found"
            return 1
        fi
        echo "Channel: $channel_name"
    fi
    
    # Validate channel
    local channel_dir
    channel_dir=$(validate_channel "$channel_name")
    if [[ $? -ne 0 ]]; then
        echo "$channel_dir"
        return 1
    fi
    
    # Show status
    "$PROJECT_ROOT/scripts/channel_tracker.sh" "$channel_dir" status
}
