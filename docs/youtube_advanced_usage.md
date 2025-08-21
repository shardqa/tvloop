# 🎬 YouTube Channel Advanced Usage

## Custom Duration Channels

Create channels with different durations:

```bash
# 6-hour morning channel
./scripts/create_youtube_channel.sh morning_news @CNN 6

# 12-hour workday channel
./scripts/create_youtube_channel.sh work_music @Spotify 12

# 48-hour weekend channel
./scripts/create_youtube_channel.sh weekend_movies @Netflix 48
```

## Multiple YouTube Channels

Create different channels from various YouTube sources:

```bash
# Tech news channel
./scripts/create_youtube_channel.sh tech_news @TechCrunch

# Gaming channel
./scripts/create_youtube_channel.sh gaming @IGN

# Educational channel
./scripts/create_youtube_channel.sh education @KhanAcademy

# Music channel
./scripts/create_youtube_channel.sh music @Spotify
```

## Channel Switching

Stop one channel and start another:

```bash
# Stop current channel
./scripts/channel_player.sh channels/tech_news stop

# Start different channel
./scripts/channel_player.sh channels/gaming tune mpv
```

## Integration with Local Media

Combine YouTube channels with local media:

```bash
# Create YouTube channel
./scripts/create_youtube_channel.sh youtube_news @CNN

# Create local media channel
./scripts/create_channel.sh local_movies /home/user/Videos

# Switch between them
./scripts/channel_player.sh channels/youtube_news stop
./scripts/channel_player.sh channels/local_movies tune mpv
```

## Best Practices

### Channel Selection
- Choose channels with regular uploads
- Prefer channels with longer videos for better 24-hour coverage
- Consider channels with consistent content themes

### Duration Planning
- 24 hours: Full day programming
- 12 hours: Half day (morning/afternoon)
- 6 hours: Short sessions
- 48+ hours: Extended programming

### Content Management
- Refresh playlists regularly for new content
- Monitor channel status for playback issues
- Keep multiple channels for variety

### Performance
- Use mpv for better performance
- Monitor system resources during playback
- Consider using SSD storage for better I/O

---

**Need help?** See `youtube_troubleshooting.md` for troubleshooting tips.
