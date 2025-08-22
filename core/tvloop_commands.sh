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
        mpv)
            ;;
        *)
            echo "Unsupported player: $player"
            echo "Supported players: mpv"
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

# Create a new channel
create_channel() {
    local channel_type="$1"
    local channel_name="$2"
    local source="$3"
    local hours="$4"
    local force_flag="$5"
    
    # Validate required parameters
    if [[ -z "$channel_type" || -z "$channel_name" ]]; then
        echo "Usage: $0 create <type> <name> [source] [hours]"
        echo ""
        echo "Channel types:"
        echo "  youtube <name> <url> [hours] - Create YouTube channel (default: 24h)"
        echo ""
        echo "Examples:"
        echo "  $0 create youtube jovem_nerd https://www.youtube.com/@JovemNerd 2"
        echo "  $0 create youtube tech_channel @JovemNerd"
        return 1
    fi
    
    # Check if channel already exists
    local channels_dir=$(get_channels_dir)
    local channel_dir="$channels_dir/$channel_name"
    if [[ -d "$channel_dir" ]]; then
        if [[ "$force_flag" == "--force" ]]; then
            echo "Channel '$channel_name' already exists, recreating..."
            rm -rf "$channel_dir"
        else
            echo "Channel '$channel_name' already exists"
            return 1
        fi
    fi
    
    # Create channel based on type
    case "$channel_type" in
        youtube)
            create_youtube_channel "$channel_name" "$source" "${hours:-24}"
            ;;
        *)
            echo "Unsupported channel type: $channel_type"
            echo "Supported types: youtube"
            return 1
            ;;
    esac
}

# Create YouTube channel using yt-dlp
create_youtube_channel() {
    local channel_name="$1"
    local youtube_url="$2"
    local hours="$3"
    
    # Validate parameters
    if [[ -z "$youtube_url" ]]; then
        echo "YouTube URL is required"
        return 1
    fi
    
    # Use the existing yt-dlp script
    "$PROJECT_ROOT/scripts/create_youtube_channel_ytdlp.sh" "$channel_name" "$youtube_url" "$hours"
}

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
