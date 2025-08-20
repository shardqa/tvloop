#!/usr/bin/env bats

# YouTube API Playlist Creation Edge Case Tests
# Tests for edge cases in create_youtube_playlist functionality

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "create_youtube_playlist handles empty playlist gracefully" {
    # Mock extract_playlist_id
    extract_playlist_id() {
        echo "PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
    }
    export -f extract_playlist_id
    
    # Mock get_playlist_items to return empty
    get_playlist_items() {
        echo ""
        return 0
    }
    export -f get_playlist_items
    
    local output_file="$TEST_DIR/empty_playlist.txt"
    run create_youtube_playlist "https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" "$output_file"
    [ "$status" -eq 0 ]
    [[ "$output" == *"0"* ]]
    [ -f "$output_file" ]
    [ ! -s "$output_file" ]  # File should be empty
}

@test "create_youtube_playlist handles video detail retrieval failures gracefully" {
    # Mock extract_playlist_id
    extract_playlist_id() {
        echo "PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
    }
    export -f extract_playlist_id
    
    # Mock get_playlist_items
    get_playlist_items() {
        echo -e "video1\nvideo2"
        return 0
    }
    export -f get_playlist_items
    
    # Mock get_video_details to return empty for video2
    get_video_details() {
        if [[ "$1" == "video1" ]]; then
            echo "Test Video $1|180"
            return 0
        else
            echo ""
            return 0
        fi
    }
    export -f get_video_details
    
    local output_file="$TEST_DIR/playlist.txt"
    run create_youtube_playlist "https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" "$output_file"
    [ "$status" -eq 0 ]
    [[ "$output" == *"2"* ]]
    
    # Check playlist file content (both videos should be added, video2 with empty details)
    [ -f "$output_file" ]
    [[ "$(cat "$output_file")" == *"youtube://video1|Test Video video1|180"* ]]
    [[ "$(cat "$output_file")" == *"youtube://video2||"* ]]
}
