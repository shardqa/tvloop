#!/usr/bin/env bash

# Channel State Module Tests
# Main test runner that sources test modules

source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Source the channel state module
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/core/channel_state.sh"

# Source test modules
source "$(dirname "${BASH_SOURCE[0]}")/test_channel_state_basic.bash"
source "$(dirname "${BASH_SOURCE[0]}")/test_channel_state_status.bash"
