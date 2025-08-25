#!/bin/bash

# Test file for mpv_channel_switcher.lua integration functionality
# Tests module loading and MPV integration

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test that the script has proper module loading
test_mpv_channel_switcher_module_loading() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local script_path="$project_root/scripts/mpv_channel_switcher.lua"
    
    # Check for module loading
    if ! grep -q "dofile.*mpv_" "$script_path"; then
        echo "ERROR: Module loading not found in script"
        return 1
    fi
    
    # Check for specific modules
    local modules=(
        "mpv_channel_discovery"
        "mpv_playlist_parser"
        "mpv_position_calculator"
        "mpv_event_handlers"
        "mpv_key_bindings"
    )
    
    for module in "${modules[@]}"; do
        if ! grep -q "dofile.*$module" "$script_path"; then
            echo "ERROR: Module '$module' not found in script"
            return 1
        fi
    done
}

# Test that the script integrates with MPV properly
test_mpv_channel_switcher_mpv_integration() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local script_path="$project_root/scripts/mpv_channel_switcher.lua"
    
    # Check for MPV API usage in main script
    local mpv_patterns=(
        "require 'mp'"
        "mp.commandv"
        "mp.osd_message"
    )
    
    for pattern in "${mpv_patterns[@]}"; do
        if ! grep -q "$pattern" "$script_path"; then
            echo "ERROR: MPV integration pattern '$pattern' not found in script"
            return 1
        fi
    done
    
    # Check that MPV integration modules exist
    local mpv_modules=(
        "$project_root/scripts/mpv_event_handlers.lua"
        "$project_root/scripts/mpv_key_bindings.lua"
    )
    
    for module in "${mpv_modules[@]}"; do
        if ! test -f "$module"; then
            echo "ERROR: MPV integration module '$module' not found"
            return 1
        fi
    done
}

# Run integration tests
run_integration_tests() {
    echo "Running mpv_channel_switcher integration tests..."
    
    test_mpv_channel_switcher_module_loading
    test_mpv_channel_switcher_mpv_integration
    
    echo "✅ All mpv_channel_switcher integration tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_integration_tests
fi
