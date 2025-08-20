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

@test "get_current_video_position with invalid playlist format" {
    # Create valid state file
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 100
}
EOF
    
    # Create playlist with invalid format
    echo "invalid_format" > "$CHANNEL_DIR/playlist.txt"
    
    run get_current_video_position "$CHANNEL_DIR"
    assert_failure
}

@test "get_current_video_position with missing video files" {
    # Create valid state file
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $(date +%s),
    "total_duration": 100
}
EOF
    
    # Create playlist with non-existent video files
    echo "/nonexistent/video1.mp4|Video 1|50" > "$CHANNEL_DIR/playlist.txt"
    echo "/nonexistent/video2.mp4|Video 2|50" >> "$CHANNEL_DIR/playlist.txt"
    
    run get_current_video_position "$CHANNEL_DIR"
    assert_failure
    assert_output --partial "Could not determine current video position"
}
