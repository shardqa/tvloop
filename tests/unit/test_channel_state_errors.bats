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

@test "initialize_channel with missing video files" {
    # Create playlist with non-existent video files
    echo "/nonexistent/video1.mp4|Video 1|50" > "$CHANNEL_DIR/playlist.txt"
    echo "/nonexistent/video2.mp4|Video 2|75" >> "$CHANNEL_DIR/playlist.txt"
    
    run initialize_channel "$CHANNEL_DIR"
    assert_success
    
    # State file should be created with zero duration (missing files are skipped)
    assert [ -f "$CHANNEL_DIR/state.json" ]
    run jq -r '.total_duration' "$CHANNEL_DIR/state.json"
    assert_output "0"
}

@test "get_channel_status with malformed playlist entries" {
    # Create test video file
    echo "test content" > "$CHANNEL_DIR/video1.mp4"
    
    # Create playlist with malformed entries
    echo "$CHANNEL_DIR/video1.mp4|Video 1|50" > "$CHANNEL_DIR/playlist.txt"
    echo "malformed_entry" >> "$CHANNEL_DIR/playlist.txt"
    echo "$CHANNEL_DIR/video1.mp4|Video 3|invalid_duration" >> "$CHANNEL_DIR/playlist.txt"
    
    # Create state file
    local start_time=$(date +%s)
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $start_time,
    "total_duration": 50,
    "playlist_file": "$CHANNEL_DIR/playlist.txt"
}
EOF
    
    run get_channel_status "$CHANNEL_DIR"
    assert_success
    assert_output --partial "Current Video: video1.mp4"
}
