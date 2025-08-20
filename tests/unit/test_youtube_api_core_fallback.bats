#!/usr/bin/env bats

# YouTube API Core Fallback Tests
# Tests for wget fallback and error handling

load test_helper

setup() {
    setup_test_environment
    export YOUTUBE_API_KEY="test_api_key_12345"
}

teardown() {
    teardown_test_environment
}

@test "youtube_api_request uses wget when curl not available" {
    # Mock wget to return success
    wget() {
        echo '{"items":[]}'
        return 0
    }
    export -f wget
    
    # Mock curl to not exist
    curl() {
        return 127
    }
    export -f curl
    
    # Mock command to return different results for curl and wget
    command() {
        if [[ "$2" == "curl" ]]; then
            return 1
        elif [[ "$2" == "wget" ]]; then
            return 0
        fi
    }
    export -f command
    
    run youtube_api_request "videos" "part=snippet&id=dQw4w9WgXcQ"
    [ "$status" -eq 0 ]
    [[ "$output" == *'{"items":[]}'* ]]
}

@test "youtube_api_request fails when neither curl nor wget available" {
    # Mock both curl and wget to not exist
    curl() {
        return 127
    }
    export -f curl
    
    wget() {
        return 127
    }
    export -f wget
    
    # Mock command to return failure for both curl and wget
    command() {
        if [[ "$2" == "curl" || "$2" == "wget" ]]; then
            return 1
        fi
        return 1
    }
    export -f command
    
    run youtube_api_request "videos" "part=snippet&id=dQw4w9WgXcQ"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Neither curl nor wget found"* ]]
}
