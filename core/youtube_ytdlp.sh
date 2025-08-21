#!/bin/bash

# YouTube yt-dlp Integration for tvloop
# Works without API keys using yt-dlp

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Check if yt-dlp is available
check_ytdlp() {
    if ! command -v yt-dlp >/dev/null 2>&1; then
        log "ERROR: yt-dlp not found. Please install yt-dlp:"
        echo "  pip install yt-dlp"
        echo "  or: sudo apt install yt-dlp"
        return 1
    fi
    return 0
}

# Get channel uploads playlist URL from channel URL
get_channel_uploads_url() {
    local channel_url="$1"
    
    # Handle different channel URL formats
    if [[ "$channel_url" =~ /channel/([a-zA-Z0-9_-]+) ]]; then
        local channel_id="${BASH_REMATCH[1]}"
        echo "https://www.youtube.com/channel/$channel_id/videos"
    elif [[ "$channel_url" =~ /@([a-zA-Z0-9_-]+) ]]; then
        local username="${BASH_REMATCH[1]}"
        echo "https://www.youtube.com/@$username/videos"
    elif [[ "$channel_url" =~ ^@([a-zA-Z0-9_-]+)$ ]]; then
        local username="${BASH_REMATCH[1]}"
        echo "https://www.youtube.com/@$username/videos"
    else
        # Assume it's already a videos URL or try to convert
        echo "$channel_url"
    fi
}

# Get video information using yt-dlp
get_video_info_ytdlp() {
    local video_url="$1"
    
    if ! check_ytdlp; then
        return 1
    fi
    
    # Get video information in JSON format
    local info=$(yt-dlp --dump-json --no-playlist "$video_url" 2>/dev/null)
    
    if [[ $? -eq 0 && -n "$info" ]]; then
        local title=$(echo "$info" | jq -r '.title // "unknown"')
        local duration=$(echo "$info" | jq -r '.duration // "0"')
        local video_id=$(echo "$info" | jq -r '.id // "unknown"')
        
        # Clean up title to avoid special characters in shell operations
        title=$(echo "$title" | tr -d '"' | tr -d "'" | sed 's/[^a-zA-Z0-9 \-_().]/ /g')
        
        if [[ -n "$title" && -n "$duration" && -n "$video_id" && "$duration" =~ ^[0-9]+$ ]]; then
            echo "$video_id|$title|$duration"
            return 0
        fi
    fi
    
    return 1
}

# Get playlist videos using yt-dlp
get_playlist_videos_ytdlp() {
    local playlist_url="$1"
    local max_videos="${2:-50}"
    
    if ! check_ytdlp; then
        return 1
    fi
    
    # Get playlist information - each line is a JSON object
    local video_urls=""
    local count=0
    
    while IFS= read -r line; do
        if [[ -n "$line" && $count -lt $max_videos ]]; then
            local url=$(echo "$line" | jq -r '.url // empty')
            if [[ -n "$url" ]]; then
                video_urls="$video_urls"$'\n'"$url"
                count=$((count + 1))
            fi
        fi
    done < <(yt-dlp --flat-playlist --dump-json --playlist-end "$max_videos" "$playlist_url" 2>/dev/null)
    
    if [[ -n "$video_urls" ]]; then
        echo "$video_urls"
        return 0
    fi
    
    return 1
}

# Create playlist from channel using yt-dlp
create_channel_playlist_ytdlp() {
    local channel_input="$1"
    local playlist_file="$2"
    local target_hours="${3:-24}"
    local max_videos="${4:-100}"
    local quality="${5:-best[height<=720]}"  # Default to 720p
    
    local target_seconds=$((target_hours * 3600))
    
    echo "🎬 Creating $target_hours-hour playlist from channel: $channel_input"
    echo "📊 Target duration: ${target_hours}h (${target_seconds}s)"
    echo "🔧 Using yt-dlp (no API key required)"
    echo ""
    
    if ! check_ytdlp; then
        return 1
    fi
    
    # Get channel uploads URL
    local uploads_url=$(get_channel_uploads_url "$channel_input")
    echo "📺 Channel URL: $uploads_url"
    echo ""
    
    # Get playlist videos
    echo "📋 Fetching videos from channel..."
    local video_urls=$(get_playlist_videos_ytdlp "$uploads_url" "$max_videos")
    
    if [[ $? -ne 0 || -z "$video_urls" ]]; then
        log "ERROR: Could not fetch videos from channel"
        return 1
    fi
    
    local video_count=$(echo "$video_urls" | wc -l)
    echo "✅ Found $video_count videos"
    echo ""
    
    # Create playlist file with quality setting
    > "$playlist_file"
    echo "# Quality: $quality" > "$playlist_file"
    local playlist_duration=0
    local added_count=0
    local processed_count=0
    
    echo "🎯 Building playlist..."
    
    # Process each video
    while IFS= read -r video_url; do
        if [[ -z "$video_url" ]]; then
            continue
        fi
        
        processed_count=$((processed_count + 1))
        echo "Processing video $processed_count/$video_count..."
        
        # Get video information
        local video_info=$(get_video_info_ytdlp "$video_url")
        if [[ $? -ne 0 ]]; then
            echo "⚠️  Skipping: Could not get video info"
            continue
        fi
        
        local video_id=$(echo "$video_info" | cut -d'|' -f1)
        local title=$(echo "$video_info" | cut -d'|' -f2)
        local duration=$(echo "$video_info" | cut -d'|' -f3)
        
        # Validate duration is a number
        if [[ -z "$duration" || "$duration" == "0" || "$duration" == "null" || ! "$duration" =~ ^[0-9]+$ ]]; then
            echo "⚠️  Skipping: $title (invalid duration: '$duration')"
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
    done <<< "$video_urls"
    
    echo ""
    echo "🎉 Playlist created successfully!"
    echo "📊 Videos added: $added_count"
    echo "⏱️  Total duration: ${playlist_duration}s ($(date -u -d @$playlist_duration '+%H:%M:%S'))"
    echo "📁 Playlist file: $playlist_file"
    
    # Shuffle the playlist for TV-like randomness
    echo "🔀 Shuffling playlist..."
    local temp_playlist="$playlist_file.tmp"
    tail -n +2 "$playlist_file" | shuf > "$temp_playlist"
    echo "$(head -n 1 "$playlist_file")" > "$playlist_file"
    cat "$temp_playlist" >> "$playlist_file"
    rm "$temp_playlist"
    echo "✅ Playlist shuffled!"
    
    if [[ $playlist_duration -lt $target_seconds ]]; then
        echo "⚠️  Note: Could only reach ${playlist_duration}s (${target_hours}h target)"
    fi
}

# Get single video information for playlist entry
get_single_video_ytdlp() {
    local video_url="$1"
    
    local video_info=$(get_video_info_ytdlp "$video_url")
    if [[ $? -eq 0 ]]; then
        local video_id=$(echo "$video_info" | cut -d'|' -f1)
        local title=$(echo "$video_info" | cut -d'|' -f2)
        local duration=$(echo "$video_info" | cut -d'|' -f3)
        
        echo "youtube://$video_id|$title|$duration"
        return 0
    fi
    
    return 1
}
