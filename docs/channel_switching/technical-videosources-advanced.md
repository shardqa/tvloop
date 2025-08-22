# 🔧 Advanced Video Source Extensions

## Overview

Advanced video source extensions provide support for complex protocols, specialized formats, and advanced features beyond basic YouTube and local file support.

## Extension Categories

### [Protocol Extensions](technical-protocols.md)
- Custom protocol handlers
- Advanced protocol support (SFTP, WebDAV, FTP)
- Torrent streaming support
- Protocol configuration examples

### [Video Format Extensions](technical-formats.md)
- Video format conversion
- Subtitle format handling
- Audio format configuration
- Format-specific loading options

## Quick Examples

### Custom Protocol Usage
```bash
# Use custom protocols in playlists
echo "custom://video1|Custom Video|1800" > channels/custom/playlist.txt
```

### Advanced Protocol Usage
```bash
# Use advanced protocols
echo "sftp://server/videos/movie.mkv|Remote Movie|7200" > channels/remote/playlist.txt
```

### Format-Specific Configuration
```lua
-- Basic format detection
local function get_video_format(video_path)
    if video_path:match("%.mkv$") then return "matroska"
    elseif video_path:match("%.mp4$") then return "mp4"
    else return "unknown" end
end
```

## See Also
- [Basic Video Sources](technical-videosources-basic.md) - Common video source extensions
- [Streaming Extensions](technical-videosources-streaming.md) - Adaptive streaming and monitoring
- [Protocol Extensions](technical-protocols.md) - Custom protocol handlers
- [Format Extensions](technical-formats.md) - Video format handling
