#!/usr/bin/env bash

# Logging Module Tests

source "$(pwd)/tests/test_helper.bash"

# Source the logging module
source "$(pwd)/core/logging.sh"

function set_up() {
    # Create logs directory for testing
    mkdir -p logs
}

function tear_down() {
    # Clean up test logs
    rm -f logs/channel_activity.log
}

function test_log_function_exists() {
    # Test that log function exists and is callable
    assert_equals "function" "$(type -t log)"
}

function test_log_function_basic() {
    # Test basic logging functionality
    local output
    output=$(log "Test message" 2>&1)
    assert_contains "Test message" "$output"
}

function test_log_function_with_timestamp() {
    # Test that log includes timestamp
    local output
    output=$(log "Timestamp test" 2>&1)
    assert_matches "^\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\] Timestamp test$" "$output"
}

function test_log_function_writes_to_file() {
    # Test that log writes to file
    log "File test message"
    assert_file_exists "logs/channel_activity.log"
    assert_contains "File test message" "$(cat logs/channel_activity.log)"
}

function test_log_function_with_custom_file() {
    # Test logging with custom log file
    local custom_log="logs/custom_test.log"
    log "Custom file message" "$custom_log"
    assert_file_exists "$custom_log"
    assert_contains "Custom file message" "$(cat "$custom_log")"
}

function test_log_function_multiple_messages() {
    # Test multiple log messages
    log "Message 1"
    log "Message 2"
    log "Message 3"
    
    local log_content
    log_content=$(cat logs/channel_activity.log)
    assert_contains "Message 1" "$log_content"
    assert_contains "Message 2" "$log_content"
    assert_contains "Message 3" "$log_content"
}
