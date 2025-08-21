# 🎬 YouTube Channel Quick Start (yt-dlp Version)

## Create a 24-hour TV channel - No API Key Required!

```bash
./scripts/create_youtube_channel_ytdlp.sh <channel_name> <youtube_channel> [target_hours] [auto_start]
```

## Examples

### Create JovemNerd Channel (No API Key!)
```bash
./scripts/create_youtube_channel_ytdlp.sh jovem_nerd https://www.youtube.com/@JovemNerd
```

### Create 12-Hour Tech Channel
```bash
./scripts/create_youtube_channel_ytdlp.sh tech_channel @JovemNerd 12
```

### Create 48-Hour Gaming Channel and Start Playing
```bash
./scripts/create_youtube_channel_ytdlp.sh gaming_channel UC1234567890 48 true
```

## YouTube Channel Formats

- **Channel URL**: `https://www.youtube.com/@JovemNerd`
- **Username**: `@JovemNerd`
- **Channel ID**: `UC1234567890`

## Setup Required

Just install yt-dlp:
```bash
sudo apt install yt-dlp
```

## What Happens Automatically

1. ✅ Creates channel directory
2. ✅ Fetches videos from YouTube channel using yt-dlp
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
./scripts/create_youtube_channel_ytdlp.sh your_channel_name @JovemNerd 24
```

## Channel Features

- 🔄 **Continuous Loop**: Videos play in sequence and loop forever
- ⏯️ **Resume Position**: Continues from where it left off
- 📊 **Status Tracking**: Know what's playing and for how long
- 🎮 **Multiple Players**: Support for mpv and VLC
- 📺 **YouTube Integration**: Automatically fetches videos
- ⏱️ **24-Hour Programming**: Creates full-day schedules
- 🔀 **Smart Duration**: Builds playlist to match target duration
- 🔧 **No API Key**: Works without any API setup

---

**Ready to create your YouTube-based TV channel?** See `youtube_setup_ytdlp.md` for detailed setup instructions!
