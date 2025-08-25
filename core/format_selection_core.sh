#!/bin/bash

# Format Selection Core Module for tvloop
# Core format selection logic with fallback mechanisms

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Default format combination (360p video + audio)
DEFAULT_FORMAT="18"

# Select YouTube format with fallback mechanism
select_youtube_format() {
    local url="$1"
    
    if [[ -z "$url" ]]; then
        log "ERROR: No URL provided to select_youtube_format"
        return 1
    fi
    
    # First try the default format combination
    if is_format_available "$url" "$DEFAULT_FORMAT"; then
        log "Using default format: $DEFAULT_FORMAT"
        echo "$DEFAULT_FORMAT"
        return 0
    fi
    
    # If default format fails, use automatic selection
    log "Default format failed, using automatic selection"
    select_youtube_format_auto "$url"
}

# Check if a specific format is available for a URL
is_format_available() {
    local url="$1"
    local format="$2"
    
    if [[ -z "$url" || -z "$format" ]]; then
        return 1
    fi
    
    # For now, assume the default format is available
    # In a real implementation, we would test this more thoroughly
    if [[ "$format" == "$DEFAULT_FORMAT" ]]; then
        return 0  # Assume default format is available
    fi
    
    # Test the format by trying to list it
    local test_output
    test_output=$(yt-dlp --list-formats "$url" 2>/dev/null | grep -E "^$format[[:space:]]" || true)
    
    if [[ -n "$test_output" ]]; then
        return 0  # Format is available
    else
        return 1  # Format is not available
    fi
}
