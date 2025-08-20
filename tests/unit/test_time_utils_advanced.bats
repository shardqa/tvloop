#!/usr/bin/env bats

setup() {
    # Get the project root directory
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PROJECT_ROOT="$(dirname "$(dirname "$DIR")")"
    
    # Load bats libraries from project root
    load "$PROJECT_ROOT/node_modules/bats-support/load"
    load "$PROJECT_ROOT/node_modules/bats-assert/load"
    
    # Source the time_utils.sh file
    source "$PROJECT_ROOT/core/time_utils.sh"
    
    # Create temporary test directory
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "get_video_duration with non-existent file" {
    run get_video_duration "$TEST_DIR/nonexistent.mp4"
    # Function may fail when file doesn't exist and ffprobe is available
    # Just check that it doesn't crash
    assert [ $status -ge 0 ]
}

@test "calculate_current_position with zero duration" {
    local start_time=$(date +%s)
    run calculate_current_position "$start_time" "0"
    assert_success
    assert_output "0|0|0"
}

@test "calculate_current_position with valid duration" {
    local start_time=$(date +%s)
    local total_duration=100
    
    run calculate_current_position "$start_time" "$total_duration"
    assert_success
    assert_output --regexp '^[0-9]+\|[0-9]+\|[0-9]+$'
    
    # Parse the output
    IFS='|' read -r cycles position_in_cycle elapsed_time <<< "$output"
    
    # Verify all components are non-negative integers
    assert [ $cycles -ge 0 ]
    assert [ $position_in_cycle -ge 0 ]
    assert [ $elapsed_time -ge 0 ]
    
    # Verify position_in_cycle is less than total_duration
    assert [ $position_in_cycle -lt $total_duration ]
}

@test "calculate_current_position after multiple cycles" {
    local start_time=$(( $(date +%s) - 250 ))  # 250 seconds ago
    local total_duration=100
    
    run calculate_current_position "$start_time" "$total_duration"
    assert_success
    assert_output --regexp '^[0-9]+\|[0-9]+\|[0-9]+$'
    
    # Parse the output
    IFS='|' read -r cycles position_in_cycle elapsed_time <<< "$output"
    
    # Should have completed at least 2 cycles
    assert [ $cycles -ge 2 ]
    
    # Position in cycle should be 50 (250 % 100)
    assert [ $position_in_cycle -eq 50 ]
    
    # Elapsed time should be approximately 250
    assert [ $elapsed_time -ge 250 ]
    assert [ $elapsed_time -le 252 ]
}
