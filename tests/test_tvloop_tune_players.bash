#!/bin/bash

# tvloop tune player functionality tests

source "$(pwd)/tests/test_helper.bash"

# Test that tvloop tune vlc works with first channel
test_tvloop_tune_vlc_works() {
    # Create test channels
    mkdir -p "$TEST_DIR/channels/test_channel"
    echo "test_video1.mp4|Test Video 1|60" > "$TEST_DIR/channels/test_channel/playlist.txt"
    
    # Create state file
    cat > "$TEST_DIR/channels/test_channel/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 60,
    "playlist_file": "$TEST_DIR/channels/test_channel/playlist.txt",
    "last_updated": $(date +%s)
}
EOF
    
    # Test the command with custom channels directory
    local project_root="$(pwd)"
    local output
    output=$(TEST_MODE=true TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" tune vlc 2>&1)
    local status=$?
    
    # For now, just check that the channel was found and playback was attempted
    # The actual playback will fail due to missing video files, but that's expected in tests
    assert_contains "Found channel: test_channel" "$output"
    assert_contains "Starting playback" "$output"
}

# Test that tvloop tune with specific channel works
test_tvloop_tune_specific_channel() {
    # Create test channels
    mkdir -p "$TEST_DIR/channels/test_channel"
    echo "test_video1.mp4|Test Video 1|60" > "$TEST_DIR/channels/test_channel/playlist.txt"
    
    # Create state file
    cat > "$TEST_DIR/channels/test_channel/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 60,
    "playlist_file": "$TEST_DIR/channels/test_channel/playlist.txt",
    "last_updated": $(date +%s)
}
EOF
    
    # Test the command with custom channels directory
    local project_root="$(pwd)"
    local output
    output=$(TEST_MODE=true TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" tune mpv test_channel 2>&1)
    local status=$?
    
    # For now, just check that the channel was found and playback was attempted
    # The actual playback will fail due to missing video files, but that's expected in tests
    assert_contains "Starting playback for channel: test_channel" "$output"
}

# Test that tvloop tune with invalid channel shows error
test_tvloop_tune_invalid_channel_error() {
    # Test the command
    local project_root="$(pwd)"
    local output
    output=$(TEST_MODE=true "$project_root/tvloop" tune mpv invalid_channel 2>&1)
    local status=$?
    
    assert_equals 1 "$status"
    assert_contains "Channel not found: invalid_channel" "$output"
}
