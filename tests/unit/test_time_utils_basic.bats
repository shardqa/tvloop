#!/usr/bin/env bats

setup() {
    # Get the project root directory
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PROJECT_ROOT="$(dirname "$(dirname "$DIR")")"
    
    # Load bats libraries from project root
    load "$PROJECT_ROOT/node_modules/bats-support/load"
    load "$PROJECT_ROOT/node_modules/bats-assert/load"
    
    # Source the time_utils.sh file
    source "$PROJECT_ROOT/core/time_utils.sh"
    
    # Create temporary test directory
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "get_current_timestamp returns valid timestamp" {
    run get_current_timestamp
    assert_success
    assert_output --regexp '^[0-9]+$'
    
    # Verify it's a reasonable timestamp (not too old, not in the future)
    local timestamp=$output
    local current_time=$(date +%s)
    local diff=$((current_time - timestamp))
    
    # Should be within 5 seconds
    assert [ $diff -ge -5 ]
    assert [ $diff -le 5 ]
}

@test "calculate_elapsed_time calculates correct elapsed time" {
    local start_time=$(date +%s)
    sleep 1
    run calculate_elapsed_time "$start_time"
    assert_success
    assert_output --regexp '^[0-9]+$'
    
    local elapsed=$output
    # Should be approximately 1 second (allow some tolerance)
    assert [ $elapsed -ge 1 ]
    assert [ $elapsed -le 3 ]
}

@test "calculate_elapsed_time with future start time returns negative" {
    local future_time=$(( $(date +%s) + 100 ))
    run calculate_elapsed_time "$future_time"
    assert_success
    assert_output --regexp '^-?[0-9]+$'
    
    local elapsed=$output
    assert [ $elapsed -lt 0 ]
}

@test "get_video_duration with ffprobe available" {
    # Create a mock video file
    echo "mock video content" > "$TEST_DIR/test_video.mp4"
    
    # Mock ffprobe to return a duration
    function ffprobe() {
        echo "120.5"
    }
    export -f ffprobe
    
    run get_video_duration "$TEST_DIR/test_video.mp4"
    assert_success
    assert_output "120"
}

@test "get_video_duration without ffprobe returns 0" {
    # Create a mock video file
    echo "mock video content" > "$TEST_DIR/test_video.mp4"
    
    # Mock ffprobe to be unavailable
    function command() {
        if [[ "$2" == "ffprobe" ]]; then
            return 1
        fi
        builtin command "$@"
    }
    export -f command
    
    run get_video_duration "$TEST_DIR/test_video.mp4"
    assert_success
    # The function returns "0" when ffprobe is not available
    assert_output "0"
    
    # Restore original command function
    unset -f command
}
