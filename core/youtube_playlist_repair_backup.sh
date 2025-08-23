#!/bin/bash

# YouTube Playlist Repair Backup Module
# Backup and restore functions for playlist files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

restore_playlist_backup() {
    local playlist_file="$1"
    local backup_file="${playlist_file}.backup"
    
    if [[ ! -f "$backup_file" ]]; then
        log "ERROR: Backup file does not exist: $backup_file"
        return 1
    fi
    
    cp "$backup_file" "$playlist_file"
    
    echo "🔄 Playlist restored from backup: $backup_file"
    return 0
}

create_playlist_backup() {
    local playlist_file="$1"
    local backup_suffix="${2:-backup}"
    local backup_file="${playlist_file}.${backup_suffix}"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    cp "$playlist_file" "$backup_file"
    
    echo "📋 Backup created: $backup_file"
    return 0
}

create_timestamped_backup() {
    local playlist_file="$1"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_file="${playlist_file}.backup_${timestamp}"
    
    if [[ ! -f "$playlist_file" ]]; then
        log "ERROR: Playlist file does not exist: $playlist_file"
        return 1
    fi
    
    cp "$playlist_file" "$backup_file"
    
    echo "📋 Timestamped backup created: $backup_file"
    return 0
}


