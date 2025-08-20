#!/bin/bash

# Test helper functions for tvloop tests

setup_test_environment() {
    # Setup test environment with unique identifiers
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    export TEST_DIR="/tmp/tvloop_test_${test_id}_$$"
    export CHANNEL_DIR="$TEST_DIR/channel_1"
    export SCRIPT_DIR="scripts"
    
    # Create all necessary directories
    mkdir -p "$CHANNEL_DIR"
    mkdir -p "$TEST_DIR/logs"
    mkdir -p "$TEST_DIR/videos"
    mkdir -p "$TEST_DIR/channels"
    mkdir -p "$TEST_DIR/pid"
    
    # Create logs directory in project root for logging system
    mkdir -p "logs"
    
    # Source YouTube API modules
    source "core/youtube_api.sh"
}

teardown_test_environment() {
    # Cleanup test environment
    rm -rf "$TEST_DIR"
    
    # Clean up logs directory if it was created by tests
    if [ -d "logs" ] && [ -z "$(ls -A logs 2>/dev/null)" ]; then
        rmdir "logs" 2>/dev/null || true
    fi
}

# Helper function to create test video files
create_test_video_files() {
    local video_dir="${1:-/tmp}"
    local prefix="${2:-test_video}"
    local count="${3:-2}"
    
    # Make video files unique to this test
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    prefix="${prefix}_${test_id}"
    
    for i in $(seq 1 $count); do
        touch "$video_dir/${prefix}${i}.mp4"
    done
}

# Helper function to create test playlist
create_test_playlist() {
    local playlist_file="$1"
    local video_dir="$2"
    local count="${3:-2}"
    
    for i in $(seq 1 $count); do
        echo "$video_dir/test_video${i}.mp4|Test Video ${i}|$((60 * i))" >> "$playlist_file"
    done
}
