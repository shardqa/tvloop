#!/bin/bash

# YouTube Channel Creator Usage Module
# Handles help and usage information

show_usage() {
    echo "🎬 YouTube Channel Creator for tvloop"
    echo ""
    echo "Usage: $0 <channel_name> <youtube_channel> [target_hours] [auto_start]"
    echo ""
    echo "Parameters:"
    echo "  channel_name     - Name for the new channel (e.g., 'jovem_nerd', 'tech_channel')"
    echo "  youtube_channel  - YouTube channel (URL, @username, or channel ID)"
    echo "  target_hours     - Target duration in hours (default: 24)"
    echo "  auto_start       - 'true' to start playing immediately (optional)"
    echo ""
    echo "YouTube Channel Formats:"
    echo "  - Channel URL: https://www.youtube.com/@JovemNerd"
    echo "  - Username: @JovemNerd"
    echo "  - Channel ID: UC..."
    echo ""
    echo "Examples:"
    echo "  $0 jovem_nerd https://www.youtube.com/@JovemNerd"
    echo "  $0 tech_channel @JovemNerd 12"
    echo "  $0 gaming_channel UC1234567890 48 true"
    echo ""
    echo "This script will:"
    echo "  1. Create channel directory"
    echo "  2. Fetch videos from YouTube channel"
    echo "  3. Create 24-hour playlist automatically"
    echo "  4. Initialize channel with timing"
    echo "  5. Start playing (if auto_start=true)"
}
