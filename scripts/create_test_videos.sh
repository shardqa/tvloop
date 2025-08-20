#!/bin/bash

# Test Video Creator for tvloop
# Creates small test video files for development and testing

OUTPUT_DIR="${1:-/tmp/tvloop_test_videos}"
COUNT="${2:-5}"
DURATION="${3:-10}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/core/logging.sh"

show_usage() {
    echo "🎬 Test Video Creator for tvloop"
    echo ""
    echo "Usage: $0 [output_dir] [count] [duration]"
    echo ""
    echo "Parameters:"
    echo "  output_dir  - Directory to create test videos (default: /tmp/tvloop_test_videos)"
    echo "  count       - Number of test videos to create (default: 5)"
    echo "  duration    - Duration of each video in seconds (default: 10)"
    echo ""
    echo "Examples:"
    echo "  $0 /tmp/test_videos 3 5"
    echo "  $0 /home/user/test_media 10 30"
    echo ""
    echo "This script will create small test video files using ffmpeg."
}

create_test_videos() {
    local output_dir="$1"
    local count="$2"
    local duration="$3"
    
    echo "🎬 Creating $count test videos in: $output_dir"
    echo "⏱️  Duration: ${duration}s each"
    echo ""
    
    # Create output directory
    mkdir -p "$output_dir"
    
    # Check if ffmpeg is available
    if ! command -v ffmpeg >/dev/null 2>&1; then
        log "ERROR: ffmpeg not found. Please install ffmpeg to create test videos."
        echo "You can install ffmpeg with: sudo apt install ffmpeg"
        return 1
    fi
    
    local created=0
    
    for i in $(seq 1 $count); do
        local filename="test_video_${i}.mp4"
        local filepath="$output_dir/$filename"
        
        echo "Creating video $i/$count: $filename"
        
        # Create a simple test video with different colors
        ffmpeg -f lavfi -i testsrc=duration=$duration:size=320x240:rate=1 \
               -f lavfi -i sine=frequency=440:duration=$duration \
               -c:v mpeg4 -c:a aac -shortest \
               -y "$filepath" >/dev/null 2>&1
        
        if [[ $? -eq 0 ]]; then
            echo "✅ Created: $filename"
            created=$((created + 1))
        else
            echo "❌ Failed to create: $filename"
        fi
    done
    
    echo ""
    echo "🎉 Successfully created $created test videos!"
    echo "📁 Location: $output_dir"
    echo ""
    echo "You can now create a channel with:"
    echo "  ./scripts/create_channel.sh test_channel $output_dir"
}

# Main execution
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    exit 0
fi

create_test_videos "$OUTPUT_DIR" "$COUNT" "$DURATION"
