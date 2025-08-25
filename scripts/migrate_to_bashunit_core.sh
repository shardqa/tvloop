#!/bin/bash

# Migration script core functionality
# Core migration logic from Bats to Bashunit

set -e

BATS_DIR="tests/unit"
BASHUNIT_DIR="tests"

# Source migration modules
source "$(dirname "${BASH_SOURCE[0]}")/migrate_to_bashunit_parser.sh"
