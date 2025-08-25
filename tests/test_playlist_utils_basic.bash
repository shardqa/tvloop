#!/usr/bin/env bash

# Basic Playlist Utils Module Tests
# Tests basic playlist utility functionality

source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Source the playlist utils module
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/core/playlist_utils.sh"

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
