#!/usr/bin/env bats

# Player launch error handling and edge case tests for player_helpers.bash
# Part 2 of the split launch test file

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

@test "test_player_launch with missing channel directory" {
    # Test with a non-existent channel directory
    if command -v mpv >/dev/null 2>&1; then
        run timeout 2s ./scripts/channel_player.sh "/nonexistent/channel" tune mpv
        # Should handle the error gracefully
        [ "$status" -ne 0 ]
    else
        skip "mpv not available for missing directory testing"
    fi
}

@test "test_player_launch with missing playlist file" {
    # Initialize channel but remove playlist
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    rm -f "$TEST_PLAYLIST_FILE"
    
    if command -v mpv >/dev/null 2>&1; then
        run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune mpv
        # Should handle missing playlist gracefully
        [ "$status" -ne 0 ]
    else
        skip "mpv not available for missing playlist testing"
    fi
}

@test "test_player_launch with empty playlist" {
    # Initialize channel but create empty playlist
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    echo "" > "$TEST_PLAYLIST_FILE"
    
    if command -v mpv >/dev/null 2>&1; then
        run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune mpv
        # Should handle empty playlist gracefully
        [ "$status" -ne 0 ]
    else
        skip "mpv not available for empty playlist testing"
    fi
}

@test "test_player_launch with invalid playlist format" {
    # Initialize channel but create invalid playlist
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    echo "invalid_format_without_pipes" > "$TEST_PLAYLIST_FILE"
    
    if command -v mpv >/dev/null 2>&1; then
        run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune mpv
        # Should handle invalid format gracefully
        [ "$status" -ne 0 ]
    else
        skip "mpv not available for invalid format testing"
    fi
}

@test "test_player_launch with missing video files" {
    # Initialize channel but remove video files
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    rm -f /tmp/test_video1.mp4 /tmp/test_video2.mp4
    
    if command -v mpv >/dev/null 2>&1; then
        run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune mpv
        # Should handle missing video files gracefully
        [ "$status" -ne 0 ]
    else
        skip "mpv not available for missing video files testing"
    fi
}
