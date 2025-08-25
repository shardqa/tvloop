#!/usr/bin/env bash

# Player test helper environment functions

setup_player_test_env() {
    # Create unique test environment
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    export TEST_CHANNEL_DIR="/tmp/test_channel_${test_id}_$$"
    export TEST_PLAYLIST_FILE="$TEST_CHANNEL_DIR/playlist.txt"
    export TEST_STATE_FILE="$TEST_CHANNEL_DIR/state.json"
    
    # Enable headless mode for testing
    export TEST_MODE="true"
    
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
