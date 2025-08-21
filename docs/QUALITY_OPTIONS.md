# Quality Options for YouTube Channels

This guide shows the correct yt-dlp format IDs for different video qualities.

## Quick Reference

| Quality | Format IDs | Description |
|---------|------------|-------------|
| **360p** | `230,605` | Fastest, best for testing |
| **480p** | `231,606` | Fast, good balance |
| **720p** | `232,609` | Balanced, default |
| **1080p** | `270,614,616` | High quality, slower |

## Usage Examples

```bash
# Create 360p channel (fastest)
./scripts/create_youtube_channel_ytdlp.sh test_360p https://www.youtube.com/@JovemNerd 1 false "230,605"

# Create 480p channel (fast)
./scripts/create_youtube_channel_ytdlp.sh test_480p https://www.youtube.com/@JovemNerd 1 false "231,606"

# Create 720p channel (default)
./scripts/create_youtube_channel_ytdlp.sh test_720p https://www.youtube.com/@JovemNerd 1 false "232,609"

# Create 1080p channel (high quality)
./scripts/create_youtube_channel_ytdlp.sh test_1080p https://www.youtube.com/@JovemNerd 1 false "270,614,616"
```

## How to Find Format IDs

To find available formats for any YouTube video:

```bash
yt-dlp --list-formats "https://www.youtube.com/watch?v=VIDEO_ID"
```

## Notes

- Multiple format IDs (like `230,605`) allow yt-dlp to choose the best available
- Lower resolutions load faster and use less bandwidth
- Higher resolutions provide better quality but take longer to load
- For testing, use 360p or 480p for faster iteration
