#!/bin/bash

# Test coordinator for youtube_playlist_creator.sh functionality
# Coordinates all youtube_playlist_creator test modules

set -e

# Source test helper
source "$(pwd)/tests/test_helper.bash"

# Source test modules
source "$(pwd)/tests/test_youtube_playlist_creator_basic.bash"
source "$(pwd)/tests/test_youtube_playlist_creator_logic.bash"
source "$(pwd)/tests/test_youtube_playlist_creator_validation.bash"

# Run all tests
run_tests() {
    echo "Running youtube_playlist_creator tests..."
    
    # Basic tests
    test_youtube_playlist_creator_script_exists
    test_youtube_playlist_creator_functions
    test_youtube_playlist_creator_dependencies
    
    # Logic tests
    test_youtube_playlist_creator_error_handling
    test_youtube_playlist_creator_playlist_logic
    
    # Validation tests
    test_youtube_playlist_creator_validation
    test_youtube_playlist_creator_output
    
    echo "✅ All youtube_playlist_creator tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests
fi
