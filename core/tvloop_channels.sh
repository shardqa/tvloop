#!/bin/bash

# tvloop channel management functionality
# Channel discovery, validation, and listing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/logging.sh"

# Get channels directory dynamically
get_channels_dir() {
    echo "${TVLOOP_CHANNELS_DIR:-$PROJECT_ROOT/channels}"
}

# Find the first available channel
find_first_channel() {
    local channels_dir=$(get_channels_dir)
    
    if [[ ! -d "$channels_dir" ]]; then
        return 1
    fi
    
    # Find first directory in channels folder
    local first_channel
    first_channel=$(find "$channels_dir" -maxdepth 1 -type d -name "*" | grep -v "^$channels_dir$" | head -n 1)
    
    if [[ -z "$first_channel" ]]; then
        return 1
    fi
    
    # Return just the channel name (not full path)
    basename "$first_channel"
}

# List all available channels
list_channels() {
    local channels_dir=$(get_channels_dir)
    
    if [[ ! -d "$channels_dir" ]]; then
        echo "No channels directory found: $channels_dir"
        return 1
    fi
    
    local channels
    channels=$(find "$channels_dir" -maxdepth 1 -type d -name "*" | grep -v "^$channels_dir$" | sort)
    
    if [[ -z "$channels" ]]; then
        echo "No channels found in: $channels_dir"
        return 1
    fi
    
    echo "Available channels:"
    while IFS= read -r channel; do
        local channel_name=$(basename "$channel")
        local state_file="$channel/state.json"
        
        if [[ -f "$state_file" ]]; then
            echo "  ✓ $channel_name (initialized)"
        else
            echo "  ○ $channel_name (not initialized)"
        fi
    done <<< "$channels"
}

# Validate channel exists
validate_channel() {
    local channel_name="$1"
    local channels_dir=$(get_channels_dir)
    local channel_dir="$channels_dir/$channel_name"
    
    if [[ ! -d "$channel_dir" ]]; then
        echo "Channel not found: $channel_name"
        return 1
    fi
    
    if [[ ! -f "$channel_dir/state.json" ]]; then
        echo "Channel not initialized: $channel_name"
        return 1
    fi
    
    echo "$channel_dir"
}
