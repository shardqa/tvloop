#!/bin/bash

# YouTube Channel Creator for tvloop
# Main script that sources all YouTube channel creation components

CHANNEL_NAME="${1:-youtube_channel}"
YOUTUBE_CHANNEL="${2:-}"
TARGET_HOURS="${3:-24}"
AUTO_START="${4:-false}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dependencies
source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_api_channel.sh"

# Source YouTube channel creation modules
source "$(dirname "${BASH_SOURCE[0]}")/create_youtube_channel_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/create_youtube_channel_core.sh"

# Main execution
if [[ $# -lt 2 ]]; then
    show_usage
    exit 1
fi

create_youtube_channel "$CHANNEL_NAME" "$YOUTUBE_CHANNEL" "$TARGET_HOURS" "$AUTO_START"
