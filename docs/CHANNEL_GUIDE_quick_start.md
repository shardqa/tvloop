# 🎬 Simple Channel Creation Guide - Quick Start

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

## Supported Video Formats

- MP4 (.mp4)
- MKV (.mkv)
- AVI (.avi)
- MOV (.mov)
- WMV (.wmv)
- FLV (.flv)
- WebM (.webm)
