#!/bin/bash

# YouTube Playlist Basic Validation Core Module
# Handles main playlist validation logic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Validate playlist file (basic)
validate_playlist_file() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    local valid_lines=$(count_valid_entries "$playlist_file")
    
    if [[ $valid_lines -eq 0 ]]; then
        log "ERROR: No valid entries in playlist file"
        return 1
    fi
    
    echo "✅ Playlist validation passed: $valid_lines valid entries"
    return 0
}

# Check if playlist file exists and is readable
check_playlist_file_exists() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "❌ File does not exist: $playlist_file"
        return 1
    fi
    
    if [[ ! -r "$playlist_file" ]]; then
        echo "❌ File is not readable: $playlist_file"
        return 1
    fi
    
    echo "✅ File exists and is readable: $playlist_file"
    return 0
}

# Count valid entries in playlist
count_valid_entries() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "0"
        return 1
    fi
    
    local valid_count=0
    
    while IFS='|' read -r video_id title duration; do
        if [[ -n "$video_id" && -n "$title" && -n "$duration" ]]; then
            if [[ "$duration" =~ ^[0-9]+$ ]]; then
                valid_count=$((valid_count + 1))
            fi
        fi
    done < "$playlist_file"
    
    echo "$valid_count"
    return 0
}
