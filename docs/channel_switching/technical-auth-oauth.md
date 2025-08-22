# 🔧 OAuth and Advanced Authentication

## OAuth Authentication
```lua
-- Support for OAuth-based authentication
local function get_oauth_token(client_id, client_secret)
    local auth_command = string.format(
        "curl -X POST -d 'client_id=%s&client_secret=%s&grant_type=client_credentials' %s",
        client_id, client_secret, "https://auth.example.com/token"
    )
    
    local handle = io.popen(auth_command)
    if handle then
        local response = handle:read("*a")
        handle:close()
        
        -- Parse JSON response for token
        local token = response:match('"access_token":"([^"]+)"')
        return token
    end
    return nil
end
```

## Header-Based Authentication
```lua
-- Add custom headers for authentication
local function load_stream_with_headers(stream_url, headers)
    local header_args = {}
    for key, value in pairs(headers) do
        table.insert(header_args, "--http-header-fields=" .. key .. ": " .. value)
    end
    
    -- Use MPV with custom headers
    mp.command_native({
        "loadfile", stream_url, "replace",
        options = header_args
    })
end
```

## JWT Token Handling
```lua
-- Handle JWT tokens for authentication
local function get_jwt_token(username, password)
    local auth_data = string.format('{"username":"%s","password":"%s"}', username, password)
    local auth_command = string.format(
        "curl -X POST -H 'Content-Type: application/json' -d '%s' https://api.example.com/auth",
        auth_data
    )
    
    local handle = io.popen(auth_command)
    if handle then
        local response = handle:read("*a")
        handle:close()
        
        local token = response:match('"token":"([^"]+)"')
        return token
    end
    return nil
end
```

## Usage Examples

### OAuth Flow
```lua
-- Get OAuth token and use for streaming
local token = get_oauth_token("client_id", "client_secret")
if token then
    local auth_url = stream_url .. "?access_token=" .. token
    mp.commandv("loadfile", auth_url, "replace")
end
```

### Header Authentication
```bash
# Create playlist requiring custom headers
echo "https://secure.stream.com/video1|Secure Stream 1|0" > channels/secure/playlist.txt
# Note: Headers need to be configured in the script
```

## See Also
- [Stream Authentication](technical-streaming-auth.md) - Basic authentication
- [Stream Quality](technical-streaming-quality.md) - Quality management
