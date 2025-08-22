-- MPV Channel Switcher Script for tvloop (Refactored)
-- Allows switching between channels using hotkeys (1, 2, 3, etc.)
-- Each channel starts at its calculated time position

local mp = require 'mp'
local msg = require 'mp.msg'

-- Load modules
local script_dir = debug.getinfo(1).source:match("@?(.*/)") or ""
local channel_discovery = dofile(script_dir .. "mpv_channel_discovery.lua")
local playlist_parser = dofile(script_dir .. "mpv_playlist_parser.lua")
local position_calculator = dofile(script_dir .. "mpv_position_calculator.lua")
local event_handlers = dofile(script_dir .. "mpv_event_handlers.lua")
local key_bindings = dofile(script_dir .. "mpv_key_bindings.lua")

-- Configuration
local channels_dir = os.getenv("TVLOOP_CHANNELS_DIR") or "channels"
local current_channel = nil
local available_channels = {}

-- Switch to a specific channel with error handling
local function switch_to_channel(channel_index)
    if channel_index < 1 or channel_index > #available_channels then
        mp.osd_message("Channel " .. channel_index .. " not available", 2)
        return
    end
    
    local channel = available_channels[channel_index]
    msg.info("Switching to channel: " .. channel.name)
    
    local position = position_calculator.calculate_channel_position(channel.path, 0, playlist_parser)
    
    if not position then
        mp.osd_message("Failed to calculate position for channel: " .. channel.name, 2)
        msg.error("Failed to calculate position for channel: " .. channel.name)
        return
    end
    
    msg.info("Calculated position: video=" .. position.video_id .. ", title=" .. position.title .. ", pos=" .. position.position)
    
    -- Store channel info for error handling
    local channel_info = {
        video_id = position.video_id,
        title = position.title,
        position = position.position,
        channel_name = channel.name,
        channel_path = channel.path
    }
    
    event_handlers.set_current_channel_info(channel_info)
    
    -- Construct YouTube URL
    local youtube_url = "https://www.youtube.com/watch?v=" .. position.video_id
    msg.info("Loading URL: " .. youtube_url)
    
    -- Load the video
    mp.commandv("loadfile", youtube_url, "replace")
end

-- Get current channel name
local function get_current_channel()
    local channel_info = event_handlers.get_current_channel_info()
    return channel_info and channel_info.channel_name or nil
end

-- Initialize available channels
local function initialize()
    available_channels = channel_discovery.discover_channels()
    msg.info("Discovered " .. #available_channels .. " channels for switching")
    
    -- Show available channels in OSD
    key_bindings.show_available_channels(available_channels)
end

-- Initialize when script loads
initialize()

-- Register event handlers
event_handlers.register_event_handlers(position_calculator, playlist_parser)

-- Setup key bindings
key_bindings.setup_all_key_bindings(available_channels, switch_to_channel, get_current_channel)

msg.info("MPV Channel Switcher loaded successfully")
