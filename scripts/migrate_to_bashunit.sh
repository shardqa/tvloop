#!/bin/bash

# Migration script from Bats to Bashunit
# Converts .bats files to .bash files with Bashunit syntax

set -e

BATS_DIR="tests/unit"
BASHUNIT_DIR="tests"

echo "🔄 Migrating Bats tests to Bashunit..."

# Create backup
if [ ! -d "tests/unit_bats_backup" ]; then
    echo "📦 Creating backup of original Bats tests..."
    cp -r "$BATS_DIR" tests/unit_bats_backup
fi

# Function to convert a single file
convert_bats_file() {
    local bats_file="$1"
    local basename=$(basename "$bats_file" .bats)
    local bashunit_file="$BASHUNIT_DIR/test_${basename#test_}.bash"
    
    echo "🔄 Converting $bats_file -> $bashunit_file"
    
    # Start with basic file header
    cat > "$bashunit_file" << 'EOF'
#!/usr/bin/env bash

# Migrated from Bats to Bashunit

source "$(pwd)/tests/test_helper.bash"

EOF
    
    # Process the file line by line
    local in_test=false
    local test_name=""
    local test_body=""
    local setup_content=""
    local teardown_content=""
    local skip_next_lines=0
    
    while IFS= read -r line; do
        # Skip certain lines
        if [ $skip_next_lines -gt 0 ]; then
            ((skip_next_lines--))
            continue
        fi
        
        # Skip shebang and load lines
        if [[ "$line" =~ ^#!/usr/bin/env\ bats$ ]] || 
           [[ "$line" =~ ^load\ .* ]] ||
           [[ "$line" =~ load.*bats-support ]] ||
           [[ "$line" =~ load.*bats-assert ]]; then
            continue
        fi
        
        # Handle setup function
        if [[ "$line" =~ ^setup\(\)\ \{$ ]]; then
            setup_content="function set_up() {"
            continue
        fi
        
        # Handle teardown function  
        if [[ "$line" =~ ^teardown\(\)\ \{$ ]]; then
            teardown_content="function tear_down() {"
            continue
        fi
        
        # Handle @test lines
        if [[ "$line" =~ ^@test\ \"(.*)\"\ \{$ ]]; then
            test_name="${BASH_REMATCH[1]}"
            # Convert test name to function name
            test_name=$(echo "$test_name" | sed 's/[^a-zA-Z0-9_]/_/g' | sed 's/__*/_/g' | sed 's/^_*//' | sed 's/_*$//')
            in_test=true
            test_body="function test_${test_name}() {"
            continue
        fi
        
        # Handle end of functions
        if [[ "$line" == "}" ]]; then
            if [ "$in_test" = true ]; then
                # End of test function
                echo "$test_body" >> "$bashunit_file"
                echo "}" >> "$bashunit_file"
                echo "" >> "$bashunit_file"
                in_test=false
                test_body=""
            elif [ -n "$setup_content" ]; then
                # End of setup function
                echo "$setup_content" >> "$bashunit_file"
                echo "}" >> "$bashunit_file"
                echo "" >> "$bashunit_file"
                setup_content=""
            elif [ -n "$teardown_content" ]; then
                # End of teardown function
                echo "$teardown_content" >> "$bashunit_file"
                echo "}" >> "$bashunit_file"
                echo "" >> "$bashunit_file"
                teardown_content=""
            fi
            continue
        fi
        
        # Convert assertions and other content
        local converted_line="$line"
        
        # Convert Bats assertions to Bashunit
        converted_line=$(echo "$converted_line" | sed 's/assert_success/assert_equals 0 $?/g')
        converted_line=$(echo "$converted_line" | sed 's/assert_failure/assert_not_equals 0 $?/g')
        converted_line=$(echo "$converted_line" | sed 's/assert_output --partial/assert_contains/g')
        converted_line=$(echo "$converted_line" | sed 's/assert_output --regexp/assert_matches/g')
        converted_line=$(echo "$converted_line" | sed 's/assert_output/assert_equals/g')
        converted_line=$(echo "$converted_line" | sed 's/refute_output/assert_not_equals/g')
        converted_line=$(echo "$converted_line" | sed 's/\$status/\$?/g')
        converted_line=$(echo "$converted_line" | sed 's/\$output/\$result/g')
        converted_line=$(echo "$converted_line" | sed 's/run /result=$(/g')
        
        # Handle run commands specially
        if [[ "$converted_line" =~ result=\$\((.*)\)$ ]]; then
            local command="${BASH_REMATCH[1]}"
            converted_line="    local result"
            converted_line+="\n    result=\$($command)"
            converted_line+="\n    local exit_code=\$?"
        fi
        
        # Add line to appropriate section
        if [ "$in_test" = true ]; then
            test_body+="\n    $converted_line"
        elif [ -n "$setup_content" ]; then
            setup_content+="\n    $converted_line"
        elif [ -n "$teardown_content" ]; then
            teardown_content+="\n    $converted_line"
        else
            # Regular line outside functions
            if [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
                echo "$converted_line" >> "$bashunit_file"
            fi
        fi
        
    done < "$bats_file"
    
    echo "✅ Converted $bashunit_file"
}

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
