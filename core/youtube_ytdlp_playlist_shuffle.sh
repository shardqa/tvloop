#!/bin/bash

# YouTube yt-dlp Playlist Shuffling
# Playlist shuffling functionality

# Shuffle the playlist for TV-like randomness
shuffle_playlist() {
    local playlist_file="$1"
    
    echo "🔀 Shuffling playlist..."
    local temp_playlist="$playlist_file.tmp"
    tail -n +2 "$playlist_file" | shuf > "$temp_playlist"
    echo "$(head -n 1 "$playlist_file")" > "$playlist_file"
    cat "$temp_playlist" >> "$playlist_file"
    rm "$temp_playlist"
    echo "✅ Playlist shuffled!"
}
