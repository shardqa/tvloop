#!/bin/bash

# Test file for youtube_api_channel.sh integration functionality
# Tests API integration patterns and playlist logic

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test that the script has proper API integration
test_youtube_api_channel_api_integration() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    # Check for API integration patterns in the modules
    local modules=(
        "core/youtube_api_core.sh"
        "core/youtube_channel_resolver_core.sh"
        "core/youtube_channel_resolver_utils.sh"
        "core/youtube_channel_info_basic.sh"
        "core/youtube_channel_info_detailed.sh"
        "core/youtube_channel_videos_core.sh"
        "core/youtube_channel_videos_utils.sh"
        "core/youtube_playlist_creator.sh"
    )
    
    local api_patterns=(
        "youtube_api_request"
        "\"channels\""
        "\"playlistItems\""
        "\"search\""
        "API_KEY"
    )
    
    # Check that at least one module contains each API pattern
    for pattern in "${api_patterns[@]}"; do
        local found=false
        for module in "${modules[@]}"; do
            local module_path="$project_root/$module"
            if grep -q "$pattern" "$module_path"; then
                found=true
                break
            fi
        done
        
        if [[ "$found" == "false" ]]; then
            echo "ERROR: API integration pattern '$pattern' not found in any module"
            return 1
        fi
    done
}

# Test that the script has proper playlist creation logic
test_youtube_api_channel_playlist_logic() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    # Check for playlist creation patterns in the playlist duration core module
    local playlist_path="$project_root/core/youtube_playlist_duration_core.sh"
    
    local playlist_patterns=(
        "create_24h_channel_playlist"
        "target_hours"
        "playlist_duration"
        "youtube://"
    )
    
    for pattern in "${playlist_patterns[@]}"; do
        if ! grep -q "$pattern" "$playlist_path"; then
            echo "ERROR: Playlist logic pattern '$pattern' not found in playlist duration core module"
            return 1
        fi
    done
}

# Run integration tests
run_integration_tests() {
    echo "Running youtube_api_channel integration tests..."
    
    test_youtube_api_channel_api_integration
    test_youtube_api_channel_playlist_logic
    
    echo "✅ All youtube_api_channel integration tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_integration_tests
fi
