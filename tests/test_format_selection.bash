#!/bin/bash

# Test file for format selection functionality
# Tests robust format selection with fallback mechanisms

set -e

# Source test helper
source "$(dirname "$0")/test_helper.bash"

# Test that format selection function exists
test_format_selection_function_exists() {
    local project_root="$(pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Test that the main function exists
    if ! type select_youtube_format >/dev/null 2>&1; then
        echo "ERROR: select_youtube_format function not found"
        return 1
    fi
}

# Test that default format combination works
test_default_format_combination() {
    local project_root="$(pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Test with a known working format combination
    local format=$(select_youtube_format "https://www.youtube.com/watch?v=AeVLXtww_4E")
    
    # Should return the default format combination
    if [[ "$format" != "230+234-1" ]]; then
        echo "ERROR: Expected default format '230+234-1', got '$format'"
        return 1
    fi
}

# Test fallback to automatic format selection
test_format_fallback_mechanism() {
    local project_root="$(pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Mock a failed format combination
    local format=$(select_youtube_format "https://www.youtube.com/watch?v=invalid_video_id")
    
    # Should return a fallback format
    if [[ -z "$format" ]]; then
        echo "ERROR: Expected fallback format, got empty string"
        return 1
    fi
    
    # Should contain video and audio format combination
    if [[ ! "$format" =~ .*\+.* ]]; then
        echo "ERROR: Expected format to contain video+audio combination, got '$format'"
        return 1
    fi
}

# Test automatic 360p video + audio selection
test_automatic_360p_selection() {
    local project_root="$(pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Test automatic format selection
    local format=$(select_youtube_format_auto "https://www.youtube.com/watch?v=AeVLXtww_4E")
    
    # Should return a valid format combination
    if [[ -z "$format" ]]; then
        echo "ERROR: Expected automatic format selection, got empty string"
        return 1
    fi
    
    # Should contain video and audio format combination
    if [[ ! "$format" =~ .*\+.* ]]; then
        echo "ERROR: Expected format to contain video+audio combination, got '$format'"
        return 1
    fi
}

# Test format validation
test_format_validation() {
    local project_root="$(pwd)"
    source "$project_root/core/format_selection.sh"
    
    # Test valid format
    if ! is_valid_format "230+234-1"; then
        echo "ERROR: Valid format '230+234-1' was rejected"
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
    local project_root="$(pwd)"
    source "$project_root/players/mpv_player.sh"
    
    # Test that MPV player uses format selection
    # This is a basic test to ensure the integration exists
    if ! type launch_mpv >/dev/null 2>&1; then
        echo "ERROR: launch_mpv function not found"
        return 1
    fi
}

# Run all tests
run_tests() {
    echo "Running format selection tests..."
    
    test_format_selection_function_exists
    test_default_format_combination
    test_format_fallback_mechanism
    test_automatic_360p_selection
    test_format_validation
    test_mpv_format_integration
    
    echo "✅ All format selection tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests
fi
