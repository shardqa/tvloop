#!/usr/bin/env bash

# Player test helper stop functions

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
