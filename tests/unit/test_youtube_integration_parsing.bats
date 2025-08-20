#!/usr/bin/env bats

# YouTube Integration URL Parsing Tests
# Tests for URL parsing integration with real URLs

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "YouTube playlist with mixed video availability" {
    # Mock playlist items API
    youtube_api_request() {
        if [[ "$1" == "playlistItems" ]]; then
            echo '{
                "items": [
                    {"contentDetails": {"videoId": "available1"}},
                    {"contentDetails": {"videoId": "unavailable"}},
                    {"contentDetails": {"videoId": "available2"}}
                ]
            }'
        elif [[ "$1" == "videos" ]]; then
            if [[ "$2" == *"unavailable"* ]]; then
                echo '{"items": []}'
            else
                echo '{
                    "items": [{
                        "snippet": {
                            "title": "Available Video"
                        },
                        "contentDetails": {
                            "duration": "PT1M30S"
                        }
                    }]
                }'
            fi
        fi
        return 0
    }
    export -f youtube_api_request
    
    local output_file="$TEST_DIR/mixed_playlist.txt"
    run create_youtube_playlist "https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" "$output_file"
    [ "$status" -eq 0 ]
    [[ "$output" == *"3"* ]]  # All 3 videos are added (unavailable one with empty details)
    
    # Verify all videos are in playlist (unavailable ones with empty details)
    [ -f "$output_file" ]
    [[ "$(cat "$output_file")" == *"available1"* ]]
    [[ "$(cat "$output_file")" == *"available2"* ]]
    [[ "$(cat "$output_file")" == *"youtube://unavailable||"* ]]
}

@test "YouTube URL parsing integration with real URLs" {
    # Test various YouTube URL formats
    local urls=(
        "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        "https://youtu.be/dQw4w9WgXcQ"
        "https://www.youtube.com/embed/dQw4w9WgXcQ"
        "https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
        "https://www.youtube.com/watch?v=dQw4w9WgXcQ&list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
    )
    
    for url in "${urls[@]}"; do
        if [[ "$url" == *"playlist"* ]]; then
            run extract_playlist_id "$url"
            [ "$status" -eq 0 ]
            [[ "$output" == *"PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"* ]]
        else
            run extract_video_id "$url"
            [ "$status" -eq 0 ]
            [[ "$output" == "dQw4w9WgXcQ" ]]
        fi
    done
}
