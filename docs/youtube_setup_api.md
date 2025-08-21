# 🎬 YouTube API Setup Guide

## YouTube Data API Setup

### 1. Get API Key

1. **Go to Google Cloud Console**: [https://console.cloud.google.com/apis/credentials](https://console.cloud.google.com/apis/credentials)
2. **Create a new project** or select existing
3. **Enable YouTube Data API v3**:
   - Go to "APIs & Services" > "Library"
   - Search for "YouTube Data API v3"
   - Click "Enable"
4. **Create credentials**:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "API Key"
   - Copy your API key

### 2. Set Environment Variable

```bash
export YOUTUBE_API_KEY='your_api_key_here'
```

### 3. Permanent Setup (Optional)

Add to your shell profile for permanent setup:
```bash
echo 'export YOUTUBE_API_KEY="your_api_key_here"' >> ~/.bashrc
source ~/.bashrc
```

## Required Tools

Install these tools if not already available:

### Ubuntu/Debian
```bash
sudo apt install jq curl ffmpeg
```

### CentOS/RHEL
```bash
sudo yum install jq curl ffmpeg
```

### macOS
```bash
brew install jq curl ffmpeg
```

## API Quota Management

YouTube Data API has quotas:
- **Free tier**: 10,000 units/day
- **Paid tier**: Higher limits available

### Quota Usage per Operation
- Search: 100 units
- Channel info: 1 unit
- Video details: 1 unit
- Playlist items: 1 unit

### Tips to Minimize Quota Usage
- Use longer target durations (fewer API calls)
- Cache results when possible
- Monitor quota usage in Google Cloud Console

## Testing Your Setup

### Check API Key
```bash
echo $YOUTUBE_API_KEY
```

### Test API Connection
```bash
curl "https://www.googleapis.com/youtube/v3/search?part=snippet&q=test&key=$YOUTUBE_API_KEY"
```

## Troubleshooting

### API Key Issues
- **Invalid key**: Verify the key is correct
- **API not enabled**: Enable YouTube Data API v3
- **Quota exceeded**: Check usage in Google Cloud Console

### Common Problems
- **Permission denied**: Check API key permissions
- **Rate limiting**: Implement exponential backoff
- **API changes**: Check for breaking changes

## Next Steps

Once setup is complete, see `youtube_quick_start_api.md` to create your first channel!

---

**Need help?** See `youtube_troubleshooting.md` for more detailed troubleshooting.
