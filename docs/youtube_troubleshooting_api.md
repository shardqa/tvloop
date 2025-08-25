# 🎬 YouTube API Troubleshooting

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

## API Version Common Issues

### Channel Not Found
- Verify the channel URL/username is correct
- Check if the channel is public
- Try using the channel ID instead of username

### No Videos Found
- Check if the channel has uploaded videos
- Verify API key has proper permissions
- Check API quota limits

### Rate Limiting
- YouTube may throttle requests if too many are made
- Wait a few minutes and try again
- Consider using fewer videos or longer intervals

## API Version Performance Issues

- Check network connectivity
- Monitor system resources during processing
- Consider using shorter target durations

## API Version Error Messages

- **"API error"**: Check API key validity and quota usage

## API Version Getting Help

```bash
# Test API connection
curl "https://www.googleapis.com/youtube/v3/search?part=snippet&q=test&key=$YOUTUBE_API_KEY"

# Check required tools
which jq curl
```

## API Version Prevention Tips

- Monitor quotas regularly
