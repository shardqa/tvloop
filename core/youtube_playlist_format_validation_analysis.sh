#!/bin/bash

# YouTube Playlist Format Validation Analysis Module
# Handles playlist format analysis logic

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
