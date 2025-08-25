#!/bin/bash

# Playlist Creator Core Module
# Handles main playlist creation logic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/time_utils.sh"
source "$SCRIPT_DIR/logging.sh"
source "$SCRIPT_DIR/playlist_utils.sh"

create_playlist_from_directory() {
    local videos_dir="$1"
    local playlist_file="$2"
    local extensions="${3:-mp4,mkv,avi,mov,wmv,flv,webm}"
    local max_size_mb="${4:-0}"  # 0 means no size limit
    
    if [[ ! -d "$videos_dir" ]]; then
        log "ERROR: Videos directory not found: $videos_dir"
        return 1
    fi
    
    echo "Creating playlist from directory: $videos_dir"
    echo "Extensions: $extensions"
    if [[ $max_size_mb -gt 0 ]]; then
        echo "Max file size: ${max_size_mb}MB"
    fi
    
    > "$playlist_file"
    local count=0
    local skipped_large=0
    
    while IFS= read -r -d '' video_file; do
        # Check file size if limit is set
        if [[ $max_size_mb -gt 0 ]]; then
            local file_size_mb=$(($(stat -c%s "$video_file") / 1024 / 1024))
            if [[ $file_size_mb -gt $max_size_mb ]]; then
                echo "Skipped (too large): $(basename "$video_file") - ${file_size_mb}MB"
                skipped_large=$((skipped_large + 1))
                continue
            fi
        fi
        
        local duration=$(get_video_duration "$video_file")
        local title=$(get_video_title "$video_file")
        
        if [[ $duration -gt 0 ]]; then
            echo "$video_file|$title|$duration" >> "$playlist_file"
            echo "Added: $(basename "$video_file") - ${duration}s"
            count=$((count + 1))
        else
            log "WARNING: Could not determine duration for: $video_file"
        fi
    done < <(find "$videos_dir" -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" \) -print0 | sort -z)
    
    echo "Playlist created with $count videos: $playlist_file"
    
    # Shuffle the playlist for TV-like randomness
    echo "🔀 Shuffling playlist..."
    local temp_playlist="$playlist_file.tmp"
    tail -n +2 "$playlist_file" | shuf > "$temp_playlist"
    echo "$(head -n 1 "$playlist_file")" > "$playlist_file"
    cat "$temp_playlist" >> "$playlist_file"
    rm "$temp_playlist"
    echo "✅ Playlist shuffled!"
    
    if [[ $skipped_large -gt 0 ]]; then
        echo "Skipped $skipped_large files that were too large (>${max_size_mb}MB)"
    fi
}
