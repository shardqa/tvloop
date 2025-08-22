# 🎬 Simple Channel Creation Guide

## Quick Start

Create a new TV channel from your media folder with just one command!

```bash
./scripts/create_channel.sh <channel_name> <media_folder> [auto_start] [max_size_mb]
```

## Examples

### Create a Movies Channel
```bash
./scripts/create_channel.sh movies /home/user/Videos/Movies
```

### Create a TV Shows Channel and Start Playing
```bash
./scripts/create_channel.sh tv_shows /mnt/data/Emby true
```

### Create a Channel with File Size Limit (500MB max)
```bash
./scripts/create_channel.sh small_videos /mnt/data/Emby false 500
```

### Create an Anime Channel
```bash
./scripts/create_channel.sh anime /path/to/anime/folder
```

## What Happens Automatically

1. ✅ **Creates channel directory** (`channels/your_channel_name`)
2. ✅ **Scans media folder** for video files (mp4, mkv, avi, etc.)
3. ✅ **Creates playlist** with all your videos (with optional size filtering)
4. ✅ **Extracts metadata** (duration, title) automatically
5. ✅ **Initializes channel** with timing information
6. ✅ **Starts playing** (if you add `true` at the end)

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

## Supported Video Formats

- MP4 (.mp4)
- MKV (.mkv)
- AVI (.avi)
- MOV (.mov)
- WMV (.wmv)
- FLV (.flv)
- WebM (.webm)

## Channel Features

- 🔄 **Continuous Loop**: Videos play in sequence and loop forever
- ⏯️ **Resume Position**: If interrupted, continues from where it left off
- 📊 **Status Tracking**: Know what's playing and for how long
- 🎮 **Player Support**: Support for mpv
- 📁 **Auto-Scanning**: Automatically finds all video files in your folder
- 📏 **File Size Filtering**: Skip files larger than specified size (MB)

## Troubleshooting

### Media Folder Not Found
Make sure the path to your media folder is correct:
```bash
ls -la /path/to/your/media/folder
```

### No Videos Found
Check if your videos have supported extensions:
```bash
find /path/to/your/media/folder -name "*.mp4" -o -name "*.mkv"
```

### Files Too Large
If your video files are too large, use file size filtering:
```bash
# Create channel with 500MB file size limit
./scripts/create_channel.sh small_channel /mnt/data/Emby false 500

# Create channel with 1GB file size limit
./scripts/create_channel.sh medium_channel /mnt/data/Emby false 1024
```

### Player Issues
Make sure you have mpv installed:
```bash
which mpv
```

## Advanced Usage

### Custom Video Extensions
If you have videos with different extensions, you can modify the playlist manually or edit the playlist creator script.

### Create Test Videos
For testing and development, create small test videos:
```bash
# Create 5 test videos, 10 seconds each
./scripts/create_test_videos.sh /tmp/test_videos 5 10

# Create 3 test videos, 5 seconds each
./scripts/create_test_videos.sh /tmp/test_videos 3 5
```

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

---

**That's it!** Your personal TV channel is ready to play your media 24/7! 🎉
