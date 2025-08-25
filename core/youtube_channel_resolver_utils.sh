#!/bin/bash

# YouTube Channel Resolver Utils Module
# Handles utility functions for channel resolution

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Extract username from @username format
extract_username() {
    local input="$1"
    
    if [[ "$input" =~ ^@([a-zA-Z0-9_-]+)$ ]]; then
        echo "${BASH_REMATCH[1]}"
        return 0
    fi
    
    return 1
}

# Extract channel ID from channel URL
extract_channel_id_from_url() {
    local url="$1"
    
    if [[ "$url" =~ /channel/([a-zA-Z0-9_-]+) ]]; then
        echo "${BASH_REMATCH[1]}"
        return 0
    fi
    
    return 1
}

# Search for channel by username
search_channel_by_username() {
    local username="$1"
    
    local response=$(youtube_api_request "search" "part=snippet&type=channel&q=$username&maxResults=1")
    
    if [[ $? -eq 0 ]]; then
        local channel_id=$(echo "$response" | jq -r '.items[0].id.channelId // empty')
        if [[ -n "$channel_id" ]]; then
            echo "$channel_id"
            return 0
        fi
    fi
    
    log "ERROR: Could not find channel for username: $username"
    return 1
}
