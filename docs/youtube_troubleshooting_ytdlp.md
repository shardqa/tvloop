# 🎬 YouTube yt-dlp Troubleshooting

## yt-dlp Version Issues

### yt-dlp Not Found
```bash
# Check if yt-dlp is installed
which yt-dlp

# Install if missing
pip install yt-dlp
# or
sudo apt install yt-dlp
```

### yt-dlp Problems
- **Rate limiting**: Add delays between requests
- **YouTube changes**: Update yt-dlp to latest version
- **Network issues**: Check connectivity and proxies

## yt-dlp Version Common Issues

### Channel Not Found
- Verify the channel URL/username is correct
- Check if the channel is public
- Try using the channel ID instead of username

### No Videos Found
- Check if the channel has uploaded videos
- Verify yt-dlp is working correctly
- Some videos might be skipped due to duration issues

### Playlist Too Short
- The channel might not have enough videos
- Try increasing the `max_videos` parameter
- Some videos might be skipped due to duration issues

### Rate Limiting
- YouTube may throttle requests if too many are made
- Wait a few minutes and try again
- Consider using fewer videos or longer intervals

## yt-dlp Version Performance Issues

- Each video requires individual lookup
- Monitor system resources during processing
- Consider using shorter target durations

## yt-dlp Version Error Messages

- **"Video file not found"**: Normal for YouTube URLs
- **"Could not get video info"**: Video might be private/unavailable

## yt-dlp Version Getting Help

```bash
# Test yt-dlp
yt-dlp --dump-json --no-playlist "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Check required tools
which ffmpeg yt-dlp
```

## yt-dlp Version Prevention Tips

- Keep yt-dlp updated
