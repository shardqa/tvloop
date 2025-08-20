#!/usr/bin/env bats

# Basic player launch functionality tests for player_helpers.bash
# Part 1 of the split launch test file

setup() {
    load '../test_helper/player_helpers'
    export TEST_DIR="/tmp/tvloop_test_$$"
    export TEST_CHANNEL_DIR="$TEST_DIR/channel"
    export TEST_PLAYLIST_FILE="$TEST_CHANNEL_DIR/playlist.txt"
    export TEST_STATE_FILE="$TEST_CHANNEL_DIR/state.json"
    
    mkdir -p "$TEST_CHANNEL_DIR"
    
    # Create test playlist
    cat > "$TEST_PLAYLIST_FILE" << EOF
/tmp/test_video1.mp4|Test Video 1|60
/tmp/test_video2.mp4|Test Video 2|120
EOF
    
    # Create test video files
    touch /tmp/test_video1.mp4 /tmp/test_video2.mp4
}

teardown() {
    rm -rf "$TEST_DIR"
    rm -f /tmp/test_video1.mp4 /tmp/test_video2.mp4
}

@test "test_player_launch with available player" {
    # Initialize channel first
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    # Test with mpv if available
    if command -v mpv >/dev/null 2>&1; then
        test_player_launch "mpv" "$TEST_CHANNEL_DIR"
        [ -f "$TEST_CHANNEL_DIR/mpv.pid" ]
        
        # Clean up
        ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" stop >/dev/null 2>&1 || true
    else
        # Test with vlc if mpv not available
        if command -v vlc >/dev/null 2>&1; then
            test_player_launch "vlc" "$TEST_CHANNEL_DIR"
            [ -f "$TEST_CHANNEL_DIR/vlc.pid" ]
            
            # Clean up
            ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" stop >/dev/null 2>&1 || true
        else
            skip "No video players available for testing"
        fi
    fi
}

@test "test_player_launch with unavailable player" {
    # Initialize channel first
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    # Test with a player that doesn't exist
    if command -v "nonexistent_player_xyz123" >/dev/null 2>&1; then
        skip "nonexistent_player_xyz123 is somehow available"
    fi
    
    # This should skip the test
    test_player_launch "nonexistent_player_xyz123" "$TEST_CHANNEL_DIR"
}

@test "test_player_launch timeout handling" {
    # Initialize channel first
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    # Test that the timeout handling works correctly
    if command -v mpv >/dev/null 2>&1; then
        # The test_player_launch function uses timeout 2s, so it should handle timeouts
        test_player_launch "mpv" "$TEST_CHANNEL_DIR"
        
        # Clean up
        ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" stop >/dev/null 2>&1 || true
    else
        skip "mpv not available for timeout testing"
    fi
}
