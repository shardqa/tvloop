#!/bin/bash

echo "Testing mpv with local video file..."
mpv --force-window --geometry=50%:50% /tmp/test_video.mp4

echo "Testing mpv with YouTube URL..."
mpv --force-window --geometry=50%:50% "https://www.youtube.com/watch?v=Iiiq8JELcnM"
