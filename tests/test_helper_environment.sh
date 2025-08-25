#!/bin/bash

# Test Helper Environment Module
# Handles test environment setup and cleanup logic

# Source project modules
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/logging.sh"

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
