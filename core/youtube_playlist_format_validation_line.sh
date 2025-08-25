#!/bin/bash

# YouTube Playlist Format Validation Line Module
# Handles individual playlist line validation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Validate playlist line format
validate_playlist_line() {
    local line="$1"
    
    if [[ -z "$line" ]]; then
        log "ERROR: Empty playlist line provided"
        return 1
    fi
    
    # Check if line follows youtube://video_id|title|duration format
    if [[ ! "$line" =~ ^youtube://[^|]+\|[^|]+\|[0-9]+$ ]]; then
        log "ERROR: Invalid playlist line format: $line"
        return 1
    fi
    
    # Parse and validate fields
    local video_id=$(echo "$line" | cut -d'|' -f1 | sed 's/^youtube:\/\///')
    local title=$(echo "$line" | cut -d'|' -f2)
    local duration=$(echo "$line" | cut -d'|' -f3)
    
    if [[ -z "$video_id" || -z "$title" || -z "$duration" ]]; then
        log "ERROR: Missing required fields in playlist line: $line"
        return 1
    fi
    
    if [[ ! "$duration" =~ ^[0-9]+$ ]]; then
        log "ERROR: Invalid duration format in playlist line: $line"
        return 1
    fi
    
    if [[ ! "$video_id" =~ ^[a-zA-Z0-9_-]{11}$ ]]; then
        log "ERROR: Invalid video ID format in playlist line: $line"
        return 1
    fi
    
    return 0
}
