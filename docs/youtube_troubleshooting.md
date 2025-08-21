# 🎬 YouTube Channel Troubleshooting

## API Version Issues

### YouTube API Key Issues
```bash
# Check if API key is set
echo $YOUTUBE_API_KEY

# Test API connection
curl "https://www.googleapis.com/youtube/v3/search?part=snippet&q=test&key=$YOUTUBE_API_KEY"
```

### API Key Problems
- **Invalid key**: Verify the key is correct
- **API not enabled**: Enable YouTube Data API v3
- **Quota exceeded**: Check usage in Google Cloud Console
- **Permission denied**: Check API key permissions

### API Quota Exceeded
- YouTube Data API has daily quotas
- Check your quota usage in Google Cloud Console
- Consider upgrading your API plan

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

## Common Issues

### Channel Not Found
- Verify the channel URL/username is correct
- Check if the channel is public
- Try using the channel ID instead of username

### No Videos Found
- Check if the channel has uploaded videos
- Verify API key has proper permissions (API version)
- Verify yt-dlp is working correctly (yt-dlp version)
- Check API quota limits (API version)

### Playlist Too Short
- The channel might not have enough videos
- Try increasing the `max_videos` parameter
- Some videos might be skipped due to duration issues

### Rate Limiting
- YouTube may throttle requests if too many are made
- Wait a few minutes and try again
- Consider using fewer videos or longer intervals

## Performance Issues

- **API version**: Check network connectivity
- **yt-dlp version**: Each video requires individual lookup
- Monitor system resources during processing
- Consider using shorter target durations

## Error Messages

- **"Video file not found"**: Normal for YouTube URLs
- **"Could not get video info"**: Video might be private/unavailable
- **"API error"**: Check API key validity and quota usage

## Getting Help

```bash
# View recent logs
tail -f logs/channel_activity.log

# Test API connection
curl "https://www.googleapis.com/youtube/v3/search?part=snippet&q=test&key=$YOUTUBE_API_KEY"

# Test yt-dlp
yt-dlp --dump-json --no-playlist "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Check required tools
which jq curl ffmpeg yt-dlp
```

## Prevention Tips

- Monitor quotas regularly (API version)
- Keep yt-dlp updated (yt-dlp version)

---

**Need help?** See setup guides.
