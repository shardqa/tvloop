#!/usr/bin/env bats

# YouTube API Video Details Tests
# Tests for get_video_details functionality

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "get_video_details fails when video ID is empty" {
    run get_video_details ""
    [ "$status" -eq 1 ]
    [[ "$output" == *"Video ID is required"* ]]
}

@test "get_video_details fails when video ID is not provided" {
    run get_video_details
    [ "$status" -eq 1 ]
    [[ "$output" == *"Video ID is required"* ]]
}

@test "get_video_details returns video information for valid video" {
    # Mock API response
    youtube_api_request() {
        echo '{
            "items": [{
                "snippet": {
                    "title": "Test Video Title"
                },
                "contentDetails": {
                    "duration": "PT3M30S"
                }
            }]
        }'
        return 0
    }
    export -f youtube_api_request
    
    run get_video_details "dQw4w9WgXcQ"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Test Video Title|210"* ]]
}

@test "get_video_details handles API errors" {
    # Mock API error
    youtube_api_request() {
        return 1
    }
    export -f youtube_api_request
    
    run get_video_details "dQw4w9WgXcQ"
    [ "$status" -eq 1 ]
}

@test "get_video_details handles missing video" {
    # Mock API response with no items
    youtube_api_request() {
        echo '{"items": []}'
        return 0
    }
    export -f youtube_api_request
    
    run get_video_details "nonexistent"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Video not found or access denied"* ]]
}

@test "get_video_details handles missing title" {
    # Mock API response with missing title
    youtube_api_request() {
        echo '{
            "items": [{
                "snippet": {},
                "contentDetails": {
                    "duration": "PT3M30S"
                }
            }]
        }'
        return 0
    }
    export -f youtube_api_request
    
    run get_video_details "dQw4w9WgXcQ"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Video not found or access denied"* ]]
}
