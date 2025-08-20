#!/usr/bin/env bats

# YouTube API Playlist Creation Basic Tests
# Tests for basic create_youtube_playlist functionality

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "create_youtube_playlist fails when playlist URL is empty" {
    run create_youtube_playlist "" "output.txt"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Playlist URL and output file are required"* ]]
}

@test "create_youtube_playlist fails when output file is empty" {
    run create_youtube_playlist "https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" ""
    [ "$status" -eq 1 ]
    [[ "$output" == *"Playlist URL and output file are required"* ]]
}

@test "create_youtube_playlist fails when playlist ID cannot be extracted" {
    run create_youtube_playlist "https://example.com/playlist" "output.txt"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Could not extract playlist ID from URL"* ]]
}

@test "create_youtube_playlist creates playlist file successfully" {
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
    
    # Mock get_video_details
    get_video_details() {
        echo "Test Video $1|180"
        return 0
    }
    export -f get_video_details
    
    local output_file="$TEST_DIR/playlist.txt"
    run create_youtube_playlist "https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" "$output_file"
    [ "$status" -eq 0 ]
    [[ "$output" == *"2"* ]]
    
    # Check playlist file content
    [ -f "$output_file" ]
    [[ "$(cat "$output_file")" == *"youtube://video1|Test Video video1|180"* ]]
    [[ "$(cat "$output_file")" == *"youtube://video2|Test Video video2|180"* ]]
}
