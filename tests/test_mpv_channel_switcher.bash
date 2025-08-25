#!/bin/bash

# Test runner for mpv_channel_switcher.lua functionality
# Orchestrates all mpv_channel_switcher test suites

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Source individual test suites
source "$(dirname "${BASH_SOURCE[0]}")/test_mpv_channel_switcher_basic.bash"
source "$(dirname "${BASH_SOURCE[0]}")/test_mpv_channel_switcher_env_error.bash"
source "$(dirname "${BASH_SOURCE[0]}")/test_mpv_channel_switcher_integration.bash"

# Run all test suites
run_all_tests() {
    echo "Running complete mpv_channel_switcher test suite..."
    echo "=================================================="
    
    # Run basic tests
    run_basic_tests
    echo ""
    
    # Run environment and error handling tests
    run_env_error_tests
    echo ""
    
    # Run integration tests
    run_integration_tests
    echo ""
    
    echo "=================================================="
    echo "✅ All mpv_channel_switcher test suites passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi
