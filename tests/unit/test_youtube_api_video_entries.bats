#!/usr/bin/env bats

# YouTube API Video Playlist Entries Tests
# Tests for get_single_video_playlist_entry functionality

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "get_single_video_playlist_entry fails when URL is empty" {
    run get_single_video_playlist_entry ""
    [ "$status" -eq 1 ]
    [[ "$output" == *"Video URL is required"* ]]
}

@test "get_single_video_playlist_entry fails when URL is not provided" {
    run get_single_video_playlist_entry
    [ "$status" -eq 1 ]
    [[ "$output" == *"Video URL is required"* ]]
}

@test "get_single_video_playlist_entry fails when video ID cannot be extracted" {
    run get_single_video_playlist_entry "https://example.com/video"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Could not extract video ID from URL"* ]]
}

@test "get_single_video_playlist_entry creates playlist entry for valid video" {
    # Mock extract_video_id
    extract_video_id() {
        echo "dQw4w9WgXcQ"
    }
    export -f extract_video_id
    
    # Mock get_video_details
    get_video_details() {
        echo "Test Video Title|210"
        return 0
    }
    export -f get_video_details
    
    run get_single_video_playlist_entry "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    [ "$status" -eq 0 ]
    [ "$output" = "youtube://dQw4w9WgXcQ|Test Video Title|210" ]
}

@test "get_single_video_playlist_entry handles empty video details gracefully" {
    # Mock extract_video_id
    extract_video_id() {
        echo "dQw4w9WgXcQ"
    }
    export -f extract_video_id
    
    # Mock get_video_details to return empty output
    get_video_details() {
        echo ""
        return 0
    }
    export -f get_video_details
    
    run get_single_video_playlist_entry "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    [ "$status" -eq 0 ]
    [ "$output" = "youtube://dQw4w9WgXcQ||" ]
}
