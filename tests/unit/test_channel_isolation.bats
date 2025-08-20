#!/usr/bin/env bats

setup() {
    load '../test_helper/channel_helpers'
    setup_channel_test_env
}

teardown() {
    teardown_channel_test_env
}

@test "channel states are isolated" {
    ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    sleep 2
    ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    
    elapsed_1=$(get_elapsed_time "$CHANNEL_1_DIR")
    elapsed_2=$(get_elapsed_time "$CHANNEL_2_DIR")
    
    [ "$elapsed_1" -gt "$elapsed_2" ]
}

@test "channel state files are independent" {
    ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    sleep 1
    ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    
    [ -f "$CHANNEL_1_DIR/state.json" ]
    [ -f "$CHANNEL_2_DIR/state.json" ]
    
    # Verify they have different start times
    start_time_1=$(jq -r '.start_time' "$CHANNEL_1_DIR/state.json")
    start_time_2=$(jq -r '.start_time' "$CHANNEL_2_DIR/state.json")
    
    [ "$start_time_1" != "$start_time_2" ]
}

@test "channel playlist files are independent" {
    [ -f "$CHANNEL_1_DIR/playlist.txt" ]
    [ -f "$CHANNEL_2_DIR/playlist.txt" ]
    [ -f "$CHANNEL_3_DIR/playlist.txt" ]
    
    # Verify they have different content
    playlist_1=$(cat "$CHANNEL_1_DIR/playlist.txt")
    playlist_2=$(cat "$CHANNEL_2_DIR/playlist.txt")
    
    [ "$playlist_1" != "$playlist_2" ]
}
