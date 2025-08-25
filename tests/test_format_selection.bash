#!/bin/bash

# Test file for format selection functionality
# Main test runner that sources all format selection test modules

set -e

# Source test helper
source "$(dirname "${BASH_SOURCE[0]}")/test_helper.bash"

# Source format selection test modules
source "$(dirname "${BASH_SOURCE[0]}")/test_format_selection_basic.bash"
source "$(dirname "${BASH_SOURCE[0]}")/test_format_selection_advanced.bash"

# Run all tests
run_tests() {
    echo "Running format selection tests..."
    
    test_format_selection_function_exists
    test_default_format_combination
    test_format_fallback_mechanism
    test_automatic_360p_selection
    test_format_validation
    test_mpv_format_integration
    
    echo "✅ All format selection tests passed!"
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests
fi
