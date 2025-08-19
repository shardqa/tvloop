#!/usr/bin/env bats

setup() {
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

teardown() {
    rm -rf "$TEST_DIR"
    rm -f /tmp/test_video{1,2,3,4,5}.mp4
}

@test "multiple channels can be initialized independently" {
    run ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    [ "$status" -eq 0 ]
    [ -f "$CHANNEL_1_DIR/state.json" ]
    
    run ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    [ "$status" -eq 0 ]
    [ -f "$CHANNEL_2_DIR/state.json" ]
    
    run ./scripts/channel_tracker.sh "$CHANNEL_3_DIR" init
    [ "$status" -eq 0 ]
    [ -f "$CHANNEL_3_DIR/state.json" ]
}

@test "channel states are isolated" {
    ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    sleep 2
    ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    
    run ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" status
    [ "$status" -eq 0 ]
    elapsed_line_1=$(echo "$output" | grep "Elapsed Time:")
    elapsed_1=$(echo "$elapsed_line_1" | sed 's/.*Elapsed Time: \([0-9]*\)s.*/\1/')
    
    run ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" status
    [ "$status" -eq 0 ]
    elapsed_line_2=$(echo "$output" | grep "Elapsed Time:")
    elapsed_2=$(echo "$elapsed_line_2" | sed 's/.*Elapsed Time: \([0-9]*\)s.*/\1/')
    
    [ "$elapsed_1" -gt "$elapsed_2" ]
}

@test "channel switching works correctly" {
    ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    
    if command -v mpv >/dev/null 2>&1; then
        run ./scripts/channel_player.sh "$CHANNEL_1_DIR" tune mpv
        [ "$status" -eq 0 ]
        [ -f "$CHANNEL_1_DIR/mpv.pid" ]
        
        run ./scripts/channel_player.sh "$CHANNEL_2_DIR" tune mpv
        [ "$status" -eq 0 ]
        [ -f "$CHANNEL_2_DIR/mpv.pid" ]
        [ ! -f "$CHANNEL_1_DIR/mpv.pid" ]
    else
        skip "mpv not available"
    fi
}

@test "channel configuration can be managed" {
    cat > "$TEST_DIR/channels.conf" << EOF
[channel_1]
name=Test Channel 1
type=local
path=$CHANNEL_1_DIR

[channel_2]
name=Test Channel 2
type=local
path=$CHANNEL_2_DIR
EOF
    
    [ -f "$TEST_DIR/channels.conf" ]
    [ -d "$CHANNEL_1_DIR" ]
    [ -d "$CHANNEL_2_DIR" ]
}

@test "channel status dashboard shows all channels" {
    ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    
    run ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"Channel Status:"* ]]
    
    run ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"Channel Status:"* ]]
}
