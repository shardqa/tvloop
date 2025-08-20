#!/usr/bin/env bats

setup() {
    load 'test_helper/player_helpers'
    setup_player_test_env
}

teardown() {
    teardown_player_test_env
}

@test "channel initialization creates state file" {
    run ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    [ "$status" -eq 0 ]
    [ -f "$TEST_STATE_FILE" ]
    
    run jq -r '.start_time' "$TEST_STATE_FILE"
    [ "$status" -eq 0 ]
    [ "$output" != "null" ]
    [ "$output" != "" ]
}

@test "channel status shows current video position" {
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    run ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"Current Video"* ]]
    [[ "$output" == *"Video Position"* ]]
}

@test "timestamp calculation is accurate" {
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    sleep 2
    
    run ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"Elapsed Time:"* ]]
    
    elapsed_line=$(echo "$output" | grep "Elapsed Time:")
    elapsed_seconds=$(echo "$elapsed_line" | sed 's/.*Elapsed Time: \([0-9]*\)s.*/\1/')
    
    [ "$elapsed_seconds" -ge 1 ]
    [ "$elapsed_seconds" -le 5 ]
}

@test "playlist looping works correctly" {
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    run ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"Total Playlist Duration:"* ]]
    
    total_duration_line=$(echo "$output" | grep "Total Playlist Duration:")
    total_seconds=$(echo "$total_duration_line" | sed 's/.*Total Playlist Duration: \([0-9]*\)s.*/\1/')
    
    [ "$total_seconds" -eq 180 ]
}
