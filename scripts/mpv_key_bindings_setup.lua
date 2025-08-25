-- Key Bindings Setup Module for MPV Channel Switcher
-- Handles key binding orchestration and utility functions

local mp = require 'mp'
local msg = require 'mp.msg'

-- Register script message handler for channel switching
local function setup_script_message_handler(switch_to_channel_func)
    mp.register_script_message("switch-channel", function(channel_index_str)
        local channel_index = tonumber(channel_index_str)
        if channel_index then
            switch_to_channel_func(channel_index)
        else
            mp.osd_message("Invalid channel index: " .. (channel_index_str or "nil"), 2)
        end
    end)
end

-- Setup all key bindings
local function setup_all_key_bindings(available_channels, switch_to_channel_func, current_channel_func)
    -- Import core functions
    local core = require 'scripts.mpv_key_bindings_core'
    
    core.setup_channel_key_bindings(available_channels, switch_to_channel_func)
    core.setup_info_key_binding(available_channels, current_channel_func)
    core.setup_test_key_binding()
    core.setup_seek_key_binding()
    core.setup_position_info_key_binding()
    setup_script_message_handler(switch_to_channel_func)
    
    msg.info("Key bindings setup complete")
end

-- Show available channels in OSD
local function show_available_channels(available_channels)
    local channel_list = "Available channels:\n"
    for i, channel in ipairs(available_channels) do
        channel_list = channel_list .. i .. ": " .. channel.name .. "\n"
    end
    mp.osd_message(channel_list, 5)
end

-- Export setup functions
return {
    setup_all_key_bindings = setup_all_key_bindings,
    setup_script_message_handler = setup_script_message_handler,
    show_available_channels = show_available_channels
}
