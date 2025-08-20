#!/usr/bin/env bats

setup() {
    load '../test_helper/content_helpers'
    setup_content_test_env
}

teardown() {
    teardown_content_test_env
}

@test "local folder scanning works" {
    create_test_playlist "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR"
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
