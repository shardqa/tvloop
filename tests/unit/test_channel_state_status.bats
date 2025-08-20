#!/usr/bin/env bats

setup() {
    # Get the project root directory
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PROJECT_ROOT="$(dirname "$(dirname "$DIR")")"
    
    # Load bats libraries from project root
    load "$PROJECT_ROOT/node_modules/bats-support/load"
    load "$PROJECT_ROOT/node_modules/bats-assert/load"
    
    # Source the channel_state.sh file
    source "$PROJECT_ROOT/core/channel_state.sh"
    
    # Create temporary test directory
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
    
    # Create test channel directory
    CHANNEL_DIR="$TEST_DIR/test_channel"
    mkdir -p "$CHANNEL_DIR"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "get_channel_status with missing state file" {
    run get_channel_status "$CHANNEL_DIR"
    assert_failure
    assert_output --partial "Channel state file not found"
}

@test "get_channel_status with invalid state file" {
    # Create invalid JSON state file
    echo "invalid json" > "$CHANNEL_DIR/state.json"
    
    run get_channel_status "$CHANNEL_DIR"
    # Function continues despite invalid JSON, just logs errors
    assert_success
    assert_output --partial "ERROR"
}

@test "get_channel_status with missing playlist file" {
    # Create valid state file
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 100,
    "playlist_file": "$CHANNEL_DIR/playlist.txt"
}
EOF
    
    run get_channel_status "$CHANNEL_DIR"
    # Function continues despite missing playlist, just logs errors
    assert_success
    assert_output --partial "ERROR"
    assert_output --partial "Playlist file not found"
}

@test "get_channel_status with valid setup" {
    # Create test video files
    echo "test content" > "$CHANNEL_DIR/video1.mp4"
    echo "test content" > "$CHANNEL_DIR/video2.mp4"
    
    # Create valid playlist
    echo "$CHANNEL_DIR/video1.mp4|Video 1|50" > "$CHANNEL_DIR/playlist.txt"
    echo "$CHANNEL_DIR/video2.mp4|Video 2|75" >> "$CHANNEL_DIR/playlist.txt"
    
    # Create valid state file
    local start_time=$(date +%s)
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $start_time,
    "total_duration": 125,
    "playlist_file": "$CHANNEL_DIR/playlist.txt"
}
EOF
    
    run get_channel_status "$CHANNEL_DIR"
    assert_success
    assert_output --partial "Channel Status:"
    assert_output --partial "Total Playlist Duration: 125s"
    assert_output --partial "Current Video: video1.mp4"
}
