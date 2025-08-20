#!/usr/bin/env bats

setup() {
    load '../test_helper/channel_helpers'
    setup_channel_test_env
}

teardown() {
    teardown_channel_test_env
}

@test "multiple channels can be initialized independently" {
    test_channel_initialization "$CHANNEL_1_DIR"
    test_channel_initialization "$CHANNEL_2_DIR"
    test_channel_initialization "$CHANNEL_3_DIR"
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
