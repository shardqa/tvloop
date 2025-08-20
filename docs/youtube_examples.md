# YouTube Examples

This document provides practical examples for using YouTube integration in tvloop.

## Create a Music Channel

Create a continuous music channel from a YouTube playlist:

```bash
# Create a music playlist
./scripts/youtube_playlist_manager.sh channels/music_channel create 'https://www.youtube.com/playlist?list=PLxxxxxxxx'

# Initialize the channel
./scripts/youtube_channel_player.sh channels/music_channel init

# Play the music channel
./scripts/youtube_channel_player.sh channels/music_channel play
```

## Create a News Channel

Create a news channel with VLC player:

```bash
# Create a news playlist
./scripts/youtube_playlist_manager.sh channels/news_channel create 'https://www.youtube.com/playlist?list=PLyyyyyyyy'

# Initialize the channel
./scripts/youtube_channel_player.sh channels/news_channel init

# Play the news channel with VLC
./scripts/youtube_channel_player.sh channels/news_channel play vlc
```

## Mix Local and YouTube Content

Create a mixed playlist with both local videos and YouTube content:

```bash
# Create a mixed playlist starting with a YouTube video
./scripts/youtube_playlist_manager.sh channels/mixed_channel create 'https://www.youtube.com/watch?v=xxxxxxxx'

# Add more YouTube videos
./scripts/youtube_playlist_manager.sh channels/mixed_channel add 'https://www.youtube.com/watch?v=yyyyyyyy'

# Add local videos (manually edit playlist.txt)
echo "/path/to/local/video.mp4|Local Video|120" >> channels/mixed_channel/playlist.txt
echo "/path/to/another/video.mp4|Another Local Video|180" >> channels/mixed_channel/playlist.txt

# Initialize and play the mixed channel
./scripts/youtube_channel_player.sh channels/mixed_channel init
./scripts/youtube_channel_player.sh channels/mixed_channel play
```

## Channel Management

Manage multiple channels:

```bash
# Check status of all channels
./scripts/youtube_channel_player.sh channels/music_channel status
./scripts/youtube_channel_player.sh channels/news_channel status

# Stop all channels
./scripts/youtube_channel_player.sh channels/music_channel stop
./scripts/youtube_channel_player.sh channels/news_channel stop

# Or stop all players at once
./scripts/player_controller.sh stop_all_players
```

## See Also

- [YouTube Advanced Examples](youtube_advanced_examples.md) - More complex examples
- [YouTube Setup Guide](youtube_setup.md) - Initial setup
- [YouTube Usage Guide](youtube_usage.md) - How to use YouTube features
- [YouTube Format Reference](youtube_format.md) - Playlist format details
- [YouTube Troubleshooting](youtube_troubleshooting.md) - Common issues and solutions
