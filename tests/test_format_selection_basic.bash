#!/bin/bash

# Basic format selection tests
# Tests basic format selection functionality

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test that format selection function exists
test_format_selection_function_exists() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Test that the main function exists
    if ! type select_youtube_format >/dev/null 2>&1; then
        echo "ERROR: select_youtube_format function not found"
        return 1
    fi
}

# Test that default format combination works
test_default_format_combination() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Test with a known working format combination
    local format=$(select_youtube_format "https://www.youtube.com/watch?v=AeVLXtww_4E")
    
    # Should return the default format combination
    if [[ "$format" != "18" ]]; then
        echo "ERROR: Expected default format '18', got '$format'"
        return 1
    fi
}

# Test fallback to automatic format selection
test_format_fallback_mechanism() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Mock a failed format combination
    local format=$(select_youtube_format "https://www.youtube.com/watch?v=invalid_video_id")
    
    # Should return a fallback format
    if [[ -z "$format" ]]; then
        echo "ERROR: Expected fallback format, got empty string"
        return 1
    fi
    
    # Should return a valid format (no longer checking for + since format 18 is single format)
    if [[ "$format" != "18" ]]; then
        echo "ERROR: Expected fallback format '18', got '$format'"
        return 1
    fi
}
