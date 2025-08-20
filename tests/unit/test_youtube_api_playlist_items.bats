#!/usr/bin/env bats

# YouTube API Playlist Items Tests
# Tests for get_playlist_items functionality

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "get_playlist_items fails when playlist ID is empty" {
    run get_playlist_items ""
    [ "$status" -eq 1 ]
    [[ "$output" == *"Playlist ID is required"* ]]
}

@test "get_playlist_items fails when playlist ID is not provided" {
    run get_playlist_items
    [ "$status" -eq 1 ]
    [[ "$output" == *"Playlist ID is required"* ]]
}

@test "get_playlist_items returns video IDs for valid playlist" {
    # Mock API response
    youtube_api_request() {
        echo '{
            "items": [
                {"contentDetails": {"videoId": "video1"}},
                {"contentDetails": {"videoId": "video2"}},
                {"contentDetails": {"videoId": "video3"}}
            ]
        }'
        return 0
    }
    export -f youtube_api_request
    
    run get_playlist_items "PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
    [ "$status" -eq 0 ]
    [[ "$output" == *"video1"* ]]
    [[ "$output" == *"video2"* ]]
    [[ "$output" == *"video3"* ]]
}

@test "get_playlist_items handles API errors" {
    # Mock API error
    youtube_api_request() {
        return 1
    }
    export -f youtube_api_request
    
    run get_playlist_items "PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
    [ "$status" -eq 1 ]
}

@test "get_playlist_items handles empty playlist" {
    # Mock API response with no items
    youtube_api_request() {
        echo '{"items": []}'
        return 0
    }
    export -f youtube_api_request
    
    run get_playlist_items "PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
    [ "$status" -eq 1 ]
    [[ "$output" == *"No videos found in playlist or access denied"* ]]
}

@test "get_playlist_items respects max_results parameter" {
    # Mock API response
    youtube_api_request() {
        echo '{
            "items": [
                {"contentDetails": {"videoId": "video1"}},
                {"contentDetails": {"videoId": "video2"}}
            ]
        }'
        return 0
    }
    export -f youtube_api_request
    
    run get_playlist_items "PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" "2"
    [ "$status" -eq 0 ]
    [[ "$output" == *"video1"* ]]
    [[ "$output" == *"video2"* ]]
}
