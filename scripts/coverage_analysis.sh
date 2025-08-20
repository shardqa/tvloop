#!/bin/bash

COVERAGE_DIR="coverage"
RESULT_FILE="$COVERAGE_DIR/.resultset.json"

if [[ ! -f "$RESULT_FILE" ]]; then
    echo "No coverage data found. Run 'make test-coverage' first."
    exit 1
fi

echo "=== Coverage Analysis ==="
echo ""

# Get the main coverage data (use the tests/unit/ entry)
COVERAGE_DATA=$(jq -r '.["/bin/bash ./node_modules/.bin/bats tests/unit/"].coverage' "$RESULT_FILE" 2>/dev/null)

if [[ -z "$COVERAGE_DATA" || "$COVERAGE_DATA" == "null" ]]; then
    echo "No coverage data found in expected format."
    exit 1
fi

# Calculate coverage for each project file
echo "=== Project Files Coverage ==="
echo ""

# Filter only project files (not node_modules) and calculate overall project coverage
total_project_lines=0
total_project_covered=0

# First pass: calculate totals
while IFS= read -r file; do
    if [[ "$file" != *"node_modules"* ]]; then
        coverage_array=$(jq -r ".[\"$file\"]" <<< "$COVERAGE_DATA")
        total_lines=$(echo "$coverage_array" | jq 'length')
        covered_lines=$(echo "$coverage_array" | jq '[.[] | select(. != null and . > 0)] | length')
        
        if [[ "$total_lines" -gt 0 ]]; then
            total_project_lines=$((total_project_lines + total_lines))
            total_project_covered=$((total_project_covered + covered_lines))
        fi
    fi
done < <(jq -r 'keys[]' <<< "$COVERAGE_DATA")

# Second pass: display individual file coverage
jq -r 'keys[]' <<< "$COVERAGE_DATA" | grep -v "node_modules" | while read -r file; do
    # Get the coverage array for this file
    coverage_array=$(jq -r ".[\"$file\"]" <<< "$COVERAGE_DATA")
    
    # Count total lines and covered lines
    total_lines=$(echo "$coverage_array" | jq 'length')
    covered_lines=$(echo "$coverage_array" | jq '[.[] | select(. != null and . > 0)] | length')
    
    if [[ "$total_lines" -gt 0 ]]; then
        coverage_percent=$((covered_lines * 100 / total_lines))
        filename=$(basename "$file")
        
        if [[ "$coverage_percent" -eq 0 ]]; then
            echo "❌ $filename (0%)"
        elif [[ "$coverage_percent" -lt 50 ]]; then
            echo "⚠️  $filename ($coverage_percent%)"
        elif [[ "$coverage_percent" -ge 80 ]]; then
            echo "✅ $filename ($coverage_percent%)"
        else
            echo "🟡 $filename ($coverage_percent%)"
        fi
    fi
done

# Display project-only coverage summary
if [[ "$total_project_lines" -gt 0 ]]; then
    project_coverage_percent=$((total_project_covered * 100 / total_project_lines))
    echo ""
    echo "=== Project-Only Coverage Summary ==="
    echo "Project files coverage: ${project_coverage_percent}% ($total_project_covered / $total_project_lines lines)"
fi

echo ""

# Show files that weren't executed at all
echo "=== Files Not Executed (Missing from Coverage) ==="
find core/ players/ scripts/ -name "*.sh" -type f | grep -v "coverage_analysis.sh\|setup_bashcov.sh\|setup_coverage.sh\|open_coverage.sh" | while read -r file; do
    if ! jq -r 'keys[]' <<< "$COVERAGE_DATA" | grep -q "$file"; then
        echo "🚫 $(basename "$file") (not executed)"
    fi
done

echo ""
echo "=== Coverage Summary ==="
echo "Open the HTML report for detailed line-by-line coverage:"
echo "  coverage/index.html"
echo ""
echo "Legend:"
echo "  ❌ = Uncovered (0%)"
echo "  ⚠️  = Low coverage (< 50%)"
echo "  🟡 = Medium coverage (50-79%)"
echo "  ✅ = Good coverage (>= 80%)"
echo "  🚫 = Not executed (missing from coverage)"
