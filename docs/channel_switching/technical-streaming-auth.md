# 🔧 Stream Authentication

## Stream Authentication
```lua
-- Handle authenticated streams
local function get_authenticated_url(stream_url, credentials)
    if stream_url:match("^https://") then
        -- Add authentication headers
        local auth_url = stream_url .. "?token=" .. credentials.token
        return auth_url
    end
    return stream_url
end

local function load_authenticated_stream(stream_url, credentials)
    local auth_url = get_authenticated_url(stream_url, credentials)
    mp.commandv("loadfile", auth_url, "replace")
end
```

## API Key Authentication
```lua
-- Handle API key based authentication
local function add_api_key_to_url(stream_url, api_key)
    if stream_url:match("%?") then
        return stream_url .. "&api_key=" .. api_key
    else
        return stream_url .. "?api_key=" .. api_key
    end
end

local function load_api_authenticated_stream(stream_url, api_key)
    local auth_url = add_api_key_to_url(stream_url, api_key)
    mp.commandv("loadfile", auth_url, "replace")
end
```

## Usage Examples

### Token Authentication
```bash
# Create playlist with authenticated streams
echo "https://stream.example.com/live1?token=SECRET|Live Stream 1|0" > channels/auth/playlist.txt
echo "https://stream.example.com/live2?token=SECRET|Live Stream 2|0" >> channels/auth/playlist.txt
```

### API Key Streams
```bash
# Create playlist with API key authentication
echo "https://api.stream.com/video1?api_key=KEY123|API Stream 1|0" > channels/api_auth/playlist.txt
echo "https://api.stream.com/video2?api_key=KEY123|API Stream 2|0" >> channels/api_auth/playlist.txt
```

## See Also
- [OAuth Authentication](technical-auth-oauth.md) - OAuth and advanced auth
- [Stream Quality](technical-streaming-quality.md) - Quality management
