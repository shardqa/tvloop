# 🎬 YouTube Channel Quick Start (API Version)

## Create a 24-hour TV channel from any YouTube channel!

```bash
./scripts/create_youtube_channel.sh <channel_name> <youtube_channel> [target_hours] [auto_start]
```

## Examples

### Create JovemNerd Channel
```bash
./scripts/create_youtube_channel.sh jovem_nerd https://www.youtube.com/@JovemNerd
```

### Create 12-Hour Tech Channel
```bash
./scripts/create_youtube_channel.sh tech_channel @JovemNerd 12
```

### Create 48-Hour Gaming Channel and Start Playing
```bash
./scripts/create_youtube_channel.sh gaming_channel UC1234567890 48 true
```

## YouTube Channel Formats

- **Channel URL**: `https://www.youtube.com/@JovemNerd`
- **Username**: `@JovemNerd`
- **Channel ID**: `UC1234567890`

## Setup Required

1. **Get YouTube API Key** from [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. **Set environment variable**:
   ```bash
   export YOUTUBE_API_KEY='your_api_key_here'
   ```

## What Happens Automatically

1. ✅ Creates channel directory
2. ✅ Fetches videos from YouTube channel
3. ✅ Creates 24-hour playlist
4. ✅ Extracts metadata (duration, title)
5. ✅ Initializes channel with timing
6. ✅ Starts playing (if auto_start=true)

## Basic Commands

### Start Playing
```bash
./scripts/channel_player.sh channels/your_channel_name tune mpv
```

### Stop Playing
```bash
./scripts/channel_player.sh channels/your_channel_name stop
```

### Check Status
```bash
./scripts/channel_tracker.sh channels/your_channel_name status
```

### View Playlist Info
```bash
./scripts/playlist_manager.sh channels/your_channel_name/playlist.txt info
```

### Refresh Playlist
```bash
./scripts/create_youtube_channel.sh your_channel_name @JovemNerd 24
```

## Channel Features

- 🔄 **Continuous Loop**: Videos play in sequence and loop forever
- ⏯️ **Resume Position**: Continues from where it left off
- 📊 **Status Tracking**: Know what's playing and for how long
- 🎮 **Player Support**: Support for mpv
- 📺 **YouTube Integration**: Automatically fetches videos
- ⏱️ **24-Hour Programming**: Creates full-day schedules
- 🔀 **Smart Duration**: Builds playlist to match target duration

---

**Ready to create your YouTube-based TV channel?** See `youtube_setup_api.md` for detailed setup instructions!
