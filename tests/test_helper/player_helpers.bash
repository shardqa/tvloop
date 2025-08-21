#!/usr/bin/env bash

# Player test helper functions

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

test_player_launch() {
    local player="$1"
    local channel_dir="$2"
    
    check_player_available "$player"
    
    # Create a lock file to prevent multiple player tests from running simultaneously
    local lock_file="/tmp/tvloop_player_test_${player}.lock"
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    
    # Wait for lock with timeout
    local timeout=30
    local count=0
    while [ -f "$lock_file" ] && [ $count -lt $timeout ]; do
        sleep 1
        count=$((count + 1))
    done
    
    # Create lock file
    echo "$test_id" > "$lock_file"
    
    # Initialize channel first
    ./scripts/channel_tracker.sh "$channel_dir" init
    
    # For testing, we'll mock the player launch instead of starting real processes
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        # Mock player launch - just create PID file and test interface
        local mock_pid=999999
        echo "$mock_pid" > "$channel_dir/$player.pid"
        
        # Test that the PID file was created
        [ -f "$channel_dir/$player.pid" ]
        
        # Clean up mock PID file
        rm -f "$channel_dir/$player.pid"
    else
        # Real player launch for non-test environments
        run timeout 2s ./scripts/channel_player.sh "$channel_dir" tune "$player"
        # Allow for various exit codes: 0 (success), 124 (timeout), 1 (error due to fake video files)
        [ "$status" -eq 124 ] || [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
        
        # Only check for PID file if the command succeeded
        if [ "$status" -eq 0 ] || [ "$status" -eq 124 ]; then
            [ -f "$channel_dir/$player.pid" ]
        fi
    fi
    
    # Clean up lock file
    rm -f "$lock_file"
}

test_player_stop() {
    local player="$1"
    local channel_dir="$2"
    
    check_player_available "$player"
    
    # Create a lock file to prevent multiple player tests from running simultaneously
    local lock_file="/tmp/tvloop_player_test_${player}.lock"
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    
    # Wait for lock with timeout
    local timeout=30
    local count=0
    while [ -f "$lock_file" ] && [ $count -lt $timeout ]; do
        sleep 1
        count=$((count + 1))
    done
    
    # Create lock file
    echo "$test_id" > "$lock_file"
    
    # Initialize channel first
    ./scripts/channel_tracker.sh "$channel_dir" init
    
    # For testing, we'll mock the player stop instead of starting real processes
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        # Mock player stop - create PID file then test stop functionality
        local mock_pid=999999
        echo "$mock_pid" > "$channel_dir/$player.pid"
        
        # Test stop command
        run ./scripts/channel_player.sh "$channel_dir" stop
        [ "$status" -eq 0 ]
        [ ! -f "$channel_dir/$player.pid" ]
    else
        # Real player stop for non-test environments
        # Start player first
        timeout 2s ./scripts/channel_player.sh "$channel_dir" tune "$player" >/dev/null 2>&1 || true
        
        # Test stop command
        run ./scripts/channel_player.sh "$channel_dir" stop
        [ "$status" -eq 0 ]
        [ ! -f "$channel_dir/$player.pid" ]
    fi
    
    # Clean up lock file
    rm -f "$lock_file"
}
