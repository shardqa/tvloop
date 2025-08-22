# 🔧 Adaptive Streaming

## Adaptive Bitrate Streaming
```lua
-- Support for adaptive bitrate streams (HLS/DASH)
local function is_adaptive_stream(video_path)
    return video_path:match("%.m3u8$") or video_path:match("%.mpd$")
end

local function handle_adaptive_stream(video_path)
    if is_adaptive_stream(video_path) then
        -- Use MPV's built-in HLS/DASH support
        mp.commandv("loadfile", video_path, "replace")
        mp.set_property("ytdl", "no")  -- Disable yt-dlp for HLS/DASH
    end
end
```

## Dynamic Stream Resolution
```lua
-- Automatically select best available stream quality
local function get_best_stream_quality(stream_url)
    local qualities = {
        "1080p" = stream_url:gsub("quality=auto", "quality=1080"),
        "720p" = stream_url:gsub("quality=auto", "quality=720"),
        "480p" = stream_url:gsub("quality=auto", "quality=480")
    }
    
    -- Try highest quality first
    for quality, url in pairs(qualities) do
        if test_stream_availability(url) then
            return url, quality
        end
    end
    
    return stream_url, "auto"
end

local function test_stream_availability(url)
    -- Simple availability test
    local handle = io.popen("curl -I " .. url .. " 2>/dev/null | head -1")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result:match("200")
    end
    return false
end
```

## Usage Examples

### Adaptive Streams
```bash
# Create playlist with adaptive streams
echo "https://stream.example.com/playlist.m3u8|Adaptive Stream 1|0" > channels/adaptive/playlist.txt
echo "https://stream.example.com/manifest.mpd|Adaptive Stream 2|0" >> channels/adaptive/playlist.txt
```

### Quality Selection
```bash
# Create playlist with quality options
echo "https://stream.example.com/auto|Auto Quality|0" > channels/quality/playlist.txt
echo "https://stream.example.com/720p|720p Quality|0" >> channels/quality/playlist.txt
echo "https://stream.example.com/1080p|1080p Quality|0" >> channels/quality/playlist.txt
```

## See Also
- [Stream Quality Management](technical-streaming-quality.md) - Quality management overview
- [Stream Authentication](technical-streaming-auth.md) - Authentication methods
