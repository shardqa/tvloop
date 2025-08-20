# YouTube Troubleshooting Guide

This guide helps you resolve common issues with YouTube integration in tvloop.

## API Key Issues

### Problem: API key not working
**Solutions:**
- Make sure your API key is correct
- Check that YouTube Data API v3 is enabled
- Verify your API key has the necessary permissions
- Ensure the API key is set as environment variable: `YOUTUBE_API_KEY`

### Problem: API quota exceeded
**Solutions:**
- Check your usage in Google Cloud Console
- Wait for quota reset (daily)
- Consider requesting quota increase
- Monitor API usage to avoid future issues

## yt-dlp Issues

### Problem: yt-dlp not found
**Solutions:**
- Install yt-dlp: `pip install yt-dlp`
- Update yt-dlp: `pip install --upgrade yt-dlp`
- Check if yt-dlp is in your PATH

### Problem: Video not accessible
**Solutions:**
- Check if YouTube is accessible from your network
- Some videos may be region-restricted
- Try a different video to test
- Check if the video is age-restricted or private

### Problem: Slow video loading
**Solutions:**
- Check your internet connection
- Try a different video quality setting
- Consider using a different player (mpv vs VLC)

## Player Issues

### Problem: mpv/VLC not found
**Solutions:**
- Install the required player:
  ```bash
  sudo apt install mpv  # Ubuntu/Debian
  brew install mpv      # macOS
  ```
- Make sure the player is in your PATH
- Try a different player type

### Problem: Video won't play
**Solutions:**
- Check that the video player supports the video format
- Try a different player (mpv vs VLC)
- Check if the video file exists (for local videos)
- Verify the video URL is accessible

## Common Error Messages

### "YouTube API key not configured"
- Set the `YOUTUBE_API_KEY` environment variable
- Restart your terminal after setting the variable

### "Video not found or access denied"
- The video may be private, deleted, or region-restricted
- Check the video URL manually
- Try a different video

### "yt-dlp not found"
- Install yt-dlp: `pip install yt-dlp`
- Make sure it's in your PATH

### "Player not found"
- Install the required video player (mpv or VLC)
- Check that the player is accessible

## See Also

- [YouTube Advanced Troubleshooting](youtube_advanced_troubleshooting.md) - More complex issues
- [YouTube Setup Guide](youtube_setup.md) - Initial setup
- [YouTube Usage Guide](youtube_usage.md) - How to use YouTube features
- [YouTube Format Reference](youtube_format.md) - Playlist format details
- [YouTube Examples](youtube_examples.md) - Practical examples
