#!/bin/bash

# Test module for youtube_playlist_creator.sh logic functionality
# Tests error handling and playlist creation logic

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test that the script has proper error handling
test_youtube_playlist_creator_error_handling() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    # Check for error handling patterns in the modules
    local modules=(
        "core/youtube_playlist_duration_core.sh"
        "core/youtube_playlist_duration_utils.sh"
        "core/youtube_playlist_count_creation.sh"
        "core/youtube_playlist_count_analysis.sh"
        "core/youtube_playlist_count_stats.sh"
        "core/youtube_playlist_basic_validation.sh"
        "core/youtube_playlist_format_validation_core.sh"
        "core/youtube_playlist_format_validation_duplicates.sh"
        "core/youtube_playlist_format_validation_line.sh"
    )
    
    # Check that each module has basic error handling
    for module in "${modules[@]}"; do
        local module_path="$project_root/$module"
        local has_error_handling=false
        
        # Check for any error handling pattern
        if (grep -q "log.*ERROR" "$module_path" || grep -q "echo.*❌" "$module_path") && grep -q "return 1" "$module_path"; then
            has_error_handling=true
        fi
        
        if [[ "$has_error_handling" == "false" ]]; then
            echo "ERROR: No error handling found in module $module"
            return 1
        fi
    done
}

# Test that the script has playlist creation logic
test_youtube_playlist_creator_playlist_logic() {
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    # Check for playlist creation patterns in the modules
    local modules=(
        "core/youtube_playlist_duration_core.sh"
        "core/youtube_playlist_count_creation.sh"
        "core/youtube_playlist_count_helpers.sh"
    )
    
    local playlist_patterns=(
        "target_hours"
        "playlist_duration"
        "youtube://"
        "video_count"
        "playlist_file"
    )
    
    # Check that at least one module contains each pattern
    for pattern in "${playlist_patterns[@]}"; do
        local found=false
        for module in "${modules[@]}"; do
            local module_path="$project_root/$module"
            if grep -q "$pattern" "$module_path"; then
                found=true
                break
            fi
        done
        
        if [[ "$found" == "false" ]]; then
            echo "ERROR: Playlist logic pattern '$pattern' not found in any module"
            return 1
        fi
    done
}

# Run playlist creator logic tests
run_playlist_creator_logic_tests() {
    echo "Running youtube_playlist_creator logic tests..."
    
    test_youtube_playlist_creator_error_handling
    test_youtube_playlist_creator_playlist_logic
    
    echo "✅ All youtube_playlist_creator logic tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_playlist_creator_logic_tests
fi
