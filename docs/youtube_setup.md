# YouTube API Integration Setup Guide

This guide explains how to set up YouTube API integration for tvloop.

## Prerequisites

1. **YouTube Data API v3 Key**: You need a Google Cloud API key with YouTube Data API v3 enabled
2. **yt-dlp**: Required for YouTube video playback
3. **mpv**: Video player for playback

## Step 1: Get YouTube Data API v3 Key

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the YouTube Data API v3:
   - Go to "APIs & Services" > "Library"
   - Search for "YouTube Data API v3"
   - Click "Enable"
4. Create credentials:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "API Key"
   - Copy the API key

## Step 2: Install Required Software

### Install yt-dlp
```bash
# Using pip
pip install yt-dlp

# Or using your system package manager
# Ubuntu/Debian
sudo apt install yt-dlp

# macOS
brew install yt-dlp
```

### Install Video Players
```bash
# Install mpv (recommended)
sudo apt install mpv  # Ubuntu/Debian
brew install mpv      # macOS


```

## Step 3: Configure API Key

Set your YouTube API key as an environment variable:

```bash
export YOUTUBE_API_KEY="your_api_key_here"
```

To make it permanent, add it to your shell profile:
```bash
echo 'export YOUTUBE_API_KEY="your_api_key_here"' >> ~/.bashrc
source ~/.bashrc
```

## Next Steps

After completing the setup:

1. **Create YouTube Playlists**: See [YouTube Usage Guide](youtube_usage.md)
2. **Play YouTube Channels**: See [YouTube Usage Guide](youtube_usage.md)
3. **Troubleshooting**: See [YouTube Troubleshooting](youtube_troubleshooting.md)
4. **Examples**: See [YouTube Examples](youtube_examples.md)
5. **Playlist Format**: See [YouTube Format Reference](youtube_format.md)
