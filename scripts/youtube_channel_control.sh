#!/bin/bash

# YouTube Channel Control for tvloop
# Handles YouTube channel control operations (stop, status)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/players/player_utils.sh"
source "$PROJECT_ROOT/core/channel_state.sh"

# Stop YouTube channel
stop_youtube_channel() {
    local channel_dir="$1"
    
    log "Stopping YouTube channel: $channel_dir"
    
    # Stop all players in this channel
    stop_all_players "$channel_dir"
    
    echo "✅ YouTube channel stopped"
}

# Show channel status
show_youtube_channel_status() {
    local channel_dir="$1"
    
    echo "YouTube Channel Status: $channel_dir"
    echo "=================================="
    echo ""
    
    # Show channel status
    if [[ -f "$channel_dir/state.json" ]]; then
        get_channel_status "$channel_dir"
    else
        echo "Channel not initialized"
    fi
    
    echo ""
    echo "Player Status:"
    echo "-------------"
    show_player_status "$channel_dir"
}
