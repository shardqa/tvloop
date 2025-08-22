#!/bin/bash

# Basic tvloop tune functionality tests

source "$(pwd)/tests/test_helper.bash"

# Test that tvloop tune mpv finds first channel automatically
test_tvloop_tune_mpv_finds_first_channel() {
    # Create test channels
    mkdir -p "$TEST_DIR/channels/test_channel"
    echo "test_video1.mp4|Test Video 1|60" > "$TEST_DIR/channels/test_channel/playlist.txt"
    echo "test_video2.mp4|Test Video 2|120" >> "$TEST_DIR/channels/test_channel/playlist.txt"
    
    # Create state file
    cat > "$TEST_DIR/channels/test_channel/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 180,
    "playlist_file": "$TEST_DIR/channels/test_channel/playlist.txt",
    "last_updated": $(date +%s)
}
EOF
    
    # Test the command with custom channels directory
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" tune mpv 2>&1)
    local status=$?
    
    # For now, just check that the channel was found and playback was attempted
    # The actual playback will fail due to missing video files, but that's expected in tests
    assert_contains "Found channel: test_channel" "$output"
    assert_contains "Starting playback" "$output"
}

# Test that tvloop tune mpv with no channels shows error
test_tvloop_tune_mpv_no_channels_error() {
    # Create empty channels directory
    mkdir -p "$TEST_DIR/channels"
    
    # Test the command with custom channels directory
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" tune mpv 2>&1)
    local status=$?
    
    assert_equals 1 "$status"
    assert_contains "No channels found" "$output"
}
