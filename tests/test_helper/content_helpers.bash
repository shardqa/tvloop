#!/usr/bin/env bash

# Content test helper functions

setup_content_test_env() {
    export TEST_DIR="/tmp/tvloop_test_$$"
    export TEST_VIDEOS_DIR="$TEST_DIR/videos"
    export TEST_PLAYLIST_FILE="$TEST_DIR/playlist.txt"
    
    mkdir -p "$TEST_VIDEOS_DIR"
    
    # Create test video files with different extensions
    echo "test content" > "$TEST_VIDEOS_DIR/test_video1.mp4"
    echo "test content" > "$TEST_VIDEOS_DIR/test_video2.mkv"
    echo "test content" > "$TEST_VIDEOS_DIR/test_video3.avi"
    echo "test content" > "$TEST_VIDEOS_DIR/ignored_file.txt"
}

teardown_content_test_env() {
    rm -rf "$TEST_DIR"
}

create_test_playlist() {
    local playlist_file="$1"
    local videos_dir="$2"
    local extensions="${3:-mp4,mkv,avi}"
    
    run ./scripts/playlist_manager.sh "$playlist_file" "$videos_dir" create "$extensions"
    [ "$status" -eq 0 ]
    [ -f "$playlist_file" ]
}

validate_playlist_format() {
    local playlist_file="$1"
    
    while IFS='|' read -r path title duration; do
        [ -n "$path" ]
        [ -n "$title" ]
        [ -n "$duration" ]
        [[ "$title" == "test_video"* ]]
    done < "$playlist_file"
}

test_playlist_info() {
    local playlist_file="$1"
    
    run ./scripts/playlist_manager.sh "$playlist_file" info
    [ "$status" -eq 0 ]
    [[ "$output" == *"Playlist:"* ]]
    [[ "$output" == *"Total videos:"* ]]
    [[ "$output" == *"Total duration:"* ]]
}
