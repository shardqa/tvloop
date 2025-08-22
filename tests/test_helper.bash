#!/bin/bash

# Bashunit Test Helper
# Common setup and utilities for all tests

# Source project modules
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_api.sh"

# Test environment setup
setup_test_environment() {
    # Create unique test directory with process ID, timestamp, and random component
    local timestamp=$(date +%s%N)
    local random=$(( RANDOM % 10000 ))
    export TEST_DIR="/tmp/tvloop_test_$$_${timestamp}_${random}"
    export CHANNEL_DIR="$TEST_DIR/channel_1"
    export SCRIPT_DIR="scripts"
    export TEST_MODE="true"
    
    mkdir -p "$CHANNEL_DIR"
    mkdir -p "$TEST_DIR"
}

# Test environment cleanup
teardown_test_environment() {
    rm -rf "$TEST_DIR"
}

# Common setup function (called automatically by Bashunit)
function set_up() {
    setup_test_environment
    
    # Test environment is ready
    :
}

# Common teardown function (called automatically by Bashunit)
function tear_down() {
    teardown_test_environment
    
    # Test cleanup complete
    :
}

# Helper functions for player tests
setup_player_test_env() {
    export TEST_MODE="true"
    # Create unique test directory with process ID, timestamp, and random component
    local timestamp=$(date +%s%N)
    local random=$(( RANDOM % 10000 ))
    export TEST_DIR="/tmp/tvloop_test_$$_${timestamp}_${random}"
    export TEST_CHANNEL_DIR="$TEST_DIR/channel"
    mkdir -p "$TEST_CHANNEL_DIR"
}

teardown_player_test_env() {
    rm -rf "$TEST_DIR"
}

# Mock player launch function
mock_player_launch() {
    local channel_dir="$1"
    local player="$2"
    
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        # Mock player launch - just create PID file
        local mock_pid=999999
        echo "$mock_pid" > "$channel_dir/$player.pid"
        return 0
    fi
    return 1
}

# Mock player stop function
mock_player_stop() {
    local channel_dir="$1"
    local player="$2"
    
    if [[ "${TEST_MODE:-false}" == "true" ]]; then
        # Mock player stop - remove PID file if it exists
        rm -f "$channel_dir/$player.pid"
        return 0
    fi
    return 1
}

# Check if a player is available
check_player_available() {
    local player="$1"
    command -v "$player" >/dev/null 2>&1
}

# Content helper functions
create_test_video() {
    local filename="$1"
    local duration="${2:-1}"
    
    if command -v ffmpeg >/dev/null 2>&1; then
        ffmpeg -f lavfi -i testsrc=duration=$duration:size=320x240:rate=1 -f lavfi -i sine=frequency=1000:duration=$duration "$filename" -y
    else
        # Create a dummy file if ffmpeg is not available
        echo "# Test video file: $filename" > "$filename"
    fi
}

create_test_playlist() {
    local playlist_file="$1"
    local video_dir="$2"
    
    echo "# Test playlist" > "$playlist_file"
    if [[ -d "$video_dir" ]]; then
        find "$video_dir" -name "*.mp4" -o -name "*.avi" -o -name "*.mkv" | while read -r video; do
            local title=$(basename "$video" | sed 's/\.[^.]*$//')
            local duration="60"  # Mock duration
            echo "$video|$title|$duration" >> "$playlist_file"
        done
    fi
}