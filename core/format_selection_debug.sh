#!/bin/bash

# Format Selection Debug Module for tvloop
# Format information and testing utilities

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Get format information for debugging
get_format_info() {
    local url="$1"
    local format="$2"
    
    if [[ -z "$url" ]]; then
        log "ERROR: No URL provided to get_format_info"
        return 1
    fi
    
    log "Getting format info for: $url"
    
    if [[ -n "$format" ]]; then
        log "Specific format: $format"
        yt-dlp --list-formats "$url" 2>/dev/null | grep -E "^$format[[:space:]]" || true
    else
        log "All available formats:"
        yt-dlp --list-formats "$url" 2>/dev/null
    fi
}

# Test format selection with a specific URL
test_format_selection() {
    local url="$1"
    
    if [[ -z "$url" ]]; then
        log "ERROR: No URL provided to test_format_selection"
        return 1
    fi
    
    log "Testing format selection for: $url"
    
    # Get all available formats
    log "Available formats:"
    get_format_info "$url"
    
    # Test default format
    log "Testing default format: $DEFAULT_FORMAT"
    if is_format_available "$url" "$DEFAULT_FORMAT"; then
        log "✅ Default format is available"
    else
        log "❌ Default format is not available"
    fi
    
    # Test automatic selection
    log "Testing automatic format selection:"
    local auto_format=$(select_youtube_format_auto "$url")
    if [[ -n "$auto_format" ]]; then
        log "✅ Automatic format selected: $auto_format"
    else
        log "❌ Automatic format selection failed"
    fi
    
    # Test full selection with fallback
    log "Testing full format selection with fallback:"
    local final_format=$(select_youtube_format "$url")
    if [[ -n "$final_format" ]]; then
        log "✅ Final format selected: $final_format"
    else
        log "❌ Format selection failed"
    fi
}
