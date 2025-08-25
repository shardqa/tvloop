#!/bin/bash

# tvloop command removal functionality
# Channel removal commands

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/channel_state.sh"
source "$PROJECT_ROOT/core/playlist_parser.sh"
source "$PROJECT_ROOT/core/time_utils.sh"
source "$PROJECT_ROOT/core/tvloop_channels.sh"

# Remove a channel
remove_channel() {
    local channel_name="$1"
    
    # Validate required parameters
    if [[ -z "$channel_name" ]]; then
        echo "Usage: $0 remove <channel_name>"
        echo ""
        echo "Examples:"
        echo "  $0 remove my_channel"
        echo "  $0 remove youtube_channel"
        return 1
    fi
    
    # Validate channel exists
    local channels_dir=$(get_channels_dir)
    local channel_dir="$channels_dir/$channel_name"
    if [[ ! -d "$channel_dir" ]]; then
        echo "Channel '$channel_name' not found"
        return 1
    fi
    
    # Stop any running players for this channel
    echo "🛑 Stopping any running players for channel: $channel_name"
    "$PROJECT_ROOT/scripts/channel_player.sh" "$channel_dir" stop 2>/dev/null || true
    
    # Remove the channel directory
    echo "🗑️  Removing channel: $channel_name"
    rm -rf "$channel_dir"
    
    echo "✅ Channel '$channel_name' removed successfully"
}
