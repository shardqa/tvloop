#!/bin/bash

# YouTube Playlist Repair Core Module
# Core repair functions for playlist files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_format_validation.sh"
source "$PROJECT_ROOT/core/logging.sh"

repair_playlist_file() {
    local playlist_file="$1"
    local backup_file="${playlist_file}.backup"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    cp "$playlist_file" "$backup_file"
    echo "📋 Created backup: $backup_file"
    
    local original_count=0
    local repaired_count=0
    local temp_file=$(mktemp)
    
    while IFS= read -r line; do
        original_count=$((original_count + 1))
        if [[ -n "$line" && "$line" =~ ^youtube://[^|]+\|[^|]+\|[0-9]+$ ]]; then
            echo "$line" >> "$temp_file"
            repaired_count=$((repaired_count + 1))
        fi
    done < "$playlist_file"
    
    mv "$temp_file" "$playlist_file"
    
    local removed_count=$((original_count - repaired_count))
    echo "🔧 Playlist repair completed: $original_count → $repaired_count entries"
    
    if [[ $removed_count -gt 0 ]]; then
        echo "⚠️  $removed_count invalid entries were removed"
    else
        echo "✅ No repairs needed"
    fi
    
    return 0
}

remove_duplicates() {
    local playlist_file="$1"
    local backup_file="${playlist_file}.backup"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    cp "$playlist_file" "$backup_file"
    echo "📋 Created backup: $backup_file"
    
    local original_count=0
    local unique_count=0
    local seen_videos=()
    local temp_file=$(mktemp)
    
    while IFS= read -r line; do
        original_count=$((original_count + 1))
        
        if [[ -n "$line" && "$line" =~ ^youtube:// ]]; then
            local video_id=$(echo "$line" | cut -d'|' -f1 | sed 's/^youtube:\/\///')
            
            local is_duplicate=false
            for seen in "${seen_videos[@]}"; do
                [[ "$seen" == "$video_id" ]] && is_duplicate=true && break
            done
            
            if [[ "$is_duplicate" == "false" ]]; then
                echo "$line" >> "$temp_file"
                seen_videos+=("$video_id")
                unique_count=$((unique_count + 1))
            fi
        fi
    done < "$playlist_file"
    
    mv "$temp_file" "$playlist_file"
    
    local removed_count=$((original_count - unique_count))
    echo "🔧 Duplicate removal completed: $original_count → $unique_count entries"
    
    if [[ $removed_count -gt 0 ]]; then
        echo "⚠️  $removed_count duplicate entries were removed"
    else
        echo "✅ No duplicates found"
    fi
    
    return 0
}
