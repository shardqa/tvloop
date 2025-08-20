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

@test "initialize_channel with missing playlist file" {
    run initialize_channel "$CHANNEL_DIR"
    assert_failure
    assert_output --partial "Playlist file not found"
}

@test "initialize_channel with empty playlist file" {
    # Create empty playlist file
    touch "$CHANNEL_DIR/playlist.txt"
    
    run initialize_channel "$CHANNEL_DIR"
    assert_success
    
    # State file should be created with zero duration
    assert [ -f "$CHANNEL_DIR/state.json" ]
    run jq -r '.total_duration' "$CHANNEL_DIR/state.json"
    assert_output "0"
}

@test "initialize_channel with invalid playlist format" {
    # Create playlist with invalid format
    echo "invalid_format" > "$CHANNEL_DIR/playlist.txt"
    
    run initialize_channel "$CHANNEL_DIR"
    assert_success
    
    # State file should be created with zero duration
    assert [ -f "$CHANNEL_DIR/state.json" ]
    run jq -r '.total_duration' "$CHANNEL_DIR/state.json"
    assert_output "0"
}

@test "initialize_channel with valid playlist" {
    # Create test video files
    echo "test content" > "$CHANNEL_DIR/video1.mp4"
    echo "test content" > "$CHANNEL_DIR/video2.mp4"
    
    # Create valid playlist
    echo "$CHANNEL_DIR/video1.mp4|Video 1|50" > "$CHANNEL_DIR/playlist.txt"
    echo "$CHANNEL_DIR/video2.mp4|Video 2|75" >> "$CHANNEL_DIR/playlist.txt"
    
    run initialize_channel "$CHANNEL_DIR"
    assert_success
    
    # State file should be created
    assert [ -f "$CHANNEL_DIR/state.json" ]
    
    # Check state file structure
    run jq -r '.start_time' "$CHANNEL_DIR/state.json"
    assert_success
    assert_output --regexp '^[0-9]+$'
    
    run jq -r '.total_duration' "$CHANNEL_DIR/state.json"
    assert_success
    assert_output "125"  # 50 + 75
    
    run jq -r '.playlist_file' "$CHANNEL_DIR/state.json"
    assert_success
    assert_output "$CHANNEL_DIR/playlist.txt"
}
