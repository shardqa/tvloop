# 🔧 YouTube Troubleshooting

## YouTube Videos Not Loading
**Symptoms**: Channel switches but video doesn't play

**Solutions**:
1. **Check YouTube URL format**:
   - Verify playlist.txt has correct YouTube video IDs
   - Format should be: `youtube://VIDEO_ID|Title|Duration`

2. **Test YouTube access**:
   ```bash
   # Test if YouTube is accessible
   curl -I "https://www.youtube.com"
   ```

3. **Check MPV YouTube support**:
   ```bash
   mpv --version | grep ytdl
   # Should show ytdl support
   ```

## YouTube API Issues
```bash
# Test yt-dlp functionality
yt-dlp --version
yt-dlp --extract-audio --audio-format mp3 "https://www.youtube.com/watch?v=VIDEO_ID"
```

## Common YouTube Errors

### "HTTP 403 Forbidden"
- YouTube blocked the request
- Try different video quality: `--ytdl-format="best[height<=480]"`
- Update yt-dlp: `pip install --upgrade yt-dlp`

### "No video or audio streams selected"
- Video format not available
- Use fallback format: `--ytdl-format="best"`

### "Sign in to confirm your age"
- Age-restricted video
- Use different video or channel content

## Network Testing
```bash
# Test YouTube connectivity
curl -I "https://www.youtube.com/watch?v=VIDEO_ID"

# Test DNS resolution
nslookup youtube.com

# Test firewall
sudo ufw status
```

## YouTube Format Options
```bash
# List available formats
yt-dlp -F "https://www.youtube.com/watch?v=VIDEO_ID"

# Use specific format in MPV
mpv --ytdl-format="140+298" "https://www.youtube.com/watch?v=VIDEO_ID"
```

## Performance Optimization
```bash
# Limit video quality for faster playback
mpv --ytdl-format="best[height<=720]" video_url

# Use audio-only for testing
mpv --ytdl-format="bestaudio" video_url

# Skip video download for testing
mpv --no-video video_url
```

## Update Dependencies
```bash
# Update yt-dlp
pip install --upgrade yt-dlp

# Update MPV
sudo apt update && sudo apt upgrade mpv

# Check versions
yt-dlp --version
mpv --version
```
