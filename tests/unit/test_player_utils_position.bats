#!/usr/bin/env bats

setup() {
    # Get the project root directory
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PROJECT_ROOT="$(dirname "$(dirname "$DIR")")"
    
    # Load bats libraries from project root
    load "$PROJECT_ROOT/node_modules/bats-support/load"
    load "$PROJECT_ROOT/node_modules/bats-assert/load"
    
    # Source the player_utils.sh file
    source "$PROJECT_ROOT/players/player_utils.sh"
    
    # Create temporary test directory
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
    
    # Create test channel directory
    CHANNEL_DIR="$TEST_DIR/test_channel"
    mkdir -p "$CHANNEL_DIR"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "get_current_video_position with position in second video" {
    # Create valid state file with elapsed time in second video
    local start_time=$(( $(date +%s) - 75 ))  # 75 seconds ago
    cat > "$CHANNEL_DIR/state.json" << EOF
{
    "start_time": $start_time,
    "total_duration": 100
}
EOF
    
    # Create test video files
    echo "test content" > "$CHANNEL_DIR/video1.mp4"
    echo "test content" > "$CHANNEL_DIR/video2.mp4"
    
    # Create playlist with 50s + 50s videos
    echo "$CHANNEL_DIR/video1.mp4|Video 1|50" > "$CHANNEL_DIR/playlist.txt"
    echo "$CHANNEL_DIR/video2.mp4|Video 2|50" >> "$CHANNEL_DIR/playlist.txt"
    
    run get_current_video_position "$CHANNEL_DIR"
    assert_success
    assert_output --regexp '^.*video2\.mp4\|[0-9]+\|50$'
    
    # Parse output to verify position
    IFS='|' read -r video_path position duration <<< "$output"
    assert [ "$video_path" = "$CHANNEL_DIR/video2.mp4" ]
    assert [ "$duration" = "50" ]
    # Position should be around 25 seconds (75 - 50 = 25)
    assert [ $position -ge 20 ]
    assert [ $position -le 30 ]
}
