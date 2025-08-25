#!/bin/bash

# Test file for youtube_api_channel.sh validation and error handling
# Tests error handling patterns and channel validation

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test that the script has proper error handling
test_youtube_api_channel_error_handling() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    # Check for error handling patterns in the modules
    local modules=(
        "core/youtube_channel_resolver.sh"
        "core/youtube_channel_info_basic.sh"
        "core/youtube_channel_info_detailed.sh"
        "core/youtube_channel_videos_core.sh"
        "core/youtube_channel_videos_utils.sh"
        "core/youtube_playlist_duration_core.sh"
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
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
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

# Run validation tests
run_validation_tests() {
    echo "Running youtube_api_channel validation tests..."
    
    test_youtube_api_channel_error_handling
    test_youtube_api_channel_validation
    
    echo "✅ All youtube_api_channel validation tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_validation_tests
fi
