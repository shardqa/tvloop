#!/bin/bash

# tvloop channel switching advanced functionality tests
# Tests script functionality and multi-channel configuration

source "$(pwd)/tests/test_helper.bash"

# Test that channel switching can be triggered via script message
test_channel_switching_script_message() {
    # This test would require a running MPV instance
    # For now, just test that the script can be loaded and has the right structure
    local project_root="$(pwd)"
    local script_content
    script_content=$(cat "$project_root/scripts/mpv_channel_switcher_switch.lua")
    
    # Should contain script message registration
    assert_contains "mp.register_script_message" "$script_content"
    assert_contains "switch-channel" "$script_content"
}

# Test that multiple channels can be configured for switching
test_multiple_channels_configuration() {
    # Create multiple test channels
    mkdir -p "$TEST_DIR/channels/channel_1"
    mkdir -p "$TEST_DIR/channels/channel_2"
    mkdir -p "$TEST_DIR/channels/channel_3"
    
    # Create mock playlists for each channel
    echo "youtube://A1|Channel 1 Video|300" > "$TEST_DIR/channels/channel_1/playlist.txt"
    echo "youtube://B2|Channel 2 Video|400" > "$TEST_DIR/channels/channel_2/playlist.txt"
    echo "youtube://C3|Channel 3 Video|500" > "$TEST_DIR/channels/channel_3/playlist.txt"
    
    # Test that all channels are detected
    local project_root="$(pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" list 2>&1)
    local status=$?
    
    assert_equals 0 "$status"
    assert_contains "channel_1" "$output"
    assert_contains "channel_2" "$output"
    assert_contains "channel_3" "$output"
}

# Test that channel switching script has proper error handling
test_channel_switching_error_handling() {
    local project_root="$(pwd)"
    local script_content
    script_content=$(cat "$project_root/scripts/mpv_channel_switcher_switch.lua")
    
    # Should contain error handling for missing channels
    assert_contains "not available" "$script_content"
    assert_contains "mp.osd_message" "$script_content"
    assert_contains "Failed to calculate" "$script_content"
}

# Test that channel switching script supports time calculation
test_channel_switching_time_calculation() {
    local project_root="$(pwd)"
    local script_content
    script_content=$(cat "$project_root/scripts/mpv_channel_switcher_position.lua")
    
    # Should contain time calculation logic
    assert_contains "start_time" "$script_content"
    assert_contains "total_duration" "$script_content"
    assert_contains "current_time" "$script_content"
}
