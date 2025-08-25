#!/bin/bash

# Advanced format selection tests
# Tests advanced format selection functionality

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test automatic 360p video + audio selection
test_automatic_360p_selection() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Test automatic format selection
    local format=$(select_youtube_format_auto "https://www.youtube.com/watch?v=AeVLXtww_4E")
    
    # Should return a valid format combination
    if [[ -z "$format" ]]; then
        echo "ERROR: Expected automatic format selection, got empty string"
        return 1
    fi
    
    # Should return a valid format (no longer checking for + since format 18 is single format)
    if [[ "$format" != "18" ]]; then
        echo "ERROR: Expected automatic format '18', got '$format'"
        return 1
    fi
}

# Test format validation
test_format_validation() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Test valid format
    if ! is_valid_format "18"; then
        echo "ERROR: Valid format '18' was rejected"
        return 1
    fi
    
    # Test invalid format
    if is_valid_format "invalid_format"; then
        echo "ERROR: Invalid format 'invalid_format' was accepted"
        return 1
    fi
}

# Test integration with MPV player
test_mpv_format_integration() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$project_root/players/mpv_player.sh"
    
    # Test that MPV player uses format selection
    # This is a basic test to ensure the integration exists
    if ! type launch_mpv >/dev/null 2>&1; then
        echo "ERROR: launch_mpv function not found"
        return 1
    fi
}
