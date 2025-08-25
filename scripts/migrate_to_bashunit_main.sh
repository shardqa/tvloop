#!/bin/bash

# Migration script main functionality
# Main migration orchestration from Bats to Bashunit

set -e

# Source the core migration functionality
source "$(dirname "${BASH_SOURCE[0]}")/migrate_to_bashunit_core.sh"

echo "🔄 Migrating Bats tests to Bashunit..."

# Create backup
if [ ! -d "tests/unit_bats_backup" ]; then
    echo "📦 Creating backup of original Bats tests..."
    cp -r "$BATS_DIR" tests/unit_bats_backup
fi

# Convert all .bats files
for bats_file in "$BATS_DIR"/*.bats; do
    if [ -f "$bats_file" ]; then
        convert_bats_file "$bats_file"
    fi
done

echo ""
echo "🎉 Migration completed!"
echo "📁 Original files backed up to: tests/unit_bats_backup"
echo "📁 New Bashunit tests in: $BASHUNIT_DIR"
echo ""
echo "To test the migration:"
echo "  ./lib/bashunit tests/"
echo ""
echo "To test individual files:"
echo "  ./lib/bashunit tests/test_*.bash"
