# 🎬 YouTube yt-dlp Setup Guide

## yt-dlp Installation

### Ubuntu/Debian
```bash
sudo apt install yt-dlp
```

### CentOS/RHEL
```bash
sudo yum install yt-dlp
```

### macOS
```bash
brew install yt-dlp
```

### Using pip
```bash
pip install yt-dlp
```

## Required Tools

Install these tools if not already available:

### Ubuntu/Debian
```bash
sudo apt install jq ffmpeg
```

### CentOS/RHEL
```bash
sudo yum install jq ffmpeg
```

### macOS
```bash
brew install jq ffmpeg
```

## Testing Your Setup

### Check yt-dlp Installation
```bash
which yt-dlp
yt-dlp --version
```

### Test yt-dlp with YouTube
```bash
yt-dlp --dump-json --no-playlist "https://www.youtube.com/watch?v=dQw4w9WgXcQ" | jq '.title'
```

## Advantages

- **No API Key Required** - Works immediately without setup
- **No Quotas** - No daily limits or API restrictions
- **Direct Access** - Gets video info directly from YouTube
- **Slower Processing** - Each video requires individual lookup

## Performance Tips

- Use shorter target durations for faster processing
- Don't run multiple channel creations simultaneously
- Process during off-peak hours
- Monitor system resources during processing

## Troubleshooting

### yt-dlp Not Found
```bash
# Check if yt-dlp is installed
which yt-dlp

# Install if missing
pip install yt-dlp
# or
sudo apt install yt-dlp
```

### Common Issues
- **Rate limiting**: Add delays between requests
- **YouTube changes**: Update yt-dlp to latest version
- **Network issues**: Check connectivity and proxies

## Next Steps

Once setup is complete, see `youtube_quick_start_ytdlp.md` to create your first channel!

---

**Need help?** See `youtube_troubleshooting.md` for more detailed troubleshooting.
