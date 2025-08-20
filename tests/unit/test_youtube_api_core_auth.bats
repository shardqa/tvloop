#!/usr/bin/env bats

# YouTube API Core Authentication Tests
# Tests for API key validation

load test_helper

setup() {
    setup_test_environment
    # Mock YouTube API key for testing
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "check_youtube_api_key returns success when API key is set" {
    run check_youtube_api_key
    [ "$status" -eq 0 ]
}

@test "check_youtube_api_key returns error when API key is not set" {
    unset YOUTUBE_API_KEY
    run check_youtube_api_key
    [ "$status" -eq 1 ]
    [[ "$output" == *"YouTube API key not configured"* ]]
}
