#!/bin/bash

# YouTube Playlist Count Creation Module
# Main module that sources playlist count creation functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_playlist_count_helpers.sh"

# Source modules
source "$(dirname "${BASH_SOURCE[0]}")/youtube_playlist_count_creation_core.sh"
source "$(dirname "${BASH_SOURCE[0]}")/youtube_playlist_count_creation_specialized.sh"
