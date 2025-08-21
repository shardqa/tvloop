#!/bin/bash

# Enable parallel execution on openSUSE by temporarily patching Bashunit
# This script creates a backup and modifies the OS detection to include openSUSE

set -e

BASHUNIT_FILE="lib/bashunit"
BACKUP_FILE="lib/bashunit.backup"

echo "🔧 Enabling parallel execution on openSUSE..."

# Create backup if it doesn't exist
if [[ ! -f "$BACKUP_FILE" ]]; then
    echo "📦 Creating backup of original bashunit..."
    cp "$BASHUNIT_FILE" "$BACKUP_FILE"
fi

# Check if already patched
if grep -q "check_os::is_opensuse" "$BASHUNIT_FILE"; then
    echo "✅ Parallel execution already enabled for openSUSE"
    exit 0
fi

# Add openSUSE detection function
echo "🔧 Adding openSUSE OS detection..."
sed -i '/function check_os::is_ubuntu() {/a\
function check_os::is_opensuse() {\
  command -v zypper > /dev/null\
}\
' "$BASHUNIT_FILE"

# Update the parallel detection to include openSUSE
echo "🔧 Updating parallel detection to include openSUSE..."
sed -i 's/check_os::is_ubuntu || check_os::is_windows/check_os::is_ubuntu || check_os::is_opensuse || check_os::is_windows/g' "$BASHUNIT_FILE"

# Export the new function
echo "🔧 Exporting openSUSE detection function..."
sed -i '/export -f check_os::is_ubuntu/a\
export -f check_os::is_opensuse\
' "$BASHUNIT_FILE"

echo "✅ Parallel execution enabled for openSUSE!"
echo "🚀 You can now run: make test"
echo ""
echo "💡 To restore original: cp lib/bashunit.backup lib/bashunit"
