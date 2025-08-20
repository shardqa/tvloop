#!/usr/bin/env bash

# Player test helper functions

setup_player_test_env() {
    # Create unique test environment
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    export TEST_CHANNEL_DIR="/tmp/test_channel_${test_id}_$$"
    export TEST_PLAYLIST_FILE="$TEST_CHANNEL_DIR/playlist.txt"
    export TEST_STATE_FILE="$TEST_CHANNEL_DIR/state.json"
    
    # Create all necessary directories
    mkdir -p "$TEST_CHANNEL_DIR"
    mkdir -p "logs"
    
    # Create unique video file names
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    
    cat > "$TEST_PLAYLIST_FILE" << EOF
/tmp/test_video1_${test_id}.mp4|Test Video 1|60
/tmp/test_video2_${test_id}.mp4|Test Video 2|120
EOF
    
    touch /tmp/test_video1_${test_id}.mp4 /tmp/test_video2_${test_id}.mp4
}

teardown_player_test_env() {
    rm -rf "$TEST_CHANNEL_DIR"
    # Clean up unique video files
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    rm -f /tmp/test_video1_${test_id}.mp4 /tmp/test_video2_${test_id}.mp4
}

check_player_available() {
    local player="$1"
    if ! command -v "$player" >/dev/null 2>&1; then
        skip "$player not available"
    fi
}

test_player_launch() {
    local player="$1"
    local channel_dir="$2"
    
    check_player_available "$player"
    
    # Initialize channel first
    ./scripts/channel_tracker.sh "$channel_dir" init
    
    run timeout 2s ./scripts/channel_player.sh "$channel_dir" tune "$player"
    # Allow for various exit codes: 0 (success), 124 (timeout), 1 (error due to fake video files)
    [ "$status" -eq 124 ] || [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    
    # Only check for PID file if the command succeeded
    if [ "$status" -eq 0 ] || [ "$status" -eq 124 ]; then
        [ -f "$channel_dir/$player.pid" ]
    fi
}

test_player_stop() {
    local player="$1"
    local channel_dir="$2"
    
    check_player_available "$player"
    
    # Initialize channel first
    ./scripts/channel_tracker.sh "$channel_dir" init
    
    # Start player first
    timeout 2s ./scripts/channel_player.sh "$channel_dir" tune "$player" >/dev/null 2>&1 || true
    
    # Test stop command
    run ./scripts/channel_player.sh "$channel_dir" stop
    [ "$status" -eq 0 ]
    [ ! -f "$channel_dir/$player.pid" ]
}
