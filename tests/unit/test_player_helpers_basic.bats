#!/usr/bin/env bats

# Basic setup and teardown tests for player_helpers.bash
# Part 1 of the split test file

setup() {
    load '../test_helper/player_helpers'
    # Create unique test environment
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    export TEST_DIR="/tmp/tvloop_test_${test_id}_$$"
    export TEST_CHANNEL_DIR="$TEST_DIR/channel"
    export TEST_PLAYLIST_FILE="$TEST_CHANNEL_DIR/playlist.txt"
    export TEST_STATE_FILE="$TEST_CHANNEL_DIR/state.json"
    
    mkdir -p "$TEST_CHANNEL_DIR"
    
    # Create test playlist with unique video files
    cat > "$TEST_PLAYLIST_FILE" << EOF
/tmp/test_video1_${test_id}.mp4|Test Video 1|60
/tmp/test_video2_${test_id}.mp4|Test Video 2|120
EOF
    
    # Create test video files
    touch /tmp/test_video1_${test_id}.mp4 /tmp/test_video2_${test_id}.mp4
}

teardown() {
    rm -rf "$TEST_DIR"
    # Clean up unique video files
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    rm -f /tmp/test_video1_${test_id}.mp4 /tmp/test_video2_${test_id}.mp4
}

@test "setup_player_test_env creates test environment correctly" {
    # Test the setup function directly
    setup_player_test_env
    
    [ -d "$TEST_CHANNEL_DIR" ]
    [ -f "$TEST_PLAYLIST_FILE" ]
    
    # Check playlist content
    grep -q "Test Video 1" "$TEST_PLAYLIST_FILE"
    grep -q "Test Video 2" "$TEST_PLAYLIST_FILE"
    
    # Clean up
    teardown_player_test_env
}

@test "teardown_player_test_env cleans up correctly" {
    # Setup first
    setup_player_test_env
    
    # Verify files exist
    [ -d "$TEST_CHANNEL_DIR" ]
    [ -f "$TEST_PLAYLIST_FILE" ]
    
    # Run teardown
    teardown_player_test_env
    
    # Verify cleanup
    [ ! -d "$TEST_CHANNEL_DIR" ]
    [ ! -f "$TEST_PLAYLIST_FILE" ]
}

@test "check_player_available with available player" {
    # Test with a player that should be available (bash)
    check_player_available "bash"
    # If bash is available, this should not skip
    # If it's not available, it would skip
}

@test "check_player_available with unavailable player" {
    # Test with a player that should not be available
    # This should trigger the skip path
    if command -v "nonexistent_player_xyz123" >/dev/null 2>&1; then
        skip "nonexistent_player_xyz123 is somehow available"
    fi
    
    # This should call skip() if the player is not available
    # We can't easily test the skip behavior directly, but we can ensure the function doesn't crash
    check_player_available "nonexistent_player_xyz123"
}
