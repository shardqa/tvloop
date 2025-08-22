# YouTube Usage Guide

This guide explains how to use YouTube integration in tvloop.

## Prerequisites

Before using YouTube features, complete the [YouTube Setup Guide](youtube_setup.md).

## Step 4: Create YouTube Playlist

Use the YouTube playlist manager to create playlists from YouTube URLs:

```bash
# Create a playlist from a YouTube playlist URL
./scripts/youtube_playlist_manager.sh channels/youtube_channel create 'https://www.youtube.com/playlist?list=PLxxxxxxxx'

# Create a playlist from a single video
./scripts/youtube_playlist_manager.sh channels/youtube_channel create 'https://www.youtube.com/watch?v=xxxxxxxx'

# Add more videos to existing playlist
./scripts/youtube_playlist_manager.sh channels/youtube_channel add 'https://www.youtube.com/watch?v=yyyyyyyy'

# List existing playlists
./scripts/youtube_playlist_manager.sh channels/youtube_channel list

# Show playlist information
./scripts/youtube_playlist_manager.sh channels/youtube_channel info
```

## Step 5: Play YouTube Channel

Use the YouTube channel player to start playback:

```bash
# Initialize the channel
./scripts/youtube_channel_player.sh channels/youtube_channel init

# Start playing with mpv (default)
./scripts/youtube_channel_player.sh channels/youtube_channel play

# Start playing with mpv
./scripts/youtube_channel_player.sh channels/youtube_channel play mpv

# Check channel status
./scripts/youtube_channel_player.sh channels/youtube_channel status

# Stop the channel
./scripts/youtube_channel_player.sh channels/youtube_channel stop
```

## Basic Commands

### Playlist Management
- `create <url>` - Create playlist from YouTube URL
- `add <url>` - Add video to existing playlist
- `list` - Show existing playlists
- `info` - Show detailed playlist information

### Channel Control
- `init` - Initialize channel state
- `play [player]` - Start playback (mpv)
- `stop` - Stop playback
- `status` - Show channel and player status

## Player Types

- **mpv** (default) - Lightweight, fast player


## See Also

- [YouTube Format Reference](youtube_format.md) - Playlist format details
- [YouTube Examples](youtube_examples.md) - Practical examples
- [YouTube Troubleshooting](youtube_troubleshooting.md) - Common issues and solutions
