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

@test "get_current_video_position with missing state file" {
    run get_current_video_position "$CHANNEL_DIR"
    assert_failure
    assert_output --partial "Channel state file not found"
}

@test "get_current_video_position with invalid state file" {
    # Create invalid JSON state file
    echo "invalid json" > "$CHANNEL_DIR/state.json"
    
    run get_current_video_position "$CHANNEL_DIR"
    assert_failure
}

@test "get_current_video_position with zero total duration" {
    # Create valid state file with zero duration
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 0
}
EOF
    
    run get_current_video_position "$CHANNEL_DIR"
    assert_failure
    assert_output --partial "Total duration is 0"
}

@test "get_current_video_position with missing playlist file" {
    # Create valid state file
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 100
}
EOF
    
    run get_current_video_position "$CHANNEL_DIR"
    assert_failure
}

@test "get_current_video_position with empty playlist file" {
    # Create valid state file
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 100
}
EOF
    
    # Create empty playlist file
    touch "$CHANNEL_DIR/playlist.txt"
    
    run get_current_video_position "$CHANNEL_DIR"
    assert_failure
    assert_output --partial "Could not determine current video position"
}
