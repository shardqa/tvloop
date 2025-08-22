#!/bin/bash

# Basic tvloop functionality tests

source "$(pwd)/tests/test_helper.bash"

# Test that tvloop script exists and is executable
test_tvloop_script_exists() {
    local project_root="$(pwd)"
    # Check if file exists and is executable
    test -f "$project_root/tvloop"
    test -x "$project_root/tvloop"
}

# Test that tvloop help shows usage information
test_tvloop_help_shows_usage() {
    # Test the command
    local project_root="$(pwd)"
    local output
    output=$("$project_root/tvloop" help 2>&1)
    local status=$?
    
    assert_equals 0 "$status"
    assert_contains "Usage:" "$output"
    assert_contains "tune" "$output"
    assert_contains "status" "$output"
    assert_contains "list" "$output"
}

# Test that tvloop list shows available channels
test_tvloop_list_shows_channels() {
    # Create test channels
    mkdir -p "$TEST_DIR/channels/channel_1"
    mkdir -p "$TEST_DIR/channels/channel_2"
    
    # Test the command with custom channels directory
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" list 2>&1)
    local status=$?
    
    assert_equals 0 "$status"
    assert_contains "channel_1" "$output"
    assert_contains "channel_2" "$output"
}
