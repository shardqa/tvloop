#!/bin/bash

# YouTube API Core Functions for tvloop
# Handles core API configuration and basic functions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# YouTube API configuration
YOUTUBE_API_KEY="${YOUTUBE_API_KEY:-}"
YOUTUBE_API_BASE_URL="https://www.googleapis.com/youtube/v3"

# Check if YouTube API key is configured
check_youtube_api_key() {
    if [[ -z "$YOUTUBE_API_KEY" ]]; then
        log "ERROR: YouTube API key not configured. Set YOUTUBE_API_KEY environment variable."
        return 1
    fi
    return 0
}

# Make YouTube API request
youtube_api_request() {
    local endpoint="$1"
    local params="$2"
    
    if ! check_youtube_api_key; then
        return 1
    fi
    
    local url="$YOUTUBE_API_BASE_URL/$endpoint?key=$YOUTUBE_API_KEY&$params"
    
    log "Making YouTube API request: $endpoint"
    
    # Use curl to make the request
    local response
    if command -v curl >/dev/null 2>&1; then
        response=$(curl -s "$url")
    elif command -v wget >/dev/null 2>&1; then
        response=$(wget -qO- "$url")
    else
        log "ERROR: Neither curl nor wget found. Cannot make API request."
        return 1
    fi
    
    # Check for API errors
    if echo "$response" | jq -e '.error' >/dev/null 2>&1; then
        local error_message=$(echo "$response" | jq -r '.error.message // "Unknown error"')
        log "ERROR: YouTube API error: $error_message"
        return 1
    fi
    
    echo "$response"
}
