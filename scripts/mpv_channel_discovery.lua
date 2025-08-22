-- Channel Discovery Module for MPV Channel Switcher
-- Handles channel discovery and management

local mp = require 'mp'
local msg = require 'mp.msg'

-- Configuration
local channels_dir = os.getenv("TVLOOP_CHANNELS_DIR") or "channels"

-- Discover available channels
local function discover_channels()
    local channels = {}
    local handle = io.popen("find " .. channels_dir .. " -maxdepth 1 -type d -name '*' | grep -v '^" .. channels_dir .. "$' | sort")
    if handle then
        for line in handle:lines() do
            local channel_name = line:match("([^/]+)$")
            if channel_name then
                table.insert(channels, {
                    name = channel_name,
                    path = line
                })
            end
        end
        handle:close()
    end
    return channels
end

-- Validate channel directory
local function validate_channel(channel_path)
    local state_file = channel_path .. "/state.json"
    local playlist_file = channel_path .. "/playlist.txt"
    
    -- Check if both required files exist
    local state_exists = io.open(state_file, "r") ~= nil
    local playlist_exists = io.open(playlist_file, "r") ~= nil
    
    return state_exists and playlist_exists
end

-- Get channel info
local function get_channel_info(channel_path)
    local channel_name = channel_path:match("([^/]+)$")
    local state_file = channel_path .. "/state.json"
    local playlist_file = channel_path .. "/playlist.txt"
    
    return {
        name = channel_name,
        path = channel_path,
        state_file = state_file,
        playlist_file = playlist_file,
        valid = validate_channel(channel_path)
    }
end

-- List available channels with status
local function list_channels()
    local channels = discover_channels()
    local valid_channels = {}
    
    for _, channel in ipairs(channels) do
        local info = get_channel_info(channel.path)
        if info.valid then
            table.insert(valid_channels, info)
        else
            msg.warn("Channel " .. info.name .. " is invalid (missing required files)")
        end
    end
    
    return valid_channels
end

-- Export functions
return {
    discover_channels = discover_channels,
    validate_channel = validate_channel,
    get_channel_info = get_channel_info,
    list_channels = list_channels
}
