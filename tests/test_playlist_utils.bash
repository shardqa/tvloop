#!/usr/bin/env bash

# Playlist Utils Module Tests

source "$(pwd)/tests/test_helper.bash"

# Source the playlist utils module
source "$(pwd)/core/playlist_utils.sh"

function set_up() {
    # Create temporary test files
    TEST_PLAYLIST_FILE=$(mktemp)
    TEST_VIDEO_FILE=$(mktemp)
    
    # Create a sample playlist with mixed content
    cat > "$TEST_PLAYLIST_FILE" << 'EOF'
/tmp/test_video1.mp4|Test Video 1|120
youtube://dQw4w9WgXcQ|Rick Roll|212
/tmp/test_video2.mp4|Test Video 2|180
EOF

    # Create a sample video file
    cat > "$TEST_VIDEO_FILE" << 'EOF'
/tmp/test_video3.mp4|Test Video 3|90
EOF
}

function tear_down() {
    # Clean up temporary files
    rm -f "$TEST_PLAYLIST_FILE" "$TEST_VIDEO_FILE"
}

function test_playlist_utils_functions_exist() {
    # Test that playlist utility functions exist
    assert_equals "function" "$(type -t get_video_title)"
    assert_equals "function" "$(type -t validate_playlist)"
}

function test_get_video_title() {
    # Test getting video title from path
    local title
    title=$(get_video_title "/path/to/video.mp4")
    assert_equals "video" "$title"
    
    title=$(get_video_title "/path/to/my_video.avi")
    assert_equals "my_video" "$title"
    
    title=$(get_video_title "simple.mkv")
    assert_equals "simple" "$title"
}

function test_get_video_title_without_extension() {
    # Test getting video title from path without extension
    local title
    title=$(get_video_title "/path/to/video")
    assert_equals "video" "$title"
}

function test_validate_playlist_with_nonexistent_file() {
    # Test validate_playlist with non-existent file
    local output
    output=$(validate_playlist "/nonexistent/playlist.txt" 2>&1)
    
    assert_contains "ERROR: Playlist file not found" "$output"
}

function test_validate_playlist_output_format() {
    # Test that validate_playlist produces expected output format
    local output
    output=$(validate_playlist "$TEST_PLAYLIST_FILE")
    
    # Check for expected output structure
    assert_contains "Validating playlist:" "$output"
    assert_contains "----------------------------------------" "$output"
    assert_contains "Valid videos:" "$output"
    assert_contains "Invalid videos:" "$output"
    assert_contains "Total duration:" "$output"
}

function test_validate_playlist_youtube_videos() {
    # Test validation of YouTube videos in playlist
    local output
    output=$(validate_playlist "$TEST_PLAYLIST_FILE")
    
    # Should find YouTube video
    assert_contains "YouTube: Rick Roll" "$output"
    assert_contains "212s" "$output"
}

function test_validate_playlist_local_files() {
    # Test validation of local files in playlist
    # Note: These will be marked as invalid since the files don't exist
    local output
    output=$(validate_playlist "$TEST_PLAYLIST_FILE")
    
    # Should find local file entries (but marked as invalid)
    assert_contains "test_video1.mp4" "$output"
    assert_contains "test_video2.mp4" "$output"
}

function test_validate_playlist_counts() {
    # Test that validate_playlist provides correct counts
    local output
    output=$(validate_playlist "$TEST_PLAYLIST_FILE")
    
    # Extract counts from output
    local valid_count
    valid_count=$(echo "$output" | grep "Valid videos:" | awk '{print $3}')
    local invalid_count
    invalid_count=$(echo "$output" | grep "Invalid videos:" | awk '{print $3}')
    
    # Should have 1 valid (YouTube) and 2 invalid (local files)
    assert_equals "1" "$valid_count"
    assert_equals "2" "$invalid_count"
}

function test_validate_playlist_total_duration() {
    # Test that validate_playlist calculates total duration
    local output
    output=$(validate_playlist "$TEST_PLAYLIST_FILE")
    
    # Should include total duration (212s from YouTube video)
    assert_contains "Total duration: 212s" "$output"
}
