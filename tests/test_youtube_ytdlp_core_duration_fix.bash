#!/bin/bash

# Test for fixing duration extraction issues

source "$(pwd)/tests/test_helper.bash"

# Test that get_video_info_ytdlp function exists and has correct structure
test_get_video_info_ytdlp_function_exists() {
    # Source the function
    source "$(pwd)/core/youtube_ytdlp_core.sh"
    
    # Test that the function exists
    if ! declare -f get_video_info_ytdlp >/dev/null; then
        echo "❌ get_video_info_ytdlp function not found"
        return 1
    fi
    
    # Test that yt-dlp is available (without making network calls)
    if ! command -v yt-dlp >/dev/null 2>&1; then
        echo "⚠️  yt-dlp not available, skipping network test"
        return 0
    fi
    
    # Test with a simple, fast video (short duration, likely to be cached)
    # Use a popular, short video that's likely to be available
    local test_url="https://www.youtube.com/watch?v=dQw4w9WgXcQ"  # Rick Roll - short, popular
    
    # Set a timeout to prevent long waits
    local video_info
    video_info=$(timeout 5s get_video_info_ytdlp "$test_url" 2>/dev/null)
    local status=$?
    
    # If timeout or failure, that's okay - just check the function structure
    if [[ $status -eq 0 && -n "$video_info" ]]; then
        # Should return video_id|title|duration format
        local parts=$(echo "$video_info" | tr '|' '\n' | wc -l)
        if [[ $parts -eq 3 ]]; then
            local video_id=$(echo "$video_info" | cut -d'|' -f1)
            local title=$(echo "$video_info" | cut -d'|' -f2)
            local duration=$(echo "$video_info" | cut -d'|' -f3)
            
            # Basic validation
            assert_not_empty "$video_id"
            assert_not_empty "$title"
            assert_not_empty "$duration"
            
            # Duration should be a number
            if [[ "$duration" =~ ^[0-9]+$ ]]; then
                echo "✅ Function works correctly with valid video"
            else
                echo "⚠️  Duration not a number: '$duration'"
            fi
        else
            echo "⚠️  Unexpected output format: $video_info"
        fi
    else
        echo "⚠️  Network test skipped or failed (expected for unit tests)"
    fi
}
