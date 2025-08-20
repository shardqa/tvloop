#!/usr/bin/env bats

# YouTube API Video URL Parsing Tests
# Tests for video ID extraction functionality

load test_helper

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "extract_video_id from standard YouTube URL" {
    local url="https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    run extract_video_id "$url"
    [ "$status" -eq 0 ]
    [ "$output" = "dQw4w9WgXcQ" ]
}

@test "extract_video_id from youtu.be URL" {
    local url="https://youtu.be/dQw4w9WgXcQ"
    run extract_video_id "$url"
    [ "$status" -eq 0 ]
    [ "$output" = "dQw4w9WgXcQ" ]
}

@test "extract_video_id from embed URL" {
    local url="https://www.youtube.com/embed/dQw4w9WgXcQ"
    run extract_video_id "$url"
    [ "$status" -eq 0 ]
    [ "$output" = "dQw4w9WgXcQ" ]
}

@test "extract_video_id returns empty for invalid URL" {
    local url="https://example.com/watch?v=invalid"
    run extract_video_id "$url"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "extract_video_id handles empty input" {
    run extract_video_id ""
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}
