#!/usr/bin/env bats

# Time Utils Test Suite
# This file has been split into smaller test files for better organization

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

# Note: Tests have been moved to:
# - test_time_utils_basic.bats
# - test_time_utils_advanced.bats
