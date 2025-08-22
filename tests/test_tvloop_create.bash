#!/bin/bash

# tvloop create command functionality tests

source "$(pwd)/tests/test_helper.bash"

# Test that tvloop create command is recognized
test_tvloop_create_command_recognized() {
    # Test that the create command is recognized in help
    local project_root="$(pwd)"
    local output
    output=$("$project_root/tvloop" help 2>&1)
    local status=$?
    
    # Check that create command is mentioned in help
    assert_contains "create" "$output"
    assert_contains "youtube" "$output"
}

# Test that tvloop create with missing parameters shows usage
test_tvloop_create_missing_parameters() {
    # Test the command with missing parameters
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" create 2>&1)
    local status=$?
    
    # Should show usage message
    assert_contains "Usage:" "$output"
    assert_contains "create" "$output"
    assert_contains "youtube" "$output"
}

# Test that tvloop create with invalid parameters shows error
test_tvloop_create_invalid_parameters() {
    # Test the command with missing parameters
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" create 2>&1)
    local status=$?
    
    # Should show usage/error message
    assert_contains "Usage:" "$output"
    assert_contains "create" "$output"
}

# Test that tvloop create with unsupported channel type shows error
test_tvloop_create_unsupported_type() {
    # Test the command with unsupported channel type
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" create unsupported test_channel 2>&1)
    local status=$?
    
    # Should show error about unsupported channel type
    assert_contains "Unsupported" "$output"
    assert_contains "channel type" "$output"
}

# Test that tvloop create with existing channel name shows error
test_tvloop_create_existing_channel() {
    # Create a channel first
    mkdir -p "$TEST_DIR/channels/existing_channel"
    echo "test_video.mp4|Test Video|60" > "$TEST_DIR/channels/existing_channel/playlist.txt"
    
    # Try to create another channel with the same name
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" create youtube existing_channel "https://www.youtube.com/@JovemNerd" 2 2>&1)
    local status=$?
    
    # Should show error about existing channel
    assert_contains "already exists" "$output"
}
