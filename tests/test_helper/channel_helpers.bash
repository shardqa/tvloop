#!/usr/bin/env bash

# Channel test helper functions

setup_channel_test_env() {
    # Create unique test environment
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    export TEST_DIR="/tmp/tvloop_test_${test_id}_$$"
    export CHANNEL_1_DIR="$TEST_DIR/channel_1"
    export CHANNEL_2_DIR="$TEST_DIR/channel_2"
    export CHANNEL_3_DIR="$TEST_DIR/channel_3"
    
    # Create all necessary directories
    mkdir -p "$CHANNEL_1_DIR" "$CHANNEL_2_DIR" "$CHANNEL_3_DIR"
    mkdir -p "logs"
    
    # Create unique video file names
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    
    cat > "$CHANNEL_1_DIR/playlist.txt" << EOF
/tmp/test_video1_${test_id}.mp4|Test Video 1|60
/tmp/test_video2_${test_id}.mp4|Test Video 2|120
EOF
    
    cat > "$CHANNEL_2_DIR/playlist.txt" << EOF
/tmp/test_video3_${test_id}.mp4|Test Video 3|90
/tmp/test_video4_${test_id}.mp4|Test Video 4|150
EOF
    
    cat > "$CHANNEL_3_DIR/playlist.txt" << EOF
/tmp/test_video5_${test_id}.mp4|Test Video 5|75
EOF
    
    touch /tmp/test_video{1,2,3,4,5}_${test_id}.mp4
}

teardown_channel_test_env() {
    rm -rf "$TEST_DIR"
    # Clean up unique video files
    local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
    test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
    rm -f /tmp/test_video{1,2,3,4,5}_${test_id}.mp4
}

initialize_channels() {
    ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    ./scripts/channel_tracker.sh "$CHANNEL_3_DIR" init
}

get_elapsed_time() {
    local channel_dir="$1"
    run ./scripts/channel_tracker.sh "$channel_dir" status
    [ "$status" -eq 0 ]
    
    local elapsed_line=$(echo "$output" | grep "Elapsed Time:")
    echo "$elapsed_line" | sed 's/.*Elapsed Time: \([0-9]*\)s.*/\1/'
}

test_channel_initialization() {
    local channel_dir="$1"
    run ./scripts/channel_tracker.sh "$channel_dir" init
    [ "$status" -eq 0 ]
    [ -f "$channel_dir/state.json" ]
}
