# YouTube Advanced Examples

This document provides advanced examples for using YouTube integration in tvloop.

## Educational Content Channel

Create a channel for educational videos:

```bash
# Create educational playlist
./scripts/youtube_playlist_manager.sh channels/education create 'https://www.youtube.com/playlist?list=PLzzzzzzzz'

# Add individual educational videos
./scripts/youtube_playlist_manager.sh channels/education add 'https://www.youtube.com/watch?v=aaaaaaaa'
./scripts/youtube_playlist_manager.sh channels/education add 'https://www.youtube.com/watch?v=bbbbbbbb'

# Play the educational channel
./scripts/youtube_channel_player.sh channels/education init
./scripts/youtube_channel_player.sh channels/education play
```

## Gaming Channel

Create a gaming content channel:

```bash
# Create gaming playlist
./scripts/youtube_playlist_manager.sh channels/gaming create 'https://www.youtube.com/playlist?list=PLgggggggg'

# Add gaming videos
./scripts/youtube_playlist_manager.sh channels/gaming add 'https://www.youtube.com/watch?v=cccccccc'
./scripts/youtube_playlist_manager.sh channels/gaming add 'https://www.youtube.com/watch?v=dddddddd'

# Play the gaming channel
./scripts/youtube_channel_player.sh channels/gaming init
./scripts/youtube_channel_player.sh channels/gaming play
```

## Playlist Management

Manage your playlists:

```bash
# List all playlists in a channel
./scripts/youtube_playlist_manager.sh channels/music_channel list

# Show detailed playlist information
./scripts/youtube_playlist_manager.sh channels/music_channel info

# Add videos to existing playlist
./scripts/youtube_playlist_manager.sh channels/music_channel add 'https://www.youtube.com/watch?v=newwwwww'
```

## Multi-Channel Setup

Set up multiple channels for different content types:

```bash
# Create channels for different content types
mkdir -p channels/{music,news,education,gaming,entertainment}

# Set up each channel
./scripts/youtube_playlist_manager.sh channels/music create 'https://www.youtube.com/playlist?list=PLmusic'
./scripts/youtube_playlist_manager.sh channels/news create 'https://www.youtube.com/playlist?list=PLnews'
./scripts/youtube_playlist_manager.sh channels/education create 'https://www.youtube.com/playlist?list=PLeducation'

# Initialize all channels
./scripts/youtube_channel_player.sh channels/music init
./scripts/youtube_channel_player.sh channels/news init
./scripts/youtube_channel_player.sh channels/education init
```

## See Also

- [YouTube Basic Examples](youtube_examples.md) - Basic examples
- [YouTube Setup Guide](youtube_setup.md) - Initial setup
- [YouTube Usage Guide](youtube_usage.md) - How to use YouTube features
- [YouTube Format Reference](youtube_format.md) - Playlist format details
- [YouTube Troubleshooting](youtube_troubleshooting.md) - Common issues and solutions
