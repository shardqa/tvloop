#!/usr/bin/env bash

# Content test helper functions

setup_content_test_env() {
    export TEST_DIR="/tmp/tvloop_test_$$"
    export TEST_VIDEOS_DIR="$TEST_DIR/videos"
    export TEST_PLAYLIST_FILE="$TEST_DIR/playlist.txt"
    
    mkdir -p "$TEST_VIDEOS_DIR"
    
    # Create test video files with different extensions
    # For testing, we'll create files that ffprobe can read
    # Create a simple video file using ffmpeg if available
    if command -v ffmpeg >/dev/null 2>&1; then
        # Create a 1-second test video
        ffmpeg -f lavfi -i testsrc=duration=1:size=320x240:rate=1 -c:v mpeg4 -t 1 "$TEST_VIDEOS_DIR/test_video1.mp4" -y >/dev/null 2>&1 || true
        ffmpeg -f lavfi -i testsrc=duration=1:size=320x240:rate=1 -c:v mpeg4 -t 1 "$TEST_VIDEOS_DIR/test_video2.mkv" -y >/dev/null 2>&1 || true
        ffmpeg -f lavfi -i testsrc=duration=1:size=320x240:rate=1 -c:v mpeg4 -t 1 "$TEST_VIDEOS_DIR/test_video3.avi" -y >/dev/null 2>&1 || true
    else
        # Fallback: create dummy files
        echo "test content" > "$TEST_VIDEOS_DIR/test_video1.mp4"
        echo "test content" > "$TEST_VIDEOS_DIR/test_video2.mkv"
        echo "test content" > "$TEST_VIDEOS_DIR/test_video3.avi"
    fi
    
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
