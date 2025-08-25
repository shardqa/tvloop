#!/bin/bash

# YouTube Channel Resolver Module
# Main module that sources channel resolution functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/youtube_api_core.sh"
source "$PROJECT_ROOT/core/logging.sh"

# Source modules
source "$(dirname "${BASH_SOURCE[0]}")/youtube_channel_resolver_core.sh"
source "$(dirname "${BASH_SOURCE[0]}")/youtube_channel_resolver_utils.sh"

