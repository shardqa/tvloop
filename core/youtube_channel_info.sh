#!/bin/bash

# YouTube Channel Info Module
# Main module that sources all channel info components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Source channel info modules
source "$PROJECT_ROOT/core/youtube_channel_info_basic.sh"
source "$PROJECT_ROOT/core/youtube_channel_info_detailed.sh"

