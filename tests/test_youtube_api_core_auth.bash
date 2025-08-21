#!/usr/bin/env bash

# YouTube API Core Authentication Tests - Bashunit Version
# Tests for API key validation

source "$(pwd)/tests/test_helper.bash"
source "$(pwd)/core/youtube_api_core.sh"

function set_up() {
    # Mock YouTube API key for testing
    export YOUTUBE_API_KEY="test_api_key_12345"
}

function tear_down() {
    # No cleanup needed
    :
}

function test_check_youtube_api_key_returns_success_when_api_key_is_set() {
    local result
    result=$(check_youtube_api_key 2>&1)
    local exit_code=$?
    
    assert_equals 0 "$exit_code"
}

function test_check_youtube_api_key_returns_error_when_api_key_is_not_set() {
    export YOUTUBE_API_KEY=""
    
    local result
    result=$(check_youtube_api_key 2>&1)
    local exit_code=$?
    
    assert_equals 1 "$exit_code"
    assert_contains "YouTube API key not configured" "$result"
}
