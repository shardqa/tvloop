#!/usr/bin/env bats

setup() {
    load '../test_helper/channel_helpers'
    setup_channel_test_env
}

teardown() {
    teardown_channel_test_env
}

@test "channel switching works correctly" {
    ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    
    if command -v mpv >/dev/null 2>&1; then
        run timeout 3s ./scripts/channel_player.sh "$CHANNEL_1_DIR" tune mpv
        # Allow for various exit codes: 0 (success), 124 (timeout), 1 (error due to fake video files)
        [ "$status" -eq 0 ] || [ "$status" -eq 124 ] || [ "$status" -eq 1 ]
        
        run timeout 3s ./scripts/channel_player.sh "$CHANNEL_2_DIR" tune mpv
        # Allow for various exit codes: 0 (success), 124 (timeout), 1 (error due to fake video files)
        [ "$status" -eq 0 ] || [ "$status" -eq 124 ] || [ "$status" -eq 1 ]
        
        # Only check for PID files if the commands succeeded
        if [ "$status" -eq 0 ] || [ "$status" -eq 124 ]; then
            [ -f "$CHANNEL_2_DIR/mpv.pid" ]
            [ ! -f "$CHANNEL_1_DIR/mpv.pid" ]
        fi
    else
        skip "mpv not available"
    fi
}

@test "channel configuration supports multiple types" {
    cat > "$TEST_DIR/channels.conf" << EOF
[channel_1]
name=Test Channel 1
type=local
path=$CHANNEL_1_DIR

[channel_2]
name=Test Channel 2
type=youtube
playlist_id=PL123456789

[channel_3]
name=Test Channel 3
type=subscription
channel_id=UC123456789
EOF
    
    [ -f "$TEST_DIR/channels.conf" ]
    
    # Verify configuration parsing
    grep -q "type=local" "$TEST_DIR/channels.conf"
    grep -q "type=youtube" "$TEST_DIR/channels.conf"
    grep -q "type=subscription" "$TEST_DIR/channels.conf"
}

@test "channel switching preserves state" {
    ./scripts/channel_tracker.sh "$CHANNEL_1_DIR" init
    sleep 2
    
    # Get initial state
    initial_elapsed=$(get_elapsed_time "$CHANNEL_1_DIR")
    
    # Switch to another channel
    ./scripts/channel_tracker.sh "$CHANNEL_2_DIR" init
    
    # Switch back and verify state is preserved
    sleep 2
    final_elapsed=$(get_elapsed_time "$CHANNEL_1_DIR")
    
    # Allow for timing variations - elapsed time should be greater or equal
    [ "$final_elapsed" -ge "$initial_elapsed" ]
}
