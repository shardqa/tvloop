#!/bin/bash

# YouTube Playlist Format Validation IDs Module
# Handles video ID validation logic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Validate video IDs format
validate_video_ids() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "❌ File does not exist: $playlist_file"
        return 1
    fi
    
    local total_ids=0
    local valid_ids=0
    local invalid_ids=()
    
    while IFS='|' read -r video_url title duration; do
        if [[ "$video_url" =~ ^youtube:// ]]; then
            local video_id=$(echo "$video_url" | sed 's/^youtube:\/\///')
            total_ids=$((total_ids + 1))
            
            # YouTube video IDs are 11 characters long and contain alphanumeric characters, hyphens, and underscores
            if [[ "$video_id" =~ ^[a-zA-Z0-9_-]{11}$ ]]; then
                valid_ids=$((valid_ids + 1))
            else
                invalid_ids+=("$video_id")
            fi
        fi
    done < "$playlist_file"
    
    echo "🆔 Video ID Validation Report:"
    echo "   Total video IDs: $total_ids"
    echo "   Valid IDs: $valid_ids"
    echo "   Invalid IDs: ${#invalid_ids[@]}"
    
    if [[ ${#invalid_ids[@]} -gt 0 ]]; then
        echo "❌ Invalid video IDs found:"
        for id in "${invalid_ids[@]}"; do
            echo "     - $id"
        done
        return 1
    else
        echo "✅ All video IDs are valid"
        return 0
    fi
}
