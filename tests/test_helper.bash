#!/bin/bash

# Bashunit Test Helper
# Main module that sources test helper functionality

# Source project modules
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PROJECT_ROOT/core/logging.sh"
source "$PROJECT_ROOT/core/youtube_api.sh"

# Source helper modules
source "$(dirname "${BASH_SOURCE[0]}")/test_helper_environment.sh"
source "$(dirname "${BASH_SOURCE[0]}")/test_helper_utils.sh"