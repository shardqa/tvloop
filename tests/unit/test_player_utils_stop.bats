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

@test "stop_player with non-existent pid file" {
    run stop_player "$CHANNEL_DIR" "mpv"
    assert_success
    assert_output --partial "No mpv PID file found"
}

@test "stop_player with stale pid file" {
    # Create PID file with non-existent process ID
    echo "999999" > "$CHANNEL_DIR/mpv.pid"
    
    run stop_player "$CHANNEL_DIR" "mpv"
    assert_success
    assert_output --partial "mpv process (PID: 999999) not found"
    
    # PID file should be removed
    assert [ ! -f "$CHANNEL_DIR/mpv.pid" ]
}

@test "stop_player with valid pid file" {
    # Start a background process to have a valid PID
    sleep 100 &
    local pid=$!
    
    # Create PID file
    echo "$pid" > "$CHANNEL_DIR/mpv.pid"
    
    run stop_player "$CHANNEL_DIR" "mpv"
    assert_success
    assert_output --partial "Stopping mpv (PID: $pid)"
    
    # PID file should be removed
    assert [ ! -f "$CHANNEL_DIR/mpv.pid" ]
    
    # Process should be terminated
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null
    fi
}

@test "stop_all_players with no pid files" {
    run stop_all_players "$TEST_DIR"
    assert_success
    # Should not produce any output when no PID files exist
    assert_output ""
}

@test "stop_all_players with multiple pid files" {
    # Create multiple channel directories with PID files
    mkdir -p "$TEST_DIR/channel1" "$TEST_DIR/channel2"
    
    # Create PID files with non-existent PIDs
    echo "999999" > "$TEST_DIR/channel1/mpv.pid"
    echo "999998" > "$TEST_DIR/channel2/mpv.pid"
    
    run stop_all_players "$TEST_DIR"
    assert_success
    
    # PID files should be removed
    assert [ ! -f "$TEST_DIR/channel1/mpv.pid" ]
    assert [ ! -f "$TEST_DIR/channel2/mpv.pid" ]
}
