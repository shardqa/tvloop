#!/bin/bash

# Migration script from Bats to Bashunit
# Main script that sources migration components

set -e

# Source migration modules
source "$(dirname "${BASH_SOURCE[0]}")/migrate_to_bashunit_main.sh"
