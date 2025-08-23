#!/bin/bash

# YouTube Playlist Merge and Split Module
# Functions for merging and splitting playlists

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_file_ops.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Merge multiple playlists
merge_playlists() {
    local output_file="$1"
    shift
    local input_files=("$@")
    
    if [[ ${#input_files[@]} -eq 0 ]]; then
        log "ERROR: No input files provided for merging"
        return 1
    fi
    
    # Initialize output file
    initialize_playlist_file "$output_file"
    
    local total_merged=0
    
    echo "🔄 Merging ${#input_files[@]} playlists..."
    
    for input_file in "${input_files[@]}"; do
        if [[ -f "$input_file" ]]; then
            local count=0
            while IFS= read -r line; do
                if [[ -n "$line" && "$line" =~ ^youtube:// ]]; then
                    echo "$line" >> "$output_file"
                    count=$((count + 1))
                    total_merged=$((total_merged + 1))
                fi
            done < "$input_file"
            echo "   ✅ Merged $count entries from $(basename "$input_file")"
        else
            echo "   ⚠️  Skipped missing file: $input_file"
        fi
    done
    
    echo "🎉 Merge completed: $total_merged total entries in $output_file"
    return 0
}

# Split playlist into multiple files
split_playlist() {
    local input_file="$1"
    local output_prefix="$2"
    local entries_per_file="$3"
    
    if [[ ! -f "$input_file" ]]; then
        log "ERROR: Input playlist file does not exist: $input_file"
        return 1
    fi
    
    local current_file_index=1
    local current_entry_count=0
    local current_output_file="${output_prefix}_part${current_file_index}.txt"
    
    # Initialize first output file
    initialize_playlist_file "$current_output_file"
    
    echo "✂️  Splitting playlist into files with $entries_per_file entries each..."
    
    while IFS= read -r line; do
        if [[ -n "$line" && "$line" =~ ^youtube:// ]]; then
            if [[ $current_entry_count -ge $entries_per_file ]]; then
                echo "   ✅ Created $current_output_file with $current_entry_count entries"
                current_file_index=$((current_file_index + 1))
                current_output_file="${output_prefix}_part${current_file_index}.txt"
                initialize_playlist_file "$current_output_file"
                current_entry_count=0
            fi
            
            echo "$line" >> "$current_output_file"
            current_entry_count=$((current_entry_count + 1))
        fi
    done < "$input_file"
    
    if [[ $current_entry_count -gt 0 ]]; then
        echo "   ✅ Created $current_output_file with $current_entry_count entries"
    fi
    
    echo "🎉 Split completed: $current_file_index files created"
    return 0
}


