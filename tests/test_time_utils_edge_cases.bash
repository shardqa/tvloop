#!/usr/bin/env bash

# Time Utils Edge Cases Tests - Bashunit Version
# Tests for edge cases in time utility functions

source "$(pwd)/tests/test_helper.bash"
source "$(pwd)/core/time_utils.sh"

function set_up() {
    # Create temporary test directory
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
}

function tear_down() {
    rm -rf "$TEST_DIR"
}

function test_calculate_current_position_with_very_large_duration() {
    local start_time=$(date +%s)
    local total_duration=999999
    
    local result
    result=$(calculate_current_position "$start_time" "$total_duration")
    
    # Should match the expected format
    assert_matches '^0\|[0-9]+\|[0-9]+$' "$result"
    
    # Parse the output
    IFS='|' read -r cycles position_in_cycle elapsed_time <<< "$result"
    
    # Should be in first cycle
    [ "$cycles" -eq 0 ] || fail "Cycles should be 0, got $cycles"
    
    # Position should be small (just started)
    [ "$position_in_cycle" -le 5 ] || fail "Position in cycle should be <= 5, got $position_in_cycle"
}

function test_calculate_current_position_edge_case_exactly_one_cycle() {
    local start_time=$(( $(date +%s) - 100 ))  # Exactly 100 seconds ago
    local total_duration=100
    
    local result
    result=$(calculate_current_position "$start_time" "$total_duration")
    
    # Should match the expected format
    assert_matches '^[0-9]+\|[0-9]+\|[0-9]+$' "$result"
    
    # Parse the output
    IFS='|' read -r cycles position_in_cycle elapsed_time <<< "$result"
    
    # Should have completed exactly 1 cycle (or be very close)
    [ "$cycles" -eq 1 ] || fail "Cycles should be 1, got $cycles"
    
    # Position in cycle should be 0 or 1 (allowing for timing precision)
    [ "$position_in_cycle" -le 1 ] || fail "Position in cycle should be <= 1, got $position_in_cycle"
}
