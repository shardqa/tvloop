#!/bin/bash

# tvloop create command functionality tests
# Main test runner that sources all tvloop create test modules

source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Source tvloop create test modules
source "$(dirname "${BASH_SOURCE[0]}")/test_tvloop_create_basic.bash"
source "$(dirname "${BASH_SOURCE[0]}")/test_tvloop_create_advanced.bash"
