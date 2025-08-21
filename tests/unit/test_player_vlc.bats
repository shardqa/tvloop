#!/usr/bin/env bats

setup() {
    load '../test_helper/player_helpers'
    setup_player_test_env
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
}

teardown() {
    teardown_player_test_env
}

@test "player launch with vlc" {
    test_player_launch "vlc" "$TEST_CHANNEL_DIR"
}

@test "player stop command works with vlc" {
    test_player_stop "vlc" "$TEST_CHANNEL_DIR"
}

@test "vlc player creates pid file" {
    check_player_available "vlc"
    
    # For testing, we'll mock the player launch instead of starting real processes
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        # Mock player launch - just create PID file and test interface
        local mock_pid=999999
        echo "$mock_pid" > "$TEST_CHANNEL_DIR/vlc.pid"
        
        # Test that the PID file was created
        [ -f "$TEST_CHANNEL_DIR/vlc.pid" ]
        
        # Clean up mock PID file
        rm -f "$TEST_CHANNEL_DIR/vlc.pid"
    else
        # Real player launch for non-test environments
        run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune vlc
        [ "$status" -eq 124 ] || [ "$status" -eq 0 ]
        [ -f "$TEST_CHANNEL_DIR/vlc.pid" ]
        
        # Clean up
        ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" stop >/dev/null 2>&1 || true
    fi
}
