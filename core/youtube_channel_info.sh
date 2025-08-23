#!/bin/bash

# YouTube Channel Info Module
# Handles channel information retrieval and processing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/logging.sh"

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

# Get channel title
get_channel_title() {
    local channel_id="$1"
    
    local channel_info=$(get_channel_info "$channel_id")
    if [[ $? -eq 0 ]]; then
        echo "$channel_info" | cut -d'|' -f1
        return 0
    fi
    
    return 1
}

# Get channel description
get_channel_description() {
    local channel_id="$1"
    
    local channel_info=$(get_channel_info "$channel_id")
    if [[ $? -eq 0 ]]; then
        echo "$channel_info" | cut -d'|' -f2
        return 0
    fi
    
    return 1
}

# Get uploads playlist ID
get_uploads_playlist_id() {
    local channel_id="$1"
    
    local channel_info=$(get_channel_info "$channel_id")
    if [[ $? -eq 0 ]]; then
        echo "$channel_info" | cut -d'|' -f3
        return 0
    fi
    
    return 1
}

# Get detailed channel information
get_detailed_channel_info() {
    local channel_id="$1"
    
    local response=$(youtube_api_request "channels" "part=snippet,contentDetails,statistics&id=$channel_id")
    
    if [[ $? -eq 0 ]]; then
        local title=$(echo "$response" | jq -r '.items[0].snippet.title // empty')
        local description=$(echo "$response" | jq -r '.items[0].snippet.description // empty')
        local uploads_playlist=$(echo "$response" | jq -r '.items[0].contentDetails.relatedPlaylists.uploads // empty')
        local subscriber_count=$(echo "$response" | jq -r '.items[0].statistics.subscriberCount // empty')
        local video_count=$(echo "$response" | jq -r '.items[0].statistics.videoCount // empty')
        local view_count=$(echo "$response" | jq -r '.items[0].statistics.viewCount // empty')
        
        if [[ -n "$title" ]]; then
            echo "$title|$description|$uploads_playlist|$subscriber_count|$video_count|$view_count"
            return 0
        fi
    fi
    
    log "ERROR: Could not get detailed channel info for: $channel_id"
    return 1
}

# Format channel information for display
format_channel_info() {
    local channel_id="$1"
    
    local channel_info=$(get_detailed_channel_info "$channel_id")
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    local title=$(echo "$channel_info" | cut -d'|' -f1)
    local description=$(echo "$channel_info" | cut -d'|' -f2)
    local subscriber_count=$(echo "$channel_info" | cut -d'|' -f4)
    local video_count=$(echo "$channel_info" | cut -d'|' -f5)
    local view_count=$(echo "$channel_info" | cut -d'|' -f6)
    
    echo "📺 Channel: $title"
    if [[ -n "$subscriber_count" ]]; then
        echo "👥 Subscribers: $subscriber_count"
    fi
    if [[ -n "$video_count" ]]; then
        echo "🎬 Videos: $video_count"
    fi
    if [[ -n "$view_count" ]]; then
        echo "👀 Views: $view_count"
    fi
    if [[ -n "$description" ]]; then
        echo "📝 Description: ${description:0:100}..."
    fi
}

