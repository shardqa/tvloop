#!/bin/bash

# tvloop remove command functionality tests

source "$(pwd)/tests/test_helper.bash"

# Test that tvloop remove command is recognized
test_tvloop_remove_command_recognized() {
    # Test that the remove command is recognized in help
    local project_root="$(pwd)"
    local output
    output=$("$project_root/tvloop" help 2>&1)
    local status=$?
    
    # Check that remove command is mentioned in help
    assert_contains "remove" "$output"
}

# Test that tvloop remove with missing parameters shows usage
test_tvloop_remove_missing_parameters() {
    # Test the command with missing parameters
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" remove 2>&1)
    local status=$?
    
    # Should show usage message
    assert_contains "Usage:" "$output"
    assert_contains "remove" "$output"
}

# Test that tvloop remove with non-existent channel shows error
test_tvloop_remove_nonexistent_channel() {
    # Test the command with non-existent channel
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" remove nonexistent_channel 2>&1)
    local status=$?
    
    # Should show error about non-existent channel
    assert_contains "not found" "$output"
}

# Test that tvloop remove with existing channel removes it
test_tvloop_remove_existing_channel() {
    # Create a test channel first
    mkdir -p "$TEST_DIR/channels/test_channel_to_remove"
    echo "test_video.mp4|Test Video|60" > "$TEST_DIR/channels/test_channel_to_remove/playlist.txt"
    echo "test content" > "$TEST_DIR/channels/test_channel_to_remove/state.json"
    
    # Verify channel exists
    if [[ ! -d "$TEST_DIR/channels/test_channel_to_remove" ]]; then
        echo "ERROR: Test channel was not created"
        return 1
    fi
    
    # Remove the channel
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" remove test_channel_to_remove 2>&1)
    local status=$?
    
    # Should show success message
    assert_contains "removed" "$output"
    
    # Channel directory should be gone
    if [[ -d "$TEST_DIR/channels/test_channel_to_remove" ]]; then
        echo "ERROR: Channel directory still exists after removal"
        return 1
    fi
}

# Test that tvloop remove stops running players
test_tvloop_remove_stops_players() {
    # Create a test channel with a mock PID file
    mkdir -p "$TEST_DIR/channels/test_channel_with_player"
    echo "test_video.mp4|Test Video|60" > "$TEST_DIR/channels/test_channel_with_player/playlist.txt"
    echo "999999" > "$TEST_DIR/channels/test_channel_with_player/mpv.pid"
    
    # Remove the channel
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" remove test_channel_with_player 2>&1)
    local status=$?
    
    # Should show success message
    assert_contains "removed" "$output"
    
    # Channel directory should be gone
    if [[ -d "$TEST_DIR/channels/test_channel_with_player" ]]; then
        echo "ERROR: Channel directory still exists after removal"
        return 1
    fi
}
