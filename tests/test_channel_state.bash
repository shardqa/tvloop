#!/usr/bin/env bash

# Channel State Module Tests

source "$(pwd)/tests/test_helper.bash"

# Source the channel state module
source "$(pwd)/core/channel_state.sh"

function set_up() {
    # Create test directories and files
    TEST_CHANNEL_DIR=$(mktemp -d)
    TEST_PLAYLIST_FILE="$TEST_CHANNEL_DIR/playlist.txt"
    
    # Create a sample playlist file
    cat > "$TEST_PLAYLIST_FILE" << 'EOF'
#EXTM3U
#EXTINF:120,Video 1
https://example.com/video1.mp4
#EXTINF:180,Video 2
https://example.com/video2.mp4
#EXTINF:90,Video 3
https://example.com/video3.mp4
EOF
}

function tear_down() {
    # Clean up test directory
    rm -rf "$TEST_CHANNEL_DIR"
}

function test_channel_state_functions_exist() {
    # Test that channel state functions exist
    assert_equals "function" "$(type -t initialize_channel)"
    assert_equals "function" "$(type -t get_channel_status)"
}

function test_initialize_channel_creates_state_file() {
    # Test that initialize_channel creates a state file
    initialize_channel "$TEST_CHANNEL_DIR"
    
    local state_file="$TEST_CHANNEL_DIR/state.json"
    assert_file_exists "$state_file"
}

function test_initialize_channel_state_file_content() {
    # Test that state file contains expected JSON structure
    initialize_channel "$TEST_CHANNEL_DIR"
    
    local state_file="$TEST_CHANNEL_DIR/state.json"
    local content
    content=$(cat "$state_file")
    
    # Check for required fields
    assert_contains "start_time" "$content"
    assert_contains "total_duration" "$content"
    assert_contains "playlist_file" "$content"
    assert_contains "last_updated" "$content"
}

function test_initialize_channel_with_invalid_playlist() {
    # Test initialize_channel with non-existent playlist
    local invalid_dir=$(mktemp -d)
    local output
    output=$(initialize_channel "$invalid_dir" 2>&1)
    
    assert_contains "ERROR: Playlist file not found" "$output"
    
    rm -rf "$invalid_dir"
}

function test_get_channel_status_without_state_file() {
    # Test get_channel_status without state file
    local output
    output=$(get_channel_status "$TEST_CHANNEL_DIR" 2>&1)
    
    assert_contains "ERROR: Channel state file not found" "$output"
}

function test_get_channel_status_with_valid_state() {
    # Test get_channel_status with valid state file
    initialize_channel "$TEST_CHANNEL_DIR"
    
    local output
    output=$(get_channel_status "$TEST_CHANNEL_DIR")
    
    # Check for expected output format
    assert_contains "Channel Status:" "$output"
    assert_contains "Start Time:" "$output"
    assert_contains "Elapsed Time:" "$output"
    assert_contains "Cycles Completed:" "$output"
    assert_contains "Current Video:" "$output"
    assert_contains "Video Position:" "$output"
    assert_contains "Total Playlist Duration:" "$output"
}

function test_channel_initialization_timestamp() {
    # Test that initialization uses current timestamp
    local before_time
    before_time=$(date +%s)
    
    initialize_channel "$TEST_CHANNEL_DIR"
    
    local after_time
    after_time=$(date +%s)
    
    local state_file="$TEST_CHANNEL_DIR/state.json"
    local start_time
    start_time=$(jq -r '.start_time' "$state_file")
    
    # The start_time should be between before_time and after_time
    [ "$start_time" -ge "$before_time" ] || fail "Start time should be >= before_time"
    [ "$start_time" -le "$after_time" ] || fail "Start time should be <= after_time"
}
