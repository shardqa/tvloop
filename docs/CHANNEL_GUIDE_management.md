# 🎬 Channel Management Guide

## Managing Your Channel

### Start Playing
```bash
./scripts/channel_player.sh channels/your_channel_name tune mpv
```

### Stop Playing
```bash
./scripts/channel_player.sh channels/your_channel_name stop
```

### Check Status
```bash
./scripts/channel_tracker.sh channels/your_channel_name status
```

### View Playlist Info
```bash
./scripts/playlist_manager.sh channels/your_channel_name/playlist.txt info
```

## Channel Features

- 🔄 **Continuous Loop**: Videos play in sequence and loop forever
- ⏯️ **Resume Position**: If interrupted, continues from where it left off
- 📊 **Status Tracking**: Know what's playing and for how long
- 🎮 **Player Support**: Support for mpv
- 📁 **Auto-Scanning**: Automatically finds all video files in your folder
- 📏 **File Size Filtering**: Skip files larger than specified size (MB)

## Advanced Usage

### Multiple Channels
You can create as many channels as you want:
```bash
./scripts/create_channel.sh action_movies /path/to/action
./scripts/create_channel.sh comedy_shows /path/to/comedy
./scripts/create_channel.sh documentaries /path/to/docs
```

### Channel Switching
Stop one channel and start another:
```bash
./scripts/channel_player.sh channels/action_movies stop
./scripts/channel_player.sh channels/comedy_shows tune mpv
```

### Create Test Videos
For testing and development, create small test videos:
```bash
# Create 5 test videos, 10 seconds each
./scripts/create_test_videos.sh /tmp/test_videos 5 10

# Create 3 test videos, 5 seconds each
./scripts/create_test_videos.sh /tmp/test_videos 3 5
```
