#!/usr/bin/env bats

# YouTube API Playlist URL Parsing Tests
# Tests for playlist ID extraction functionality

load test_helper

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "extract_playlist_id from playlist URL" {
    local url="https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
    run extract_playlist_id "$url"
    [ "$status" -eq 0 ]
    [ "$output" = "PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" ]
}

@test "extract_playlist_id from watch URL with list parameter" {
    local url="https://www.youtube.com/watch?v=dQw4w9WgXcQ&list=PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg"
    run extract_playlist_id "$url"
    [ "$status" -eq 0 ]
    [ "$output" = "PLbpi6ZahtOH6Bl7sRseehcmxlYvENeZdg" ]
}

@test "extract_playlist_id returns empty for invalid URL" {
    local url="https://example.com/playlist?list=invalid"
    run extract_playlist_id "$url"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "extract_playlist_id handles empty input" {
    run extract_playlist_id ""
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}
