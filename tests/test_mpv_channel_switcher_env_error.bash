#!/bin/bash

# Test file for mpv_channel_switcher.lua environment and error handling
# Tests environment variables and error handling

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test that the script handles environment variables correctly
test_mpv_channel_switcher_env_vars() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local script_path="$project_root/scripts/mpv_channel_switcher.lua"
    
    # Check that it uses TVLOOP_CHANNELS_DIR environment variable
    if ! grep -q "TVLOOP_CHANNELS_DIR" "$script_path"; then
        echo "ERROR: Script doesn't use TVLOOP_CHANNELS_DIR environment variable"
        return 1
    fi
}

# Test that the script has proper error handling
test_mpv_channel_switcher_error_handling() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local script_path="$project_root/scripts/mpv_channel_switcher.lua"
    
    # Check for error handling patterns in the main script
    local error_patterns=(
        "msg.error"
        "msg.info"
    )
    
    for pattern in "${error_patterns[@]}"; do
        if ! grep -q "$pattern" "$script_path"; then
            echo "ERROR: Error handling pattern '$pattern' not found in script"
            return 1
        fi
    done
    
    # Check that error handling modules exist
    local error_modules=(
        "$project_root/scripts/mpv_event_handlers.lua"
    )
    
    for module in "${error_modules[@]}"; do
        if ! test -f "$module"; then
            echo "ERROR: Error handling module '$module' not found"
            return 1
        fi
    done
}

# Run environment and error handling tests
run_env_error_tests() {
    echo "Running mpv_channel_switcher environment and error handling tests..."
    
    test_mpv_channel_switcher_env_vars
    test_mpv_channel_switcher_error_handling
    
    echo "✅ All mpv_channel_switcher environment and error handling tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_env_error_tests
fi
