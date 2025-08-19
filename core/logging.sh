#!/bin/bash

log() {
    local message="$1"
    local log_file="${2:-logs/channel_activity.log}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$log_file" >&2
}
