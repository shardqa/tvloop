#!/usr/bin/env bash

# Playlist Utils Module Tests
# Main test runner that sources all playlist utils test modules

source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Source the playlist utils module
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/core/playlist_utils.sh"

# Source playlist utils test modules
source "$(dirname "${BASH_SOURCE[0]}")/test_playlist_utils_basic.bash"
source "$(dirname "${BASH_SOURCE[0]}")/test_playlist_utils_validation.bash"
