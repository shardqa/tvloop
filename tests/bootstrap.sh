#!/bin/bash

# Bootstrap file for bashunit tests
# This file is loaded before all tests

# Set up test environment
export TEST_MODE="true"

# Ensure we're in the project root
cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")"

# Source test helper
source "tests/test_helper.bash"
