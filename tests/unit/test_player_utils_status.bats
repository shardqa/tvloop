#!/usr/bin/env bats

setup() {
    # Get the project root directory
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PROJECT_ROOT="$(dirname "$(dirname "$DIR")")"
    
    # Load bats libraries from project root
    load "$PROJECT_ROOT/node_modules/bats-support/load"
    load "$PROJECT_ROOT/node_modules/bats-assert/load"
    
    # Source the player_utils.sh file
    source "$PROJECT_ROOT/players/player_utils.sh"
    
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

@test "show_player_status with no pid files" {
    run show_player_status "$CHANNEL_DIR"
    assert_success
    assert_output --partial "mpv not running"
    assert_output --partial "VLC not running"
}

@test "show_player_status with stale pid files" {
    # Create PID files with non-existent PIDs
    echo "999999" > "$CHANNEL_DIR/mpv.pid"
    echo "999998" > "$CHANNEL_DIR/vlc.pid"
    
    run show_player_status "$CHANNEL_DIR"
    assert_success
    assert_output --partial "mpv not running (stale PID file)"
    assert_output --partial "VLC not running (stale PID file)"
    
    # PID files should be removed
    assert [ ! -f "$CHANNEL_DIR/mpv.pid" ]
    assert [ ! -f "$CHANNEL_DIR/vlc.pid" ]
}

@test "show_player_status with valid pid files" {
    # Start background processes
    sleep 100 &
    local mpv_pid=$!
    sleep 100 &
    local vlc_pid=$!
    
    # Create PID files
    echo "$mpv_pid" > "$CHANNEL_DIR/mpv.pid"
    echo "$vlc_pid" > "$CHANNEL_DIR/vlc.pid"
    
    run show_player_status "$CHANNEL_DIR"
    assert_success
    assert_output --partial "mpv running (PID: $mpv_pid)"
    assert_output --partial "VLC running (PID: $vlc_pid)"
    
    # Clean up processes
    kill "$mpv_pid" "$vlc_pid" 2>/dev/null
}
