#!/usr/bin/env bats

# Test file for channel_tracker.sh
# Uses Bats (Bash Automated Testing System)

setup() {
    # Setup test environment
    export TEST_DIR="/tmp/tvloop_test_$$"
    export CHANNEL_DIR="$TEST_DIR/channel_1"
    export SCRIPT_DIR="scripts"
    
    mkdir -p "$CHANNEL_DIR"
    
    # Create test playlist
    cat > "$CHANNEL_DIR/playlist.txt" << EOF
/tmp/test_video1.mp4|Test Video 1|120
/tmp/test_video2.mp4|Test Video 2|180
/tmp/test_video3.mp4|Test Video 3|90
EOF
    
    # Create test video files
    echo "test content" > /tmp/test_video1.mp4
    echo "test content" > /tmp/test_video2.mp4
    echo "test content" > /tmp/test_video3.mp4
}

teardown() {
    # Cleanup test environment
    rm -rf "$TEST_DIR"
    rm -f /tmp/test_video*.mp4
}

@test "channel_tracker init creates state file" {
    run "$SCRIPT_DIR/channel_tracker.sh" "$CHANNEL_DIR" init
    
    [ "$status" -eq 0 ]
    [ -f "$CHANNEL_DIR/state.json" ]
    
    # Verify state file structure
    run jq -r '.start_time' "$CHANNEL_DIR/state.json"
    [ "$status" -eq 0 ]
    [ "$output" -gt 0 ]
    
    run jq -r '.total_duration' "$CHANNEL_DIR/state.json"
    [ "$status" -eq 0 ]
    [ "$output" -eq 390 ]  # 120 + 180 + 90
}

@test "channel_tracker status shows correct information" {
    # Initialize channel first
    "$SCRIPT_DIR/channel_tracker.sh" "$CHANNEL_DIR" init
    
    run "$SCRIPT_DIR/channel_tracker.sh" "$CHANNEL_DIR" status
    
    [ "$status" -eq 0 ]
    [[ "$output" == *"Channel Status:"* ]]
    [[ "$output" == *"Total Playlist Duration: 390s"* ]]
    [[ "$output" == *"Current Video: test_video1.mp4"* ]]
}

@test "channel_tracker handles missing playlist file" {
    rm -f "$CHANNEL_DIR/playlist.txt"
    
    run "$SCRIPT_DIR/channel_tracker.sh" "$CHANNEL_DIR" init
    
    [ "$status" -ne 0 ]
    [[ "$output" == *"ERROR: Playlist file not found"* ]]
}

@test "channel_tracker handles missing state file" {
    run "$SCRIPT_DIR/channel_tracker.sh" "$CHANNEL_DIR" status
    
    [ "$status" -ne 0 ]
    [[ "$output" == *"ERROR: Channel state file not found"* ]]
}

@test "channel_tracker calculates elapsed time correctly" {
    # Initialize channel
    "$SCRIPT_DIR/channel_tracker.sh" "$CHANNEL_DIR" init
    
    # Wait a moment
    sleep 2
    
    run "$SCRIPT_DIR/channel_tracker.sh" "$CHANNEL_DIR" status
    
    [ "$status" -eq 0 ]
    [[ "$output" == *"Elapsed Time:"* ]]
    [[ "$output" == *"s"* ]]
}

@test "channel_tracker handles empty playlist" {
    echo "" > "$CHANNEL_DIR/playlist.txt"
    
    run "$SCRIPT_DIR/channel_tracker.sh" "$CHANNEL_DIR" init
    
    [ "$status" -eq 0 ]
    [ -f "$CHANNEL_DIR/state.json" ]
    
    run jq -r '.total_duration' "$CHANNEL_DIR/state.json"
    [ "$output" -eq 0 ]
}
