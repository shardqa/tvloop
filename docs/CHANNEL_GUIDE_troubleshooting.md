# 🎬 Channel Troubleshooting Guide

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

---

**That's it!** Your personal TV channel is ready to play your media 24/7! 🎉
