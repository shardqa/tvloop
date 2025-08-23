#!/bin/bash

# YouTube Playlist Integrity Analysis Module
# Analysis functions for playlist integrity

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_format_validation.sh"
source "$PROJECT_ROOT/core/logging.sh"

check_playlist_consistency() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "❌ File does not exist: $playlist_file"
        return 1
    fi
    
    local total_lines=0
    local valid_lines=0
    local empty_lines=0
    local malformed_lines=0
    
    while IFS= read -r line; do
        total_lines=$((total_lines + 1))
        if [[ -z "$line" ]]; then
            empty_lines=$((empty_lines + 1))
        elif validate_playlist_line "$line"; then
            valid_lines=$((valid_lines + 1))
        else
            malformed_lines=$((malformed_lines + 1))
        fi
    done < "$playlist_file"
    
    local consistency_score=0
    if [[ $total_lines -gt 0 ]]; then
        consistency_score=$(( (valid_lines * 100) / total_lines ))
    fi
    
    echo "📊 Consistency: $total_lines lines, $valid_lines valid, ${consistency_score}% score"
    
    if [[ $consistency_score -ge 90 ]]; then
        echo "✅ High consistency"
        return 0
    elif [[ $consistency_score -ge 70 ]]; then
        echo "⚠️  Medium consistency"
        return 1
    else
        echo "❌ Low consistency"
        return 1
    fi
}

validate_playlist_structure() {
    local playlist_file="$1"
    
    if [[ ! -f "$playlist_file" ]]; then
        echo "❌ File does not exist: $playlist_file"
        return 1
    fi
    
    local line_number=0
    local errors=0
    
    while IFS= read -r line; do
        line_number=$((line_number + 1))
        
        if [[ -n "$line" ]]; then
            if ! validate_playlist_line "$line"; then
                echo "   Line $line_number: Invalid format"
                errors=$((errors + 1))
            fi
        fi
    done < "$playlist_file"
    
    if [[ $errors -eq 0 ]]; then
        echo "✅ Playlist structure is valid"
        return 0
    else
        echo "❌ Playlist structure has $errors error(s)"
        return 1
    fi
}


