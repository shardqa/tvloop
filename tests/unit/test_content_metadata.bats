#!/usr/bin/env bats

setup() {
    load 'test_helper/content_helpers'
    setup_content_test_env
}

teardown() {
    teardown_content_test_env
}

@test "metadata extraction works" {
    ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    
    validate_playlist_format "$TEST_PLAYLIST_FILE"
}

@test "video file extensions are properly detected" {
    ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    
    # Check that all supported extensions are included
    grep -q "test_video1.mp4" "$TEST_PLAYLIST_FILE"
    grep -q "test_video2.mkv" "$TEST_PLAYLIST_FILE"
    grep -q "test_video3.avi" "$TEST_PLAYLIST_FILE"
    
    # Check that non-video files are excluded
    ! grep -q "ignored_file.txt" "$TEST_PLAYLIST_FILE"
}

@test "playlist metadata includes duration information" {
    ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    
    # Check that each line has duration field
    while IFS='|' read -r path title duration; do
        [ -n "$duration" ]
        [[ "$duration" =~ ^[0-9]+$ ]]  # Duration should be numeric
    done < "$TEST_PLAYLIST_FILE"
}

@test "playlist metadata includes proper titles" {
    ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    
    # Check that titles are derived from filenames
    while IFS='|' read -r path title duration; do
        [[ "$title" == "test_video"* ]]
        [[ "$title" != *".mp4"* ]]
        [[ "$title" != *".mkv"* ]]
        [[ "$title" != *".avi"* ]]
    done < "$TEST_PLAYLIST_FILE"
}
