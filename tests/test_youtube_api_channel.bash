#!/bin/bash

# Test runner for youtube_api_channel.sh functionality
# Orchestrates all YouTube API channel test suites

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Source individual test suites
source "$(dirname "${BASH_SOURCE[0]}")/test_youtube_api_channel_basic.bash"
source "$(dirname "${BASH_SOURCE[0]}")/test_youtube_api_channel_validation.bash"
source "$(dirname "${BASH_SOURCE[0]}")/test_youtube_api_channel_integration.bash"

# Run all test suites
run_all_tests() {
    echo "Running complete youtube_api_channel test suite..."
    echo "=================================================="
    
    # Run basic tests
    run_basic_tests
    echo ""
    
    # Run validation tests
    run_validation_tests
    echo ""
    
    # Run integration tests
    run_integration_tests
    echo ""
    
    echo "=================================================="
    echo "✅ All youtube_api_channel test suites passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi
