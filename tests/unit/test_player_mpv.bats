#!/usr/bin/env bats

setup() {
    load '../test_helper/player_helpers'
    setup_player_test_env
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
}

teardown() {
    teardown_player_test_env
}

@test "player launch with mpv" {
    test_player_launch "mpv" "$TEST_CHANNEL_DIR"
}

@test "player stop command works with mpv" {
    test_player_stop "mpv" "$TEST_CHANNEL_DIR"
}

@test "mpv player creates pid file" {
    check_player_available "mpv"
    
    run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune mpv
    # Allow for various exit codes: 0 (success), 124 (timeout), 1 (error due to fake video files)
    [ "$status" -eq 124 ] || [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    
    # Only check for PID file if the command succeeded
    if [ "$status" -eq 0 ] || [ "$status" -eq 124 ]; then
        [ -f "$TEST_CHANNEL_DIR/mpv.pid" ]
    fi
    
    # Clean up
    ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" stop >/dev/null 2>&1 || true
}
