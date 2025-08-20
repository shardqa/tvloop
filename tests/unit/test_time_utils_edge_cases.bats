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

@test "calculate_current_position with very large duration" {
    local start_time=$(date +%s)
    local total_duration=999999
    
    run calculate_current_position "$start_time" "$total_duration"
    assert_success
    assert_output --regexp '^0\|[0-9]+\|[0-9]+$'
    
    # Parse the output
    IFS='|' read -r cycles position_in_cycle elapsed_time <<< "$output"
    
    # Should be in first cycle
    assert [ $cycles -eq 0 ]
    
    # Position should be small (just started)
    assert [ $position_in_cycle -le 5 ]
}

@test "calculate_current_position edge case - exactly one cycle" {
    local start_time=$(( $(date +%s) - 100 ))  # Exactly 100 seconds ago
    local total_duration=100
    
    run calculate_current_position "$start_time" "$total_duration"
    assert_success
    assert_output --regexp '^[0-9]+\|[0-9]+\|[0-9]+$'
    
    # Parse the output
    IFS='|' read -r cycles position_in_cycle elapsed_time <<< "$output"
    
    # Should have completed exactly 1 cycle
    assert [ $cycles -eq 1 ]
    
    # Position in cycle should be 0 (exactly at start of new cycle)
    assert [ $position_in_cycle -eq 0 ]
}
