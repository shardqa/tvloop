# 🔧 Basic Video Source Extensions

## Local Video Support
```lua
-- Extend to support local video files
local function is_local_video(video_path)
    return not video_path:match("^youtube://")
end

local function get_video_url(video_path)
    if is_local_video(video_path) then
        return video_path
    else
        local video_id = video_path:match("youtube://(.+)")
        return "https://www.youtube.com/watch?v=" .. video_id
    end
end
```

## Network Stream Support
```lua
-- Add support for network streams
local function is_network_stream(video_path)
    return video_path:match("^https?://") or video_path:match("^rtmp://")
end
```

## IPTV Stream Support
```lua
-- Support for IPTV M3U playlists
local function parse_m3u_playlist(playlist_file)
    local streams = {}
    local file = io.open(playlist_file, "r")
    if file then
        for line in file:lines() do
            if line:match("^http") then
                table.insert(streams, line)
            end
        end
        file:close()
    end
    return streams
end
```

## Multi-Source Support
```lua
-- Support multiple video sources in one channel
local function get_video_source(video_path)
    if video_path:match("^youtube://") then
        return "youtube"
    elseif video_path:match("^http") then
        return "stream"
    elseif video_path:match("^/") then
        return "local"
    else
        return "unknown"
    end
end

local function load_video_with_source(video_path)
    local source = get_video_source(video_path)
    local url = get_video_url(video_path)
    
    if source == "youtube" then
        mp.commandv("loadfile", url, "replace")
    elseif source == "stream" then
        mp.commandv("loadfile", url, "replace")
    elseif source == "local" then
        mp.commandv("loadfile", url, "replace")
    end
end
```

## Usage Examples

### Local Video Channel
```bash
# Create playlist with local videos
echo "/home/user/videos/movie1.mp4|Movie 1|7200" > channels/local_movies/playlist.txt
echo "/home/user/videos/movie2.mp4|Movie 2|5400" >> channels/local_movies/playlist.txt
```

### Network Stream Channel
```bash
# Create playlist with network streams
echo "http://stream.example.com/live1|Live Stream 1|0" > channels/live_tv/playlist.txt
echo "rtmp://stream.example.com/live2|Live Stream 2|0" >> channels/live_tv/playlist.txt
```

### Mixed Source Channel
```bash
# Mix YouTube and local videos
echo "youtube://VIDEO_ID1|YouTube Video 1|1800" > channels/mixed/playlist.txt
echo "/home/user/videos/local1.mp4|Local Video 1|3600" >> channels/mixed/playlist.txt
echo "youtube://VIDEO_ID2|YouTube Video 2|2400" >> channels/mixed/playlist.txt
```
