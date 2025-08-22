# 🔧 Protocol Extensions

## Custom Protocol Support
```lua
-- Add custom protocol handlers
local protocol_handlers = {
    ["custom://"] = function(url)
        -- Handle custom protocol
        return "http://custom-server.com/" .. url:match("custom://(.+)")
    end,
    ["local://"] = function(url)
        -- Handle local file protocol
        return "/home/user/videos/" .. url:match("local://(.+)")
    end
}

local function handle_custom_protocol(video_path)
    for protocol, handler in pairs(protocol_handlers) do
        if video_path:match("^" .. protocol) then
            return handler(video_path)
        end
    end
    return video_path
end
```

## Advanced Protocol Handlers
```lua
-- Support for complex protocol schemes
local advanced_handlers = {
    ["sftp://"] = function(url)
        -- Handle SFTP protocol
        local path = url:match("sftp://([^/]+)/(.+)")
        return "ssh://" .. path
    end,
    ["webdav://"] = function(url)
        -- Handle WebDAV protocol
        local path = url:match("webdav://([^/]+)/(.+)")
        return "https://" .. path
    end,
    ["ftp://"] = function(url)
        -- Handle FTP protocol
        return url:gsub("^ftp://", "http://")
    end
}
```

## Torrent Stream Support
```lua
-- Support for torrent streaming
local function is_torrent_file(video_path)
    return video_path:match("%.torrent$") or video_path:match("^magnet:")
end

local function handle_torrent_stream(video_path)
    if is_torrent_file(video_path) then
        -- Use torrent streaming with appropriate player
        return "torrent://" .. video_path
    end
    return video_path
end
```

## Usage Examples

### Custom Protocol
```bash
# Create playlist with custom protocols
echo "custom://video1|Custom Video 1|1800" > channels/custom/playlist.txt
echo "local://movie1.mp4|Local Movie 1|3600" >> channels/custom/playlist.txt
```

### Advanced Protocols
```bash
# Create playlist with advanced protocols
echo "sftp://server/videos/movie1.mkv|SFTP Movie 1|7200" > channels/remote/playlist.txt
echo "webdav://server/videos/movie2.mp4|WebDAV Movie 2|5400" >> channels/remote/playlist.txt
```

### Torrent Streaming
```bash
# Create playlist with torrent files
echo "magnet:?xt=urn:btih:...|Torrent Movie 1|7200" > channels/torrents/playlist.txt
echo "/path/to/movie.torrent|Torrent Movie 2|5400" >> channels/torrents/playlist.txt
```
