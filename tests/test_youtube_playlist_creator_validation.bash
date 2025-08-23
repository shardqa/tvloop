#!/bin/bash

# Test module for youtube_playlist_creator.sh validation functionality
# Tests validation logic and output formatting

set -e

# Source test helper
source "$(pwd)/tests/test_helper.bash"

# Test that the script has validation logic
test_youtube_playlist_creator_validation() {
    local project_root="$(pwd)"
    
    # Check for validation patterns in the basic validation module
    local validation_path="$project_root/core/youtube_playlist_basic_validation.sh"
    
    local validation_patterns=(
        "validate_playlist_file"
        "valid_lines"
        "duration.*=~"
        "video_id.*title.*duration"
    )
    
    for pattern in "${validation_patterns[@]}"; do
        if ! grep -q "$pattern" "$validation_path"; then
            echo "ERROR: Validation pattern '$pattern' not found in validation module"
            return 1
        fi
    done
}

# Test that the script has proper output formatting
test_youtube_playlist_creator_output() {
    local project_root="$(pwd)"
    
    # Check for output formatting patterns in the modules
    local modules=(
        "core/youtube_playlist_duration_core.sh"
        "core/youtube_playlist_count_creation.sh"
        "core/youtube_playlist_count_stats.sh"
        "core/youtube_playlist_format_validation.sh"
    )
    
    local output_patterns=(
        "echo.*🎬"
        "echo.*📊"
        "echo.*✅"
        "echo.*⚠️"
        "echo.*🎉"
    )
    
    # Check that at least one module contains each pattern
    for pattern in "${output_patterns[@]}"; do
        local found=false
        for module in "${modules[@]}"; do
            local module_path="$project_root/$module"
            if grep -q "$pattern" "$module_path"; then
                found=true
                break
            fi
        done
        
        if [[ "$found" == "false" ]]; then
            echo "ERROR: Output pattern '$pattern' not found in any module"
            return 1
        fi
    done
}
