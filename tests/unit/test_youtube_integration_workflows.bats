#!/usr/bin/env bats

# YouTube Integration Workflow Tests
# Tests for complete YouTube workflow integration

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "complete YouTube playlist creation workflow" {
    # Mock all YouTube API functions for a complete workflow test
    youtube_api_request() {
        if [[ "$1" == "playlistItems" ]]; then
            echo '{
                "items": [
                    {"contentDetails": {"videoId": "video1"}},
                    {"contentDetails": {"videoId": "video2"}}
                ]
            }'
        elif [[ "$1" == "videos" ]]; then
            echo '{
                "items": [{
                    "snippet": {
                        "title": "Test Video"
                    },
                    "contentDetails": {
                        "duration": "PT3M30S"
                    }
                }]
            }'
        fi
        return 0
    }
    export -f youtube_api_request
    
    local output_file="$TEST_DIR/youtube_playlist.txt"
    
    # Test complete workflow
    run create_youtube_playlist "https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" "$output_file"
    [ "$status" -eq 0 ]
    [[ "$output" == *"2"* ]]
    
    # Verify playlist file was created with correct format
    [ -f "$output_file" ]
    local line_count=$(wc -l < "$output_file")
    [ "$line_count" -eq 2 ]
    
    # Check playlist format
    while IFS= read -r line; do
        [[ "$line" =~ ^youtube://[a-zA-Z0-9_-]+\|.*\|[0-9]+$ ]]
    done < "$output_file"
}

@test "YouTube video URL to playlist entry workflow" {
    # Mock video details API
    youtube_api_request() {
        echo '{
            "items": [{
                "snippet": {
                    "title": "Single Test Video"
                },
                "contentDetails": {
                    "duration": "PT2M15S"
                }
            }]
        }'
        return 0
    }
    export -f youtube_api_request
    
    run get_single_video_playlist_entry "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    [ "$status" -eq 0 ]
    [[ "$output" == *"youtube://dQw4w9WgXcQ|Single Test Video|135"* ]]
}

@test "YouTube API error handling in integration" {
    # Mock API to return error
    youtube_api_request() {
        echo '{"error":{"message":"API key not valid"}}'
        return 0
    }
    export -f youtube_api_request
    
    run get_video_details "dQw4w9WgXcQ"
    [ "$status" -eq 1 ]
    # The function outputs an error message when video is not found
    [[ "$output" == *"ERROR: Video not found or access denied"* ]]
}
