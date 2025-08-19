#!/usr/bin/env bats

setup() {
    export TEST_CHANNEL_DIR="/tmp/test_channel_$$"
    export TEST_PLAYLIST_FILE="$TEST_CHANNEL_DIR/playlist.txt"
    export TEST_STATE_FILE="$TEST_CHANNEL_DIR/state.json"
    
    mkdir -p "$TEST_CHANNEL_DIR"
    
    cat > "$TEST_PLAYLIST_FILE" << EOF
/tmp/test_video1.mp4|Test Video 1|60
/tmp/test_video2.mp4|Test Video 2|120
EOF
    
    touch /tmp/test_video1.mp4 /tmp/test_video2.mp4
}

teardown() {
    rm -rf "$TEST_CHANNEL_DIR"
    rm -f /tmp/test_video1.mp4 /tmp/test_video2.mp4
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

@test "player launch with mpv" {
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    if command -v mpv >/dev/null 2>&1; then
        run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune mpv
        [ "$status" -eq 124 ] || [ "$status" -eq 0 ]
        [ -f "$TEST_CHANNEL_DIR/mpv.pid" ]
    else
        skip "mpv not available"
    fi
}

@test "player launch with vlc" {
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    if command -v vlc >/dev/null 2>&1; then
        run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune vlc
        [ "$status" -eq 124 ] || [ "$status" -eq 0 ]
        [ -f "$TEST_CHANNEL_DIR/vlc.pid" ]
    else
        skip "vlc not available"
    fi
}

@test "player stop command works" {
    ./scripts/channel_tracker.sh "$TEST_CHANNEL_DIR" init
    
    if command -v mpv >/dev/null 2>&1; then
        run timeout 2s ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" tune mpv
        [ "$status" -eq 124 ] || [ "$status" -eq 0 ]
        [ -f "$TEST_CHANNEL_DIR/mpv.pid" ]
        
        run ./scripts/channel_player.sh "$TEST_CHANNEL_DIR" stop
        [ "$status" -eq 0 ]
        [ ! -f "$TEST_CHANNEL_DIR/mpv.pid" ]
    else
        skip "mpv not available"
    fi
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
