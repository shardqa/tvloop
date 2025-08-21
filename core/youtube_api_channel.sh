#!/bin/bash

# YouTube API Channel Functions for tvloop
# Handles channel-based operations and video fetching

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/youtube_api_video.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Get channel ID from channel URL or username
get_channel_id() {
    local channel_input="$1"
    
    # If it's already a channel ID (starts with UC)
    if [[ "$channel_input" =~ ^UC[a-zA-Z0-9_-]+$ ]]; then
        echo "$channel_input"
        return 0
    fi
    
    # If it's a channel URL, extract the channel ID
    if [[ "$channel_input" =~ /channel/([a-zA-Z0-9_-]+) ]]; then
        echo "${BASH_REMATCH[1]}"
        return 0
    fi
    
    # If it's a custom URL (@username), search for the channel
    if [[ "$channel_input" =~ ^@([a-zA-Z0-9_-]+)$ ]]; then
        local username="${BASH_REMATCH[1]}"
        local response=$(youtube_api_request "search" "part=snippet&type=channel&q=$username&maxResults=1")
        
        if [[ $? -eq 0 ]]; then
            local channel_id=$(echo "$response" | jq -r '.items[0].id.channelId // empty')
            if [[ -n "$channel_id" ]]; then
                echo "$channel_id"
                return 0
            fi
        fi
    fi
    
    # If it's a username without @, try searching
    if [[ "$channel_input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        local response=$(youtube_api_request "search" "part=snippet&type=channel&q=$channel_input&maxResults=1")
        
        if [[ $? -eq 0 ]]; then
            local channel_id=$(echo "$response" | jq -r '.items[0].id.channelId // empty')
            if [[ -n "$channel_id" ]]; then
                echo "$channel_id"
                return 0
            fi
        fi
    fi
    
    log "ERROR: Could not resolve channel ID from: $channel_input"
    return 1
}

# Get channel information
get_channel_info() {
    local channel_id="$1"
    
    local response=$(youtube_api_request "channels" "part=snippet,contentDetails&id=$channel_id")
    
    if [[ $? -eq 0 ]]; then
        local title=$(echo "$response" | jq -r '.items[0].snippet.title // empty')
        local description=$(echo "$response" | jq -r '.items[0].snippet.description // empty')
        local uploads_playlist=$(echo "$response" | jq -r '.items[0].contentDetails.relatedPlaylists.uploads // empty')
        
        if [[ -n "$title" ]]; then
            echo "$title|$description|$uploads_playlist"
            return 0
        fi
    fi
    
    log "ERROR: Could not get channel info for: $channel_id"
    return 1
}

# Get videos from a channel's uploads playlist
get_channel_videos() {
    local channel_id="$1"
    local max_results="${2:-50}"
    local page_token="${3:-}"
    
    # First get the uploads playlist ID
    local channel_info=$(get_channel_info "$channel_id")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    local uploads_playlist=$(echo "$channel_info" | cut -d'|' -f3)
    
    # Build parameters for playlist items request
    local params="part=snippet&playlistId=$uploads_playlist&maxResults=$max_results"
    if [[ -n "$page_token" ]]; then
        params="$params&pageToken=$page_token"
    fi
    
    local response=$(youtube_api_request "playlistItems" "$params")
    
    if [[ $? -eq 0 ]]; then
        echo "$response"
        return 0
    fi
    
    log "ERROR: Could not get videos from channel: $channel_id"
    return 1
}

# Get all videos from a channel (with pagination)
get_all_channel_videos() {
    local channel_id="$1"
    local max_total="${2:-100}"
    
    local all_videos=""
    local page_token=""
    local total_count=0
    
    while [[ $total_count -lt $max_total ]]; do
        local max_results=$((max_total - total_count))
        if [[ $max_results -gt 50 ]]; then
            max_results=50
        fi
        
        local response=$(get_channel_videos "$channel_id" "$max_results" "$page_token")
        if [[ $? -ne 0 ]]; then
            break
        fi
        
        local videos=$(echo "$response" | jq -r '.items[] | "\(.snippet.resourceId.videoId)|\(.snippet.title)"')
        local next_page_token=$(echo "$response" | jq -r '.nextPageToken // empty')
        
        if [[ -n "$videos" ]]; then
            all_videos="$all_videos"$'\n'"$videos"
            total_count=$(echo "$all_videos" | wc -l)
        fi
        
        if [[ -z "$next_page_token" ]]; then
            break
        fi
        
        page_token="$next_page_token"
    done
    
    echo "$all_videos"
}

# Create a 24-hour playlist from channel videos
create_24h_channel_playlist() {
    local channel_input="$1"
    local playlist_file="$2"
    local target_hours="${3:-24}"
    local max_videos="${4:-200}"
    
    local target_seconds=$((target_hours * 3600))
    
    echo "🎬 Creating $target_hours-hour playlist from channel: $channel_input"
    echo "📊 Target duration: ${target_hours}h (${target_seconds}s)"
    echo ""
    
    # Get channel ID
    local channel_id=$(get_channel_id "$channel_input")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    echo "✅ Channel ID: $channel_id"
    
    # Get channel info
    local channel_info=$(get_channel_info "$channel_id")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    local channel_title=$(echo "$channel_info" | cut -d'|' -f1)
    echo "📺 Channel: $channel_title"
    echo ""
    
    # Get all videos from channel
    echo "📋 Fetching videos from channel..."
    local all_videos=$(get_all_channel_videos "$channel_id" "$max_videos")
    
    if [[ -z "$all_videos" ]]; then
        log "ERROR: No videos found in channel"
        return 1
    fi
    
    local video_count=$(echo "$all_videos" | wc -l)
    echo "✅ Found $video_count videos"
    echo ""
    
    # Create playlist file
    > "$playlist_file"
    local playlist_duration=0
    local added_count=0
    
    echo "🎯 Building playlist..."
    
    # Process each video
    while IFS='|' read -r video_id title; do
        if [[ -z "$video_id" || -z "$title" ]]; then
            continue
        fi
        
        # Get video details
        local video_details=$(get_video_details "$video_id")
        if [[ $? -ne 0 ]]; then
            echo "⚠️  Skipping: $title (could not get details)"
            continue
        fi
        
        local duration=$(echo "$video_details" | cut -d'|' -f2)
        if [[ -z "$duration" || "$duration" == "0" ]]; then
            echo "⚠️  Skipping: $title (no duration)"
            continue
        fi
        
        # Check if adding this video would exceed target
        local new_duration=$((playlist_duration + duration))
        if [[ $new_duration -gt $target_seconds ]]; then
            echo "⏹️  Target duration reached (${playlist_duration}s)"
            break
        fi
        
        # Add to playlist
        echo "youtube://$video_id|$title|$duration" >> "$playlist_file"
        playlist_duration=$new_duration
        added_count=$((added_count + 1))
        
        echo "✅ Added: $title (${duration}s) - Total: ${playlist_duration}s"
    done <<< "$all_videos"
    
    echo ""
    echo "🎉 Playlist created successfully!"
    echo "📊 Videos added: $added_count"
    echo "⏱️  Total duration: ${playlist_duration}s ($(date -u -d @$playlist_duration '+%H:%M:%S'))"
    echo "📁 Playlist file: $playlist_file"
    
    if [[ $playlist_duration -lt $target_seconds ]]; then
        echo "⚠️  Note: Could only reach ${playlist_duration}s (${target_hours}h target)"
    fi
}
