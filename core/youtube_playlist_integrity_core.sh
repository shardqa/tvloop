#!/bin/bash

# YouTube Playlist Integrity Core Module
# Core integrity check functions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_basic_validation.sh"
source "$PROJECT_ROOT/core/youtube_playlist_format_validation.sh"
source "$PROJECT_ROOT/core/logging.sh"

check_playlist_integrity() {
    local playlist_file="$1"
    
    echo "🔍 Running comprehensive playlist integrity check..."
    echo ""
    
    local checks_passed=0
    local total_checks=4
    
    if validate_playlist_format "$playlist_file"; then
        checks_passed=$((checks_passed + 1))
    fi
    echo ""
    
    if check_playlist_duplicates "$playlist_file"; then
        checks_passed=$((checks_passed + 1))
    fi
    echo ""
    
    if validate_video_ids "$playlist_file"; then
        checks_passed=$((checks_passed + 1))
    fi
    echo ""
    
    if validate_playlist_file "$playlist_file" >/dev/null; then
        checks_passed=$((checks_passed + 1))
    fi
    
    echo "📋 Integrity Check Summary:"
    echo "   Checks passed: $checks_passed/$total_checks"
    
    if [[ $checks_passed -eq $total_checks ]]; then
        echo "✅ Playlist integrity check PASSED"
        return 0
    else
        echo "❌ Playlist integrity check FAILED"
        return 1
    fi
}

quick_integrity_check() {
    local playlist_file="$1"
    
    echo "🔍 Running quick integrity check..."
    
    if ! check_playlist_file_exists "$playlist_file" >/dev/null; then
        echo "❌ Quick check failed: File does not exist"
        return 1
    fi
    
    if ! has_valid_entries "$playlist_file"; then
        echo "❌ Quick check failed: No valid entries"
        return 1
    fi
    
    if ! check_playlist_duplicates "$playlist_file" >/dev/null; then
        echo "❌ Quick check failed: Duplicates found"
        return 1
    fi
    
    echo "✅ Quick integrity check PASSED"
    return 0
}


