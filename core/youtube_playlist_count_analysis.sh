#!/bin/bash

# YouTube Playlist Count Analysis Module
# Handles playlist analysis and statistics with optimized helpers

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

validate_playlist_file() {
    local playlist_file="$1"
    if [[ ! -f "$playlist_file" ]]; then
        echo "ERROR: Playlist file does not exist"
        return 1
    fi
    return 0
}

count_playlist_videos() {
    local playlist_file="$1"
    
    if ! validate_playlist_file "$playlist_file"; then
        echo "0"
        return 1
    fi
    
    local count=0
    while IFS= read -r line; do
        if [[ "$line" =~ ^youtube://[^|]+\|[^|]+\|[0-9]+$ ]]; then
            count=$((count + 1))
        fi
    done < "$playlist_file"
    
    echo "$count"
    return 0
}

check_count_target() {
    local playlist_file="$1"
    local target_count="$2"
    
    local actual_count=$(count_playlist_videos "$playlist_file")
    
    if [[ $actual_count -ge $target_count ]]; then
        echo "✅ Count target met: $actual_count >= $target_count videos"
        return 0
    else
        echo "⚠️  Count target not met: $actual_count < $target_count videos"
        return 1
    fi
}

validate_playlist_count() {
    local playlist_file="$1"
    local expected_count="$2"
    
    if ! validate_playlist_file "$playlist_file"; then
        return 1
    fi
    
    local actual_count=$(count_playlist_videos "$playlist_file")
    
    if [[ $actual_count -eq $expected_count ]]; then
        echo "✅ Playlist count validation passed: $actual_count videos"
        return 0
    else
        echo "❌ Playlist count validation failed: expected $expected_count, got $actual_count"
        return 1
    fi
}
