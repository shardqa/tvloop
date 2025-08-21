# 🎬 YouTube Channel Migration Guide

## Migration Between API and yt-dlp Versions

### From API to yt-dlp
```bash
# Stop current channel
./scripts/channel_player.sh channels/jovem_nerd stop

# Create new channel with yt-dlp
./scripts/create_youtube_channel_ytdlp.sh jovem_nerd https://www.youtube.com/@JovemNerd

# Start new channel
./scripts/channel_player.sh channels/jovem_nerd tune mpv
```

### From yt-dlp to API
```bash
# Set up API key
export YOUTUBE_API_KEY='your_api_key_here'

# Stop current channel
./scripts/channel_player.sh channels/jovem_nerd stop

# Create new channel with API
./scripts/create_youtube_channel.sh jovem_nerd https://www.youtube.com/@JovemNerd

# Start new channel
./scripts/channel_player.sh channels/jovem_nerd tune mpv
```

## Why Migrate?

### API to yt-dlp Migration
- **No API quotas** - Unlimited usage
- **Simpler setup** - No API key management
- **Always available** - Works even if API is down
- **Zero cost** - Completely free

### yt-dlp to API Migration
- **Faster processing** - Bulk API calls
- **Better reliability** - Official Google API
- **Rich metadata** - Complete video information
- **Professional setup** - Better for production

## Migration Steps

1. **Stop the current channel** to avoid conflicts
2. **Create new channel** with the other method
3. **Verify playlist** is created correctly
4. **Start new channel** and test playback
5. **Remove old channel** if no longer needed

## Example: Complete JovemNerd Migration

```bash
# 1. Stop current channel
./scripts/channel_player.sh channels/jovem_nerd stop

# 2. Create new channel with yt-dlp
./scripts/create_youtube_channel_ytdlp.sh jovem_nerd https://www.youtube.com/@JovemNerd 24

# 3. Check the playlist
./scripts/playlist_manager.sh channels/jovem_nerd/playlist.txt info

# 4. Start playing
./scripts/channel_player.sh channels/jovem_nerd tune mpv

# 5. Check status
./scripts/channel_tracker.sh channels/jovem_nerd status
```

## Considerations

### Data Preservation
- Channel state and timing information will be reset
- Playlist content may differ slightly between versions
- Video order and selection may vary

### Performance Impact
- Migration requires recreating the entire playlist
- Processing time depends on channel size
- Network usage during playlist creation

### Compatibility
- Both versions use the same channel management commands
- Playlist format is compatible between versions
- Channel directory structure remains the same

---

**Need help?** See `youtube_troubleshooting.md` for migration issues.
