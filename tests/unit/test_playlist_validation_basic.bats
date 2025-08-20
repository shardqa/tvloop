#!/usr/bin/env bats

# Basic playlist validation tests
# Part 1 of the split test file

setup() {
    export TEST_DIR="/tmp/tvloop_test_$$"
    export TEST_PLAYLIST_FILE="$TEST_DIR/playlist.txt"
    export TEST_VIDEOS_DIR="$TEST_DIR/videos"
    
    mkdir -p "$TEST_VIDEOS_DIR"
    
    # Create test video files
    if command -v ffmpeg >/dev/null 2>&1; then
        ffmpeg -f lavfi -i testsrc=duration=1:size=320x240:rate=1 -c:v mpeg4 -t 1 "$TEST_VIDEOS_DIR/test_video1.mp4" -y >/dev/null 2>&1 || true
        ffmpeg -f lavfi -i testsrc=duration=1:size=320x240:rate=1 -c:v mpeg4 -t 1 "$TEST_VIDEOS_DIR/test_video2.mp4" -y >/dev/null 2>&1 || true
    else
        echo "test content" > "$TEST_VIDEOS_DIR/test_video1.mp4"
        echo "test content" > "$TEST_VIDEOS_DIR/test_video2.mp4"
    fi
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "playlist validation with valid files" {
    # Create a valid playlist
    echo "$TEST_VIDEOS_DIR/test_video1.mp4|Test Video 1|60" > "$TEST_PLAYLIST_FILE"
    echo "$TEST_VIDEOS_DIR/test_video2.mp4|Test Video 2|120" >> "$TEST_PLAYLIST_FILE"
    
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "" validate
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]  # May fail if ffprobe not available
    [[ "$output" == *"Validating playlist:"* ]]
    [[ "$output" == *"Valid videos:"* ]]
    [[ "$output" == *"Invalid videos:"* ]]
}

@test "playlist validation with missing files" {
    # Create a playlist with non-existent files
    echo "/nonexistent/video1.mp4|Test Video 1|60" > "$TEST_PLAYLIST_FILE"
    echo "/nonexistent/video2.mp4|Test Video 2|120" >> "$TEST_PLAYLIST_FILE"
    
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "" validate
    [ "$status" -eq 1 ]
    [[ "$output" == *"Validating playlist:"* ]]
    [[ "$output" == *"❌ /nonexistent/video1.mp4 - File not found"* ]]
    [[ "$output" == *"❌ /nonexistent/video2.mp4 - File not found"* ]]
}

@test "playlist validation with missing playlist file" {
    run ./scripts/playlist_manager.sh "/nonexistent/playlist.txt" validate
    [ "$status" -eq 1 ]
    [[ "$output" == *"ERROR: Playlist file not found"* ]]
}

@test "playlist info display with valid playlist" {
    # Create a valid playlist
    echo "$TEST_VIDEOS_DIR/test_video1.mp4|Test Video 1|60" > "$TEST_PLAYLIST_FILE"
    echo "$TEST_VIDEOS_DIR/test_video2.mp4|Test Video 2|120" >> "$TEST_PLAYLIST_FILE"
    
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" info
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]  # May fail if ffprobe not available
    [[ "$output" == *"Playlist:"* ]]
    [[ "$output" == *"Total videos:"* ]]
    [[ "$output" == *"Total duration:"* ]]
}

@test "playlist info display with missing playlist file" {
    run ./scripts/playlist_manager.sh "/nonexistent/playlist.txt" info
    [ "$status" -eq 1 ]
    [[ "$output" == *"ERROR: Playlist file not found"* ]]
}
