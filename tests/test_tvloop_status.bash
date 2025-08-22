#!/bin/bash

# tvloop status functionality tests

source "$(pwd)/tests/test_helper.bash"

# Test that tvloop status shows first channel status
test_tvloop_status_shows_first_channel() {
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
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" status 2>&1)
    local status=$?
    
    assert_equals 0 "$status"
    assert_contains "Channel: test_channel" "$output"
    assert_contains "Current Video:" "$output"
}
