#!/bin/bash

# YouTube Playlist Format Validation Duplicates Module
# Handles duplicate detection in playlists

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Check for duplicate videos in playlist
check_playlist_duplicates() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "❌ File does not exist: $playlist_file"
        return 1
    fi
    
    local total_videos=0
    local unique_videos=0
    local duplicates=0
    
    # Extract video IDs and count them
    local video_ids=$(grep "^youtube://" "$playlist_file" | cut -d'|' -f1 | sed 's/^youtube:\/\///')
    total_videos=$(echo "$video_ids" | wc -l)
    unique_videos=$(echo "$video_ids" | sort -u | wc -l)
    duplicates=$((total_videos - unique_videos))
    
    echo "🔍 Duplicate Check Report:"
    echo "   Total videos: $total_videos"
    echo "   Unique videos: $unique_videos"
    echo "   Duplicates: $duplicates"
    
    if [[ $duplicates -gt 0 ]]; then
        echo "⚠️  Duplicates found: $duplicates duplicate video(s)"
        echo "   Duplicate video IDs:"
        echo "$video_ids" | sort | uniq -d | sed 's/^/     - /'
        return 1
    else
        echo "✅ No duplicates found"
        return 0
    fi
}
