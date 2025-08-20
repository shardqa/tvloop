#!/bin/bash

# Test helper functions for tvloop tests

setup_test_environment() {
    # Setup test environment
    export TEST_DIR="/tmp/tvloop_test_$$"
    export CHANNEL_DIR="$TEST_DIR/channel_1"
    export SCRIPT_DIR="scripts"
    
    mkdir -p "$CHANNEL_DIR"
    
    # Source YouTube API modules
    source "core/youtube_api.sh"
}

teardown_test_environment() {
    # Cleanup test environment
    rm -rf "$TEST_DIR"
}
