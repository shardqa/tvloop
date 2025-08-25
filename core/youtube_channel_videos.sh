#!/bin/bash

# YouTube Channel Videos Module
# Main module that sources all video components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/youtube_channel_info.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Source video modules
source "$PROJECT_ROOT/core/youtube_channel_videos_core.sh"
source "$PROJECT_ROOT/core/youtube_channel_videos_utils.sh"

