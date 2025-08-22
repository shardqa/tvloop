-- MPV Channel Switcher Script for tvloop
-- Allows switching between channels using hotkeys (1, 2, 3, etc.)
-- Each channel starts at its calculated time position

local mp = require 'mp'
local msg = require 'mp.msg'

-- Import modules
local core = require 'mpv_channel_switcher_core'
local position = require 'mpv_channel_switcher_position'
local switch = require 'mpv_channel_switcher_switch'

-- Initialize core functionality
core.initialize()

-- Set up channel switching
switch.register_script_message(
    switch.switch_to_channel, 
    core.available_channels, 
    function(channel_dir) 
        return position.calculate_channel_position(
            channel_dir, 
            core.parse_playlist, 
            core.parse_channel_state, 
            core.get_current_timestamp
        )
    end,
    core.current_channel
)

-- Set up key bindings
switch.setup_key_bindings(
    core.available_channels,
    switch.switch_to_channel,
    core.current_channel
)

msg.info("MPV Channel Switcher loaded successfully")
