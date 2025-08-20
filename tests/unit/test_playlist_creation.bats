#!/usr/bin/env bats

# Playlist creation tests
# Part 2 of the split test file

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

@test "playlist creation with invalid directory" {
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "/nonexistent/directory" create
    [ "$status" -eq 1 ]
    [[ "$output" == *"ERROR: Videos directory not found"* ]]
}

@test "playlist creation with empty directory" {
    local empty_dir="$TEST_DIR/empty"
    mkdir -p "$empty_dir"
    
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$empty_dir" create
    [ "$status" -eq 0 ]
    [ -f "$TEST_PLAYLIST_FILE" ]
    [[ "$output" == *"Creating playlist from directory:"* ]]
    [[ "$output" == *"Playlist created with 0 videos"* ]]
}

@test "video title extraction" {
    # Test the get_video_title function indirectly through playlist creation
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    [ "$status" -eq 0 ]
    [ -f "$TEST_PLAYLIST_FILE" ]
    
    # Check that titles are extracted correctly (without file extensions)
    if grep -q "test_video1" "$TEST_PLAYLIST_FILE"; then
        grep -q "test_video1" "$TEST_PLAYLIST_FILE"
        ! grep -q "test_video1.mp4" "$TEST_PLAYLIST_FILE"
    fi
}

@test "playlist creation with custom extensions" {
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create "mp4"
    [ "$status" -eq 0 ]
    [ -f "$TEST_PLAYLIST_FILE" ]
    [[ "$output" == *"Extensions: mp4"* ]]
}

@test "playlist creation with multiple extensions" {
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create "mp4,mkv,avi"
    [ "$status" -eq 0 ]
    [ -f "$TEST_PLAYLIST_FILE" ]
    [[ "$output" == *"Extensions: mp4,mkv,avi"* ]]
}
