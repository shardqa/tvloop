#!/bin/bash

# Script to find large files in the tvloop project
# Helps identify files that need refactoring (>100 lines)

set -e

# Configuration
MAX_LINES=100
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to count lines in a file
count_lines() {
    local file="$1"
    wc -l < "$file" 2>/dev/null || echo "0"
}

# Function to get relative path
get_relative_path() {
    local file="$1"
    echo "${file#$PROJECT_ROOT/}"
}

# Function to get file extension
get_extension() {
    local file="$1"
    echo "${file##*.}"
}

echo -e "${BLUE}🔍 Finding large files in tvloop project (>${MAX_LINES} lines)${NC}"
echo -e "${BLUE}Project root: ${PROJECT_ROOT}${NC}"
echo ""

# Initialize counters
medium_count=0
large_count=0
very_large_count=0

# Temporary file to store results
temp_file=$(mktemp)

# Find all files, excluding common ignore patterns
find "$PROJECT_ROOT" -type f \
    -not -path "*/node_modules/*" \
    -not -path "*/coverage/*" \
    -not -path "*/.git/*" \
    -not -path "*/logs/*" \
    -not -path "*/lib/*" \
    -not -path "*/.cursor/*" \
    -not -path "*/tmp/*" \
    -not -path "*/temp/*" \
    -not -name "*.log" \
    -not -name "*.pid" \
    -not -name "*.json" \
    -not -name "*.txt" \
    -not -name "*.conf" \
    -not -path "*/scripts/find_big_files.sh" \
    \( -name "*.sh" -o -name "*.bash" -o -name "*.lua" -o -name "*.md" -o -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.mk" \) \
    | while read -r file; do
    
    lines=$(count_lines "$file")
    relative_path=$(get_relative_path "$file")
    extension=$(get_extension "$file")
    
    # Only process files with more than MAX_LINES
    if [ "$lines" -gt "$MAX_LINES" ]; then
        # Color coding based on size
        if [ "$lines" -gt 300 ]; then
            color="$RED"
            size_indicator="🔴 VERY LARGE"
            echo "very_large" >> "$temp_file"
        elif [ "$lines" -gt 200 ]; then
            color="$YELLOW"
            size_indicator="🟡 LARGE"
            echo "large" >> "$temp_file"
        else
            color="$GREEN"
            size_indicator="🟢 MEDIUM"
            echo "medium" >> "$temp_file"
        fi
        
        printf "${color}%-8s${NC} %-12s %s\n" "$lines" "[$extension]" "$relative_path"
    fi
done | sort -nr

# Count files in each category
medium_count=$(grep -c "^medium$" "$temp_file" 2>/dev/null || echo "0")
large_count=$(grep -c "^large$" "$temp_file" 2>/dev/null || echo "0")
very_large_count=$(grep -c "^very_large$" "$temp_file" 2>/dev/null || echo "0")

# Clean up temporary file
rm -f "$temp_file"

echo ""
echo -e "${BLUE}📊 Summary:${NC}"
echo -e "${GREEN}🟢 MEDIUM${NC}  (101-200 lines) - Consider refactoring (${medium_count} files)"
echo -e "${YELLOW}🟡 LARGE${NC}   (201-300 lines) - Should be refactored (${large_count} files)"
echo -e "${RED}🔴 VERY LARGE${NC} (300+ lines) - Must be refactored (${very_large_count} files)"
echo ""
echo -e "${BLUE}💡 Files excluded: node_modules, coverage, .git, logs, lib, *.json, *.txt, *.conf, *.log, *.pid${NC}"
