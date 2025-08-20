#!/usr/bin/env bash

# Player test helper functions

setup_player_test_env() {
    export TEST_CHANNEL_DIR="/tmp/test_channel_$$"
    export TEST_PLAYLIST_FILE="$TEST_CHANNEL_DIR/playlist.txt"
    export TEST_STATE_FILE="$TEST_CHANNEL_DIR/state.json"
    
    mkdir -p "$TEST_CHANNEL_DIR"
    
    cat > "$TEST_PLAYLIST_FILE" << EOF
/tmp/test_video1.mp4|Test Video 1|60
/tmp/test_video2.mp4|Test Video 2|120
EOF
    
    touch /tmp/test_video1.mp4 /tmp/test_video2.mp4
}

teardown_player_test_env() {
    rm -rf "$TEST_CHANNEL_DIR"
    rm -f /tmp/test_video1.mp4 /tmp/test_video2.mp4
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
    
    run timeout 2s ./scripts/channel_player.sh "$channel_dir" tune "$player"
    [ "$status" -eq 124 ] || [ "$status" -eq 0 ]
    [ -f "$channel_dir/$player.pid" ]
}

test_player_stop() {
    local player="$1"
    local channel_dir="$2"
    
    check_player_available "$player"
    
    # Start player first
    timeout 2s ./scripts/channel_player.sh "$channel_dir" tune "$player" >/dev/null 2>&1 || true
    
    # Test stop command
    run ./scripts/channel_player.sh "$channel_dir" stop
    [ "$status" -eq 0 ]
    [ ! -f "$channel_dir/$player.pid" ]
}
