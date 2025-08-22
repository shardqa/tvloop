-- MPV Channel Switcher Core Module
-- Core functionality for channel switching

local mp = require 'mp'
local msg = require 'mp.msg'

-- Import parser module
local parser = require 'mpv_channel_switcher_parser'

-- Configuration
local channels_dir = os.getenv("TVLOOP_CHANNELS_DIR") or "channels"
local current_channel = nil
local available_channels = {}

-- Utility function to get current timestamp
local function get_current_timestamp()
    return os.time()
end

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

-- Initialize available channels
local function initialize()
    available_channels = discover_channels()
    msg.info("Discovered " .. #available_channels .. " channels for switching")
    
    -- Show available channels in OSD
    local channel_list = "Available channels:\n"
    for i, channel in ipairs(available_channels) do
        channel_list = channel_list .. i .. ": " .. channel.name .. "\n"
    end
    mp.osd_message(channel_list, 5)
end

-- Export functions and variables
return {
    get_current_timestamp = get_current_timestamp,
    parse_playlist = parser.parse_playlist,
    parse_channel_state = parser.parse_channel_state,
    discover_channels = discover_channels,
    initialize = initialize,
    channels_dir = channels_dir,
    current_channel = current_channel,
    available_channels = available_channels
}
