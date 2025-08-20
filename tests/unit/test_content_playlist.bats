#!/usr/bin/env bats

setup() {
    load 'test_helper/content_helpers'
    setup_content_test_env
}

teardown() {
    teardown_content_test_env
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
    
    test_playlist_info "$TEST_PLAYLIST_FILE"
}

@test "playlist file format is correct" {
    ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$TEST_VIDEOS_DIR" create
    
    # Verify each line has the expected format: path|title|duration
    while IFS='|' read -r path title duration; do
        [ -n "$path" ]
        [ -n "$title" ]
        [ -n "$duration" ]
        [[ "$title" == "test_video"* ]]
    done < "$TEST_PLAYLIST_FILE"
}

@test "playlist handles empty directory gracefully" {
    local empty_dir="$TEST_DIR/empty"
    mkdir -p "$empty_dir"
    
    run ./scripts/playlist_manager.sh "$TEST_PLAYLIST_FILE" "$empty_dir" create
    [ "$status" -eq 0 ]
    [ -f "$TEST_PLAYLIST_FILE" ]
    
    # Should be empty or contain only header
    local line_count=$(wc -l < "$TEST_PLAYLIST_FILE")
    [ "$line_count" -le 1 ]
}
