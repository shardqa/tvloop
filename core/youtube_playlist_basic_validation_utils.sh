#!/bin/bash

# YouTube Playlist Basic Validation Utils Module
# Handles utility functions for playlist validation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Check if playlist has any valid entries
has_valid_entries() {
    local playlist_file="$1"
    
    local count=$(count_valid_entries "$playlist_file")
    
    if [[ $count -gt 0 ]]; then
        return 0
    else
        log "ERROR: No valid entries found in playlist file: $playlist_file"
        return 1
    fi
}

# Get playlist file size
get_playlist_file_size() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file not found: $playlist_file"
        echo "0"
        return 1
    fi
    
    stat -c%s "$playlist_file" 2>/dev/null || stat -f%z "$playlist_file" 2>/dev/null || echo "0"
    return 0
}

# Check if playlist file is empty
is_playlist_empty() {
    local playlist_file="$1"
    
    local size=$(get_playlist_file_size "$playlist_file")
    
    if [[ $size -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}
