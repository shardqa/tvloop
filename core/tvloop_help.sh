#!/bin/bash

# tvloop help and usage functionality

show_usage() {
    local script_name="${1:-tvloop}"
    local channels_dir="${2:-$PROJECT_ROOT/channels}"
    
    echo "🎬 tvloop - 24-Hour Video Channel System"
    echo ""
    echo "Usage: $script_name <command> [options]"
    echo ""
    echo "Commands:"
    echo "  tune <player> [channel]  - Tune in to a channel"
    echo "                             player: mpv, vlc"
    echo "                             channel: optional, uses first available if not specified"
    echo "  status [channel]         - Show channel status"
    echo "                             channel: optional, shows first channel if not specified"
    echo "  list                     - List all available channels"
    echo "  help                     - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $script_name tune mpv              - Tune in to first channel with mpv"
    echo "  $script_name tune vlc my_channel   - Tune in to 'my_channel' with vlc"
    echo "  $script_name status                - Show status of first channel"
    echo "  $script_name list                  - List all channels"
    echo ""
    echo "Channel Directory: $channels_dir"
}
