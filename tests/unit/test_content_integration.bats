#!/usr/bin/env bats

setup() {
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

teardown() {
    rm -rf "$TEST_DIR"
}

@test "local folder scanning works" {
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    [ "$status" -eq 0 ]
    [ -f "$TEST_PLAYLIST_FILE" ]
}

@test "automatic playlist generation from directory" {
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    [ "$status" -eq 0 ]
    
    # Check that playlist file was created
    [ -f "$TEST_PLAYLIST_FILE" ]
    
    # Check that the script attempted to process video files
    [[ "$output" == *"Creating playlist from directory:"* ]]
    [[ "$output" == *"Extensions: mp4,mkv,avi"* ]]
}

@test "file format detection and filtering" {
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create "mp4,mkv"
    [ "$status" -eq 0 ]
    
    # Check that the script used the specified extensions
    [[ "$output" == *"Extensions: mp4,mkv"* ]]
    [ -f "$TEST_PLAYLIST_FILE" ]
}

@test "playlist validation works" {
    # Create a simple playlist manually for testing
    echo "/tmp/test_video1.mp4|Test Video 1|60" > "$TEST_PLAYLIST_FILE"
    echo "/tmp/test_video2.mp4|Test Video 2|120" >> "$TEST_PLAYLIST_FILE"
    touch /tmp/test_video1.mp4 /tmp/test_video2.mp4
    
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "" validate
    [ "$status" -eq 1 ]
    [[ "$output" == *"Validating playlist:"* ]]
    [[ "$output" == *"Valid videos:"* ]]
    [[ "$output" == *"Invalid videos:"* ]]
    
    # Cleanup
    rm -f /tmp/test_video1.mp4 /tmp/test_video2.mp4
}

@test "playlist info shows correct information" {
    ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" info
    [ "$status" -eq 0 ]
    [[ "$output" == *"Playlist:"* ]]
    [[ "$output" == *"Total videos:"* ]]
    [[ "$output" == *"Total duration:"* ]]
}

@test "metadata extraction works" {
    ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    
    # Check that each line has the expected format: path|title|duration
    while IFS='|' read -r path title duration; do
        [ -n "$path" ]
        [ -n "$title" ]
        [ -n "$duration" ]
        [[ "$title" == "test_video"* ]]
    done < "$TEST_PLAYLIST_FILE"
}

@test "playlist can be used with channel system" {
    ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    
    export TEST_CHANNEL_DIR="$TEST_DIR/channel"
    mkdir -p "$TEST_CHANNEL_DIR"
    cp "$TEST_PLAYLIST_FILE" "$TEST_CHANNEL_DIR/playlist.txt"
    
    run ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    [ "$status" -eq 0 ]
    [ -f "$TEST_CHANNEL_DIR/state.json" ]
    
    run ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"Channel Status:"* ]]
}
