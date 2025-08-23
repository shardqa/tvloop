#!/bin/bash

# Test file for youtube_api_channel.sh functionality
# Tests YouTube API channel operations

set -e

# Source test helper
source "$(pwd)/tests/test_helper.bash"

# Test that the script exists and is readable
test_youtube_api_channel_script_exists() {
    local project_root="$(pwd)"
    local script_path="$project_root/core/youtube_api_channel.sh"
    
    # Check if file exists and is readable
    test -f "$script_path"
    test -r "$script_path"
}

# Test that the script contains expected functions
test_youtube_api_channel_functions() {
    local project_root="$(pwd)"
    local script_path="$project_root/core/youtube_api_channel.sh"
    
    # Check that the script sources the required modules
    local required_modules=(
        "youtube_channel_resolver.sh"
        "youtube_channel_info.sh"
        "youtube_channel_videos.sh"
        "youtube_playlist_creator.sh"
    )
    
    for module in "${required_modules[@]}"; do
        if ! grep -q "source.*$module" "$script_path"; then
            echo "ERROR: Required module '$module' not found in script"
            return 1
        fi
    done
}

# Test that the script sources required dependencies
test_youtube_api_channel_dependencies() {
    local project_root="$(pwd)"
    
    # Check that the modules exist and are readable
    local required_modules=(
        "core/youtube_channel_resolver.sh"
        "core/youtube_channel_info.sh"
        "core/youtube_channel_videos.sh"
        "core/youtube_playlist_creator.sh"
    )
    
    for module in "${required_modules[@]}"; do
        local module_path="$project_root/$module"
        if [[ ! -f "$module_path" ]]; then
            echo "ERROR: Required module '$module' does not exist"
            return 1
        fi
        if [[ ! -r "$module_path" ]]; then
            echo "ERROR: Required module '$module' is not readable"
            return 1
        fi
    done
}

# Test that the script has proper error handling
test_youtube_api_channel_error_handling() {
    local project_root="$(pwd)"
    
    # Check for error handling patterns in the modules
    local modules=(
        "core/youtube_channel_resolver.sh"
        "core/youtube_channel_info.sh"
        "core/youtube_channel_videos.sh"
        "core/youtube_playlist_duration.sh"
    )
    
    local error_patterns=(
        "log.*ERROR"
        "return 1"
        "if.*-eq 0"
    )
    
    # Check that each module has basic error handling
    for module in "${modules[@]}"; do
        local module_path="$project_root/$module"
        local has_error_handling=false
        
        # Check for any error handling pattern (log ERROR or echo ❌ with return 1)
        if (grep -q "log.*ERROR" "$module_path" || grep -q "echo.*❌" "$module_path") && grep -q "return 1" "$module_path"; then
            has_error_handling=true
        fi
        
        if [[ "$has_error_handling" == "false" ]]; then
            echo "ERROR: No error handling found in module $module"
            return 1
        fi
    done
}

# Test that the script has proper channel ID validation
test_youtube_api_channel_validation() {
    local project_root="$(pwd)"
    
    # Check for validation patterns in the resolver module
    local resolver_path="$project_root/core/youtube_channel_resolver.sh"
    
    local validation_patterns=(
        "get_channel_id"
        "channel_input"
        "jq"
        "if.*-eq"
    )
    
    for pattern in "${validation_patterns[@]}"; do
        if ! grep -q "$pattern" "$resolver_path"; then
            echo "ERROR: Validation pattern '$pattern' not found in resolver module"
            return 1
        fi
    done
}

# Test that the script has proper API integration
test_youtube_api_channel_api_integration() {
    local project_root="$(pwd)"
    
    # Check for API integration patterns in the modules
    local modules=(
        "core/youtube_channel_resolver.sh"
        "core/youtube_channel_info.sh"
        "core/youtube_channel_videos.sh"
        "core/youtube_playlist_creator.sh"
    )
    
    local api_patterns=(
        "youtube_api_request"
        "channels"
        "playlistItems"
        "search"
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
    local project_root="$(pwd)"
    
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

# Run all tests
run_tests() {
    echo "Running youtube_api_channel tests..."
    
    test_youtube_api_channel_script_exists
    test_youtube_api_channel_functions
    test_youtube_api_channel_dependencies
    test_youtube_api_channel_error_handling
    test_youtube_api_channel_validation
    test_youtube_api_channel_api_integration
    test_youtube_api_channel_playlist_logic
    
    echo "✅ All youtube_api_channel tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests
fi
