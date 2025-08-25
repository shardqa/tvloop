#!/bin/bash

# Test file for youtube_api_channel.sh basic functionality
# Tests script existence, functions, and dependencies

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test that the script exists and is readable
test_youtube_api_channel_script_exists() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local script_path="$project_root/core/youtube_api_channel.sh"
    
    # Check if file exists and is readable
    test -f "$script_path"
    test -r "$script_path"
}

# Test that the script contains expected functions
test_youtube_api_channel_functions() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
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

# Run basic tests
run_basic_tests() {
    echo "Running youtube_api_channel basic tests..."
    
    test_youtube_api_channel_script_exists
    test_youtube_api_channel_functions
    test_youtube_api_channel_dependencies
    
    echo "✅ All youtube_api_channel basic tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_basic_tests
fi
