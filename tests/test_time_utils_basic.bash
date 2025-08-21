#!/usr/bin/env bash

# Time Utils Basic Tests - Bashunit Version
# Tests for basic time utility functions

source "$(pwd)/tests/test_helper.bash"
source "$(pwd)/core/time_utils.sh"

function set_up() {
    # Create temporary test directory
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
}

function tear_down() {
    rm -rf "$TEST_DIR"
}

function test_get_current_timestamp_returns_valid_timestamp() {
    local timestamp
    timestamp=$(get_current_timestamp)
    
    # Assert it's a valid number
    assert_matches "^[0-9]+$" "$timestamp"
    
    # Verify it's a reasonable timestamp (not too old, not in the future)
    local current_time=$(date +%s)
    local diff=$((current_time - timestamp))
    
    # Should be within 5 seconds (use basic comparisons)
    [ "$diff" -ge -5 ] || fail "Timestamp diff $diff should be >= -5"
    [ "$diff" -le 5 ] || fail "Timestamp diff $diff should be <= 5"
}

function test_calculate_elapsed_time_calculates_correct_elapsed_time() {
    local start_time=$(date +%s)
    sleep 1
    local elapsed
    elapsed=$(calculate_elapsed_time "$start_time")
    
    # Assert it's a valid number
    assert_matches "^[0-9]+$" "$elapsed"
    
    # Should be approximately 1 second (allow some tolerance)
    [ "$elapsed" -ge 1 ] || fail "Elapsed time $elapsed should be >= 1"
    [ "$elapsed" -le 3 ] || fail "Elapsed time $elapsed should be <= 3"
}

function test_calculate_elapsed_time_with_future_start_time_returns_negative() {
    local future_time=$(( $(date +%s) + 100 ))
    local elapsed
    elapsed=$(calculate_elapsed_time "$future_time")
    
    # Assert it's a valid number (possibly negative)
    assert_matches "^-?[0-9]+$" "$elapsed"
    
    # Should be negative
    [ "$elapsed" -lt 0 ] || fail "Elapsed time $elapsed should be < 0"
}

function test_get_video_duration_with_ffprobe_available() {
    # Create a mock video file
    echo "mock video content" > "$TEST_DIR/test_video.mp4"
    
    # Mock ffprobe to return a duration
    mock ffprobe echo "120.5"
    
    local duration
    duration=$(get_video_duration "$TEST_DIR/test_video.mp4")
    
    assert_equals "120" "$duration"
}

function test_get_video_duration_without_ffprobe_returns_0() {
    # Create a mock video file
    echo "mock video content" > "$TEST_DIR/test_video.mp4"
    
    # Mock command to make ffprobe unavailable
    function command() {
        if [[ "$2" == "ffprobe" ]]; then
            return 1
        fi
        builtin command "$@"
    }
    export -f command
    
    local duration
    duration=$(get_video_duration "$TEST_DIR/test_video.mp4")
    
    # The function returns "0" when ffprobe is not available
    assert_equals "0" "$duration"
    
    # Restore original command function
    unset -f command
}
