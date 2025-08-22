# 🔧 Streaming Video Extensions

## Overview

Streaming video extensions provide advanced support for live streams, adaptive bitrate content, authentication, and health monitoring for continuous playback.

## Streaming Categories

### [Stream Quality Management](technical-streaming-quality.md)
- Adaptive bitrate streaming (HLS/DASH)
- Dynamic stream resolution
- Quality fallback systems
- Bandwidth detection and adaptation

### [Stream Authentication](technical-streaming-auth.md)
- Token-based authentication
- OAuth authentication
- API key authentication
- Header-based authentication

### [Stream Health Monitoring](technical-streaming-monitoring.md)
- Connection quality monitoring
- Automatic recovery systems
- Stream statistics display
- Network latency detection

## Quick Examples

### Basic Adaptive Stream
```lua
-- Detect adaptive streams
local function is_adaptive_stream(video_path)
    return video_path:match("%.m3u8$") or video_path:match("%.mpd$")
end
```

### Simple Authentication
```lua
-- Add token to stream URL
local function add_auth_token(stream_url, token)
    return stream_url .. "?token=" .. token
end
```

### Basic Health Check
```lua
-- Monitor stream position
local function check_stream_health()
    local pos = mp.get_property_number("time-pos", 0)
    return pos > 0
end
```

## Usage Examples

### Adaptive Streams
```bash
# Create adaptive stream playlist
echo "https://stream.example.com/playlist.m3u8|Adaptive Stream|0" > channels/adaptive/playlist.txt
```

### Authenticated Streams
```bash
# Create authenticated stream playlist
echo "https://stream.example.com/live?token=SECRET|Auth Stream|0" > channels/auth/playlist.txt
```

## See Also
- [Basic Video Sources](technical-videosources-basic.md) - Common video sources
- [Advanced Video Sources](technical-videosources-advanced.md) - Complex protocols
- [Stream Quality](technical-streaming-quality.md) - Quality management
- [Stream Authentication](technical-streaming-auth.md) - Authentication methods
- [Stream Monitoring](technical-streaming-monitoring.md) - Health monitoring
