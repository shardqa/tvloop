#!/usr/bin/env bats

# YouTube API Core Basic Request Tests
# Tests for basic API request functionality

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "youtube_api_request fails when API key is not set" {
    unset YOUTUBE_API_KEY
    run youtube_api_request "videos" "part=snippet&id=dQw4w9WgXcQ"
    [ "$status" -eq 1 ]
}

@test "youtube_api_request constructs correct URL" {
    # Mock curl to return success
    curl() {
        echo "URL: $2"  # Second argument is the URL (first is -s)
        return 0
    }
    export -f curl
    
    run youtube_api_request "videos" "part=snippet&id=dQw4w9WgXcQ"
    [ "$status" -eq 0 ]
    [[ "$output" == *"https://www.googleapis.com/youtube/v3/videos?key=test_api_key_12345&part=snippet&id=dQw4w9WgXcQ"* ]]
}

@test "youtube_api_request handles API errors" {
    # Mock curl to return API error
    curl() {
        echo '{"error":{"message":"Invalid API key"}}'
        return 0
    }
    export -f curl
    
    run youtube_api_request "videos" "part=snippet&id=dQw4w9WgXcQ"
    [ "$status" -eq 1 ]
    [[ "$output" == *"YouTube API error: Invalid API key"* ]]
}
