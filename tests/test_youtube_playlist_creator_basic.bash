#!/bin/bash

# Test module for youtube_playlist_creator.sh basic functionality
# Tests script existence, functions, and dependencies

set -e

# Source test helper
source "$(pwd)/tests/test_helper.bash"

# Test that the script exists and is readable
test_youtube_playlist_creator_script_exists() {
    local project_root="$(pwd)"
    local script_path="$project_root/core/youtube_playlist_creator.sh"
    
    # Check if file exists and is readable
    test -f "$script_path"
    test -r "$script_path"
}

# Test that the script contains expected functions
test_youtube_playlist_creator_functions() {
    local project_root="$(pwd)"
    local script_path="$project_root/core/youtube_playlist_creator.sh"
    
    # Check that the script sources the required modules
    local required_modules=(
        "youtube_playlist_duration.sh"
        "youtube_playlist_count.sh"
        "youtube_playlist_validation.sh"
        "youtube_playlist_common.sh"
    )
    
    for module in "${required_modules[@]}"; do
        if ! grep -q "source.*$module" "$script_path"; then
            echo "ERROR: Required module '$module' not found in script"
            return 1
        fi
    done
}

# Test that the script sources required dependencies
test_youtube_playlist_creator_dependencies() {
    local project_root="$(pwd)"
    
    # Check that the modules exist and are readable
    local required_modules=(
        "core/youtube_playlist_duration.sh"
        "core/youtube_playlist_count.sh"
        "core/youtube_playlist_validation.sh"
        "core/youtube_playlist_common.sh"
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

