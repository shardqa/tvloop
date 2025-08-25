#!/bin/bash

# Automated Channel Creator for tvloop
# Main module that sources channel creation functionality

CHANNEL_NAME="${1:-new_channel}"
MEDIA_FOLDER="${2:-}"
AUTO_START="${3:-false}"
MAX_SIZE_MB="${4:-0}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

# Source modules
source "$(dirname "${BASH_SOURCE[0]}")/create_channel_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/create_channel_core.sh"

# Main execution
if [[ $# -lt 2 ]]; then
    show_usage
    exit 1
fi

create_channel "$CHANNEL_NAME" "$MEDIA_FOLDER" "$AUTO_START" "$MAX_SIZE_MB"
