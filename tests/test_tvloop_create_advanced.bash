#!/bin/bash

# Advanced tvloop create command functionality tests
# Tests advanced functionality like existing channels and force flags

source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Test that tvloop create with existing channel name shows error
test_tvloop_create_existing_channel() {
    # Create a channel first
    mkdir -p "$TEST_DIR/channels/existing_channel"
    echo "test_video.mp4|Test Video|60" > "$TEST_DIR/channels/existing_channel/playlist.txt"
    
    # Try to create another channel with the same name
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local output
    output=$(TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" create youtube existing_channel "https://www.youtube.com/@JovemNerd" 2 2>&1)
    local status=$?
    
    # Should show error about existing channel
    assert_contains "already exists" "$output"
}

# Test that tvloop create with --force flag recreates existing channel
test_tvloop_create_with_force_flag() {
    # Create a channel first
    mkdir -p "$TEST_DIR/channels/force_test_channel"
    echo "old_video.mp4|Old Video|60" > "$TEST_DIR/channels/force_test_channel/playlist.txt"
    echo "old content" > "$TEST_DIR/channels/force_test_channel/old_file.txt"
    
    # Mock the YouTube creation script to exit immediately after showing recreating message
    local mock_script="$TEST_DIR/mock_create_youtube_channel_ytdlp.sh"
    cat > "$mock_script" << 'EOF'
#!/bin/bash
echo "🎬 Creating YouTube channel: $1"
echo "📺 YouTube source: $2" 
echo "⏱️  Target duration: ${3}h"
echo "Mock YouTube channel creation completed"
exit 0
EOF
    chmod +x "$mock_script"
    
    # Temporarily replace the real script with our mock
    local real_script="$PROJECT_ROOT/scripts/create_youtube_channel_ytdlp.sh"
    local backup_script="$TEST_DIR/backup_create_youtube_channel_ytdlp.sh"
    
    # Backup original and replace with mock
    cp "$real_script" "$backup_script"
    cp "$mock_script" "$real_script"
    
    # Try to create the same channel with --force flag
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local output
    output=$(env TVLOOP_CHANNELS_DIR="$TEST_DIR/channels" "$project_root/tvloop" create youtube force_test_channel "https://www.youtube.com/@JovemNerd" 2 --force 2>&1)
    local status=$?
    
    # Restore original script
    cp "$backup_script" "$real_script"
    
    # Should show that channel is being recreated
    assert_contains "recreating" "$output"
    
    # Should show mock creation started
    assert_contains "Creating YouTube channel" "$output"
    
    # Old file should be gone (channel was recreated)
    if [ -f "$TEST_DIR/channels/force_test_channel/old_file.txt" ]; then
        echo "ERROR: Old file still exists, channel was not recreated"
        return 1
    fi
}
