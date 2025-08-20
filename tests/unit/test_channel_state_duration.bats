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

@test "get_channel_status with zero duration" {
    # Create test video file
    echo "test content" > "$CHANNEL_DIR/video1.mp4"
    
    # Create playlist with zero duration
    echo "$CHANNEL_DIR/video1.mp4|Video 1|0" > "$CHANNEL_DIR/playlist.txt"
    
    # Create state file with zero duration
    local start_time=$(date +%s)
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $start_time,
    "total_duration": 0,
    "playlist_file": "$CHANNEL_DIR/playlist.txt"
}
EOF
    
    run get_channel_status "$CHANNEL_DIR"
    assert_success
    assert_output --partial "Total Playlist Duration: 0s"
}

@test "get_channel_status with very large duration" {
    # Create test video file
    echo "test content" > "$CHANNEL_DIR/video1.mp4"
    
    # Create playlist with large duration
    echo "$CHANNEL_DIR/video1.mp4|Video 1|999999" > "$CHANNEL_DIR/playlist.txt"
    
    # Create state file with large duration
    local start_time=$(date +%s)
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $start_time,
    "total_duration": 999999,
    "playlist_file": "$CHANNEL_DIR/playlist.txt"
}
EOF
    
    run get_channel_status "$CHANNEL_DIR"
    assert_success
    assert_output --partial "Total Playlist Duration: 999999s"
}

@test "get_channel_status with elapsed time in second video" {
    # Create test video files
    echo "test content" > "$CHANNEL_DIR/video1.mp4"
    echo "test content" > "$CHANNEL_DIR/video2.mp4"
    
    # Create playlist with 50s + 75s videos
    echo "$CHANNEL_DIR/video1.mp4|Video 1|50" > "$CHANNEL_DIR/playlist.txt"
    echo "$CHANNEL_DIR/video2.mp4|Video 2|75" >> "$CHANNEL_DIR/playlist.txt"
    
    # Create state file with elapsed time in second video (75 seconds ago)
    local start_time=$(( $(date +%s) - 75 ))
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $start_time,
    "total_duration": 125,
    "playlist_file": "$CHANNEL_DIR/playlist.txt"
}
EOF
    
    run get_channel_status "$CHANNEL_DIR"
    assert_success
    assert_output --partial "Current Video: video2.mp4"
}
