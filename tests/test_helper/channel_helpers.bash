#!/usr/bin/env bash

# Channel test helper functions

setup_channel_test_env() {
    export TEST_DIR="/tmp/tvloop_test_$$"
    export CHANNEL_1_DIR="$TEST_DIR/channel_1"
    export CHANNEL_2_DIR="$TEST_DIR/channel_2"
    export CHANNEL_3_DIR="$TEST_DIR/channel_3"
    
    mkdir -p "$CHANNEL_1_DIR" "$CHANNEL_2_DIR" "$CHANNEL_3_DIR"
    
    cat > "$CHANNEL_1_DIR/playlist.txt" << EOF
/tmp/test_video1.mp4|Test Video 1|60
/tmp/test_video2.mp4|Test Video 2|120
EOF
    
    cat > "$CHANNEL_2_DIR/playlist.txt" << EOF
/tmp/test_video3.mp4|Test Video 3|90
/tmp/test_video4.mp4|Test Video 4|150
EOF
    
    cat > "$CHANNEL_3_DIR/playlist.txt" << EOF
/tmp/test_video5.mp4|Test Video 5|75
EOF
    
    touch /tmp/test_video{1,2,3,4,5}.mp4
}

teardown_channel_test_env() {
    rm -rf "$TEST_DIR"
    rm -f /tmp/test_video{1,2,3,4,5}.mp4
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
