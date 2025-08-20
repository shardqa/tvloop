# YouTube Playlist Format Reference

This document describes the playlist format used for YouTube videos in tvloop.

## Format Overview

YouTube playlists use a special format to distinguish them from local video files:

```
youtube://VIDEO_ID|Video Title|Duration in seconds
```

## Format Components

1. **Protocol**: `youtube://` - Identifies this as a YouTube video
2. **Video ID**: YouTube's unique video identifier
3. **Title**: Human-readable video title
4. **Duration**: Video length in seconds

## Examples

```
youtube://dQw4w9WgXcQ|Rick Astley - Never Gonna Give You Up|212
youtube://9bZkp7q19f0|PSY - GANGNAM STYLE|252
youtube://jNQXAC9IVRw|Me at the zoo|19
```

## Mixed Playlists

You can mix YouTube and local videos in the same playlist:

```
youtube://dQw4w9WgXcQ|Rick Astley - Never Gonna Give You Up|212
/path/to/local/video.mp4|Local Video Title|120
youtube://9bZkp7q19f0|PSY - GANGNAM STYLE|252
```

## URL Formats Supported

The system can extract video IDs from various YouTube URL formats:

- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `https://www.youtube.com/embed/VIDEO_ID`

## Playlist URLs

For playlists, the system extracts the playlist ID from:

- `https://www.youtube.com/playlist?list=PLAYLIST_ID`
- `https://www.youtube.com/watch?v=VIDEO_ID&list=PLAYLIST_ID`

## See Also

- [YouTube Setup Guide](youtube_setup.md) - Initial setup
- [YouTube Usage Guide](youtube_usage.md) - How to use YouTube features
- [YouTube Examples](youtube_examples.md) - Practical examples
