#!/bin/bash

CHANNEL_DIR="${1:-channels/channel_1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/channel_state.sh"

case "${2:-status}" in
    "init")
        initialize_channel "$CHANNEL_DIR"
        ;;
    "status")
        get_channel_status "$CHANNEL_DIR"
        ;;
    *)
        echo "Usage: $0 [channel_dir] [command]"
        echo "Commands:"
        echo "  init    - Initialize channel state"
        echo "  status  - Show channel status (default)"
        ;;
esac
