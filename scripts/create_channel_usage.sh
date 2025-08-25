#!/bin/bash

# Create Channel Usage Module
# Handles help and usage display logic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

show_usage() {
    echo "🎬 Automated Channel Creator for tvloop"
    echo ""
    echo "Usage: $0 <channel_name> <media_folder> [auto_start] [max_size_mb]"
    echo ""
    echo "Parameters:"
    echo "  channel_name  - Name for the new channel (e.g., 'movies', 'tv_shows')"
    echo "  media_folder  - Path to folder containing video files"
    echo "  auto_start    - 'true' to start playing immediately (optional)"
    echo "  max_size_mb   - Maximum file size in MB (0 = no limit, optional)"
    echo ""
    echo "Examples:"
    echo "  $0 movies /home/user/Videos/Movies"
    echo "  $0 tv_shows /mnt/data/Emby true"
    echo "  $0 anime /path/to/anime/folder"
    echo "  $0 small_videos /mnt/data/Emby false 500"
    echo ""
    echo "This script will:"
    echo "  1. Create channel directory"
    echo "  2. Scan media folder for videos"
    echo "  3. Create playlist automatically (with size filtering)"
    echo "  4. Initialize channel"
    echo "  5. Start playing (if auto_start=true)"
}
