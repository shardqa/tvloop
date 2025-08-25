#!/bin/bash

# YouTube Playlist Format Validation Core Module
# Core validation logic for playlist format analysis

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Validate playlist format (detailed)
validate_playlist_format() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "❌ File does not exist: $playlist_file"
        return 1
    fi
    
    local total_lines=0
    local valid_lines=0
    local empty_lines=0
    local malformed_lines=0
    local invalid_durations=0
    local missing_fields=0
    
    while IFS= read -r line; do
        total_lines=$((total_lines + 1))
        
        # Skip empty lines
        if [[ -z "$line" ]]; then
            empty_lines=$((empty_lines + 1))
            continue
        fi
        
        # Check if line follows youtube://video_id|title|duration format
        if [[ ! "$line" =~ ^youtube://[^|]+\|[^|]+\|[0-9]+$ ]]; then
            malformed_lines=$((malformed_lines + 1))
            continue
        fi
        
        # Parse the line
        local video_id=$(echo "$line" | cut -d'|' -f1 | sed 's/^youtube:\/\///')
        local title=$(echo "$line" | cut -d'|' -f2)
        local duration=$(echo "$line" | cut -d'|' -f3)
        
        # Check for missing fields
        if [[ -z "$video_id" || -z "$title" || -z "$duration" ]]; then
            missing_fields=$((missing_fields + 1))
            continue
        fi
        
        # Check duration format
        if [[ ! "$duration" =~ ^[0-9]+$ ]]; then
            invalid_durations=$((invalid_durations + 1))
            continue
        fi
        
        valid_lines=$((valid_lines + 1))
    done < "$playlist_file"
    
    echo "📊 Playlist Format Validation Report:"
    echo "   Total lines: $total_lines"
    echo "   Valid entries: $valid_lines"
    echo "   Empty lines: $empty_lines"
    echo "   Malformed lines: $malformed_lines"
    echo "   Missing fields: $missing_fields"
    echo "   Invalid durations: $invalid_durations"
    
    if [[ $valid_lines -eq 0 ]]; then
        echo "❌ Validation failed: No valid entries found"
        return 1
    else
        local success_rate=$(( (valid_lines * 100) / (total_lines - empty_lines) ))
        echo "✅ Validation passed: ${success_rate}% success rate"
        return 0
    fi
}

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
