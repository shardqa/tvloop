#!/usr/bin/env bats

# YouTube API Duration Parsing Tests
# Tests for ISO 8601 duration conversion functionality

load test_helper

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "convert_iso_duration_to_seconds for seconds only" {
    run convert_iso_duration_to_seconds "PT30S"
    [ "$status" -eq 0 ]
    [ "$output" = "30" ]
}

@test "convert_iso_duration_to_seconds for minutes and seconds" {
    run convert_iso_duration_to_seconds "PT2M30S"
    [ "$status" -eq 0 ]
    [ "$output" = "150" ]
}

@test "convert_iso_duration_to_seconds for hours, minutes and seconds" {
    run convert_iso_duration_to_seconds "PT1H2M30S"
    [ "$status" -eq 0 ]
    [ "$output" = "3750" ]
}

@test "convert_iso_duration_to_seconds for hours only" {
    run convert_iso_duration_to_seconds "PT2H"
    [ "$status" -eq 0 ]
    [ "$output" = "7200" ]
}

@test "convert_iso_duration_to_seconds for minutes only" {
    run convert_iso_duration_to_seconds "PT15M"
    [ "$status" -eq 0 ]
    [ "$output" = "900" ]
}

@test "convert_iso_duration_to_seconds returns 0 for invalid format" {
    run convert_iso_duration_to_seconds "invalid_format"
    [ "$status" -eq 0 ]
    [ "$output" = "0" ]
}

@test "convert_iso_duration_to_seconds handles empty input" {
    run convert_iso_duration_to_seconds ""
    [ "$status" -eq 0 ]
    [ "$output" = "0" ]
}
