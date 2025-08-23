#!/bin/bash

# YouTube Playlist Repair Cleanup Module
# Cleanup functions for playlist files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

clean_empty_lines() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    local original_count=0
    local cleaned_count=0
    local temp_file=$(mktemp)
    
    while IFS= read -r line; do
        original_count=$((original_count + 1))
        if [[ -n "$line" ]]; then
            echo "$line" >> "$temp_file"
            cleaned_count=$((cleaned_count + 1))
        fi
    done < "$playlist_file"
    
    mv "$temp_file" "$playlist_file"
    
    local removed_count=$((original_count - cleaned_count))
    echo "🧹 Empty line cleanup completed: $original_count → $cleaned_count lines"
    
    return 0
}

sort_playlist() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    local temp_file=$(mktemp)
    sort "$playlist_file" > "$temp_file"
    mv "$temp_file" "$playlist_file"
    
    echo "📋 Playlist sorted by video ID"
    return 0
}


