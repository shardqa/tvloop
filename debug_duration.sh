#!/bin/bash

# Debug script to analyze duration issues with @Mamaefalei channel

echo "🔍 Debugging @Mamaefalei channel duration issues..."
echo ""

# Get first few videos from the channel
channel_url="https://www.youtube.com/@Mamaefalei/videos"
echo "📺 Channel URL: $channel_url"
echo ""

echo "📋 Getting video list..."
video_urls=$(yt-dlp --cookies-from-browser firefox --get-url --playlist-end 5 "$channel_url" 2>/dev/null)
if [[ $? -ne 0 ]]; then
    echo "❌ Failed to get video URLs"
    exit 1
fi

echo "✅ Found videos:"
echo "$video_urls"
echo ""

echo "🔍 Analyzing first 3 videos for duration data..."
count=0
while IFS= read -r video_url; do
    if [[ -z "$video_url" ]]; then
        continue
    fi
    
    count=$((count + 1))
    if [[ $count -gt 3 ]]; then
        break
    fi
    
    echo ""
    echo "📹 Video $count: $video_url"
    
    # Get raw JSON
    echo "  🔍 Raw JSON output:"
    json_output=$(yt-dlp --cookies-from-browser firefox --dump-json --no-playlist "$video_url" 2>/dev/null)
    if [[ $? -eq 0 && -n "$json_output" ]]; then
        title=$(echo "$json_output" | jq -r '.title // "NO_TITLE"')
        duration=$(echo "$json_output" | jq -r '.duration // "NO_DURATION"')
        duration_string=$(echo "$json_output" | jq -r '.duration_string // "NO_DURATION_STRING"')
        video_id=$(echo "$json_output" | jq -r '.id // "NO_ID"')
        
        echo "    - Title: $title"
        echo "    - Duration: '$duration'"
        echo "    - Duration String: '$duration_string'"
        echo "    - Video ID: $video_id"
        
        # Check what type duration is
        echo "    - Duration type check:"
        if [[ "$duration" == "null" ]]; then
            echo "      ❌ Duration is null"
        elif [[ -z "$duration" ]]; then
            echo "      ❌ Duration is empty"
        elif [[ "$duration" =~ ^[0-9]+$ ]]; then
            echo "      ✅ Duration is valid number: $duration seconds"
        else
            echo "      ❌ Duration is not a valid number: '$duration'"
        fi
    else
        echo "  ❌ Failed to get JSON data"
    fi
done <<< "$video_urls"

echo ""
echo "🏁 Debug analysis complete!"
