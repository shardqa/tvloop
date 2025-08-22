#!/bin/bash

# Debug script for @Mamaefalei channel specifically

source "core/youtube_ytdlp_core.sh"
source "core/youtube_ytdlp_playlist_fetcher.sh"

echo "🔍 Debugging @Mamaefalei channel step by step..."
echo ""

channel_url="https://www.youtube.com/@Mamaefalei/videos"

echo "📋 Step 1: Getting video URLs from channel..."
video_urls=$(get_playlist_videos_ytdlp "$channel_url" 5)
if [[ $? -ne 0 ]]; then
    echo "❌ Failed to get video URLs"
    exit 1
fi

echo "✅ Got video URLs:"
echo "$video_urls"
echo ""

echo "🔍 Step 2: Testing video info extraction for each URL..."
count=0
while IFS= read -r video_url; do
    if [[ -z "$video_url" ]]; then
        continue
    fi
    
    count=$((count + 1))
    echo ""
    echo "📹 Testing video $count: $video_url"
    
    # Test our function
    video_info=$(get_video_info_ytdlp "$video_url")
    if [[ $? -eq 0 ]]; then
        echo "  ✅ SUCCESS: $video_info"
    else
        echo "  ❌ FAILED to get video info"
        
        # Let's try to debug what's wrong
        echo "  🔍 Debug: Testing yt-dlp directly..."
        json_output=$(yt-dlp --cookies-from-browser firefox --dump-json --no-playlist "$video_url" 2>/dev/null)
        if [[ $? -eq 0 && -n "$json_output" ]]; then
            title=$(echo "$json_output" | jq -r '.title // "NO_TITLE"')
            duration=$(echo "$json_output" | jq -r '.duration // "NO_DURATION"')
            video_id=$(echo "$json_output" | jq -r '.id // "NO_ID"')
            
            echo "    - Raw title: '$title'"
            echo "    - Raw duration: '$duration'"
            echo "    - Raw video_id: '$video_id'"
            
            # Check each condition from our function
            if [[ -z "$title" ]]; then
                echo "    ❌ Title is empty"
            elif [[ -z "$duration" ]]; then
                echo "    ❌ Duration is empty"
            elif [[ -z "$video_id" ]]; then
                echo "    ❌ Video ID is empty"
            elif ! [[ "$duration" =~ ^[0-9]+$ ]]; then
                echo "    ❌ Duration is not a valid number: '$duration'"
            else
                echo "    ✅ All fields look valid"
            fi
        else
            echo "    ❌ yt-dlp failed to get JSON"
        fi
    fi
    
    if [[ $count -ge 3 ]]; then
        break
    fi
done <<< "$video_urls"

echo ""
echo "🏁 Debug complete!"
