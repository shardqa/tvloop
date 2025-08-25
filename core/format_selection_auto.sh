#!/bin/bash

# Format Selection Auto Module for tvloop
# Automatic format selection and validation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Automatically select the best 360p video + audio format
select_youtube_format_auto() {
    local url="$1"
    
    if [[ -z "$url" ]]; then
        log "ERROR: No URL provided to select_youtube_format_auto"
        return 1
    fi
    
    log "Automatically selecting format for: $url"
    
    # Use a more robust fallback strategy
    # Try multiple format combinations that we know work
    local fallback_formats=("18" "best[height<=360]" "worst")
    
    for format in "${fallback_formats[@]}"; do
        log "Trying fallback format: $format"
        # For now, just return the first fallback
        # In a real implementation, we would test each format
        echo "$format"
        return 0
    done
    
    log "ERROR: No suitable fallback format found"
    return 1
}

# Validate if a format string is valid
is_valid_format() {
    local format="$1"
    
    if [[ -z "$format" ]]; then
        return 1
    fi
    
    # Check if format contains video+audio combination
    if [[ "$format" =~ ^[0-9]+\+[0-9]+ ]]; then
        return 0
    fi
    
    # Check if it's a single format ID
    if [[ "$format" =~ ^[0-9]+$ ]]; then
        return 0
    fi
    
    # Check if it's a format filter
    if [[ "$format" =~ ^best\[.*\]$ ]]; then
        return 0
    fi
    
    return 1
}
