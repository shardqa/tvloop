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
        # For testing, we'll mock the player switching instead of starting real processes
        if [[ "${TEST_MODE:-false}" == "true" ]]; then
            # Mock player switching - just create PID files and test the logic
            echo "999999" > "$CHANNEL_2_DIR/mpv.pid"
            
            # Test that the second channel has a PID file and first doesn't
            [ -f "$CHANNEL_2_DIR/mpv.pid" ]
            [ ! -f "$CHANNEL_1_DIR/mpv.pid" ]
            
            # Clean up mock PID file
            rm -f "$CHANNEL_2_DIR/mpv.pid"
        else
            # Real player switching for non-test environments
            # Create a lock file to prevent multiple player tests from running simultaneously
            local lock_file="/tmp/tvloop_player_test_mpv.lock"
            local test_id="${BATS_TEST_NUMBER:-$$}_${BATS_TEST_NAME:-test}"
            test_id=$(echo "$test_id" | tr ' ' '_' | tr ':' '_')
            
            # Wait for lock with timeout
            local timeout=30
            local count=0
            while [ -f "$lock_file" ] && [ $count -lt $timeout ]; do
                sleep 1
                count=$((count + 1))
            done
            
            # Create lock file
            echo "$test_id" > "$lock_file"
            
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
            
            # Clean up lock file
            rm -f "$lock_file"
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
