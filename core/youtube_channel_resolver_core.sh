#!/bin/bash

# YouTube Channel Resolver Core Module
# Handles main channel ID resolution logic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Get channel ID from channel URL or username
get_channel_id() {
    local channel_input="$1"
    
    # If it's already a channel ID (starts with UC)
    if [[ "$channel_input" =~ ^UC[a-zA-Z0-9_-]+$ ]]; then
        echo "$channel_input"
        return 0
    fi
    
    # If it's a channel URL, extract the channel ID
    if [[ "$channel_input" =~ /channel/([a-zA-Z0-9_-]+) ]]; then
        echo "${BASH_REMATCH[1]}"
        return 0
    fi
    
    # If it's a custom URL (@username), search for the channel
    if [[ "$channel_input" =~ ^@([a-zA-Z0-9_-]+)$ ]]; then
        local username="${BASH_REMATCH[1]}"
        local response=$(youtube_api_request "search" "part=snippet&type=channel&q=$username&maxResults=1")
        
        if [[ $? -eq 0 ]]; then
            local channel_id=$(echo "$response" | jq -r '.items[0].id.channelId // empty')
            if [[ -n "$channel_id" ]]; then
                echo "$channel_id"
                return 0
            fi
        fi
    fi
    
    # If it's a username without @, try searching
    if [[ "$channel_input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        local response=$(youtube_api_request "search" "part=snippet&type=channel&q=$channel_input&maxResults=1")
        
        if [[ $? -eq 0 ]]; then
            local channel_id=$(echo "$response" | jq -r '.items[0].id.channelId // empty')
            if [[ -n "$channel_id" ]]; then
                echo "$channel_id"
                return 0
            fi
        fi
    fi
    
    log "ERROR: Could not resolve channel ID from: $channel_input"
    return 1
}

# Validate if a string is a valid channel ID
is_valid_channel_id() {
    local channel_id="$1"
    
    if [[ "$channel_id" =~ ^UC[a-zA-Z0-9_-]+$ ]]; then
        return 0
    else
        return 1
    fi
}
