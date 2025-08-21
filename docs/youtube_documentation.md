# 🎬 YouTube Integration Documentation

## Overview

The tvloop project offers **two complete solutions** for creating YouTube-based TV channels:

1. **API Version** - Uses YouTube Data API v3 (professional, fast)
2. **yt-dlp Version** - Uses yt-dlp for direct YouTube access (simple, free)

## Quick Start Guides

### API Version
- **Quick Start**: [youtube_quick_start_api.md](youtube_quick_start_api.md)
- **Setup Guide**: [youtube_setup_api.md](youtube_setup_api.md)

### yt-dlp Version
- **Quick Start**: [youtube_quick_start_ytdlp.md](youtube_quick_start_ytdlp.md)
- **Setup Guide**: [youtube_setup_ytdlp.md](youtube_setup_ytdlp.md)

## Comparison & Advanced Usage

- **Feature Comparison**: [youtube_comparison.md](youtube_comparison.md)
- **Advanced Usage**: [youtube_advanced_usage.md](youtube_advanced_usage.md)
- **Troubleshooting**: [youtube_troubleshooting.md](youtube_troubleshooting.md)

## Quick Examples

### API Version (Requires API Key)
```bash
# Setup
export YOUTUBE_API_KEY='your_api_key_here'

# Create channel
./scripts/create_youtube_channel.sh jovem_nerd https://www.youtube.com/@JovemNerd
```

### yt-dlp Version (No API Key)
```bash
# Setup
sudo apt install yt-dlp

# Create channel
./scripts/create_youtube_channel_ytdlp.sh jovem_nerd https://www.youtube.com/@JovemNerd
```

## Which Version Should You Choose?

### Choose API Version When:
- ✅ Production environment with high reliability needs
- ✅ Large channels with many videos
- ✅ Frequent updates and playlist refreshes
- ✅ Rich metadata requirements

### Choose yt-dlp Version When:
- ✅ Quick setup without API configuration
- ✅ Personal use or testing
- ✅ Small to medium channels
- ✅ Zero cost solution needed

## Getting Started

1. **Choose your version** (API or yt-dlp)
2. **Follow the setup guide** for your chosen version
3. **Use the quick start guide** to create your first channel
4. **Check advanced usage** for more features
5. **Use troubleshooting** if you encounter issues

## Channel Management

Both versions use the same channel management commands:

```bash
# Start playing
./scripts/channel_player.sh channels/your_channel_name tune mpv

# Stop playing
./scripts/channel_player.sh channels/your_channel_name stop

# Check status
./scripts/channel_tracker.sh channels/your_channel_name status

# View playlist info
./scripts/playlist_manager.sh channels/your_channel_name/playlist.txt info
```

## Features

- 🔄 **Continuous Loop**: Videos play in sequence and loop forever
- ⏯️ **Resume Position**: Continues from where it left off
- 📊 **Status Tracking**: Know what's playing and for how long
- 🎮 **Multiple Players**: Support for mpv and VLC
- 📺 **YouTube Integration**: Automatically fetches videos
- ⏱️ **24-Hour Programming**: Creates full-day schedules
- 🔀 **Smart Duration**: Builds playlist to match target duration

---

**Ready to create your YouTube-based TV channel?** Choose your preferred method and start streaming! 🎬📺
