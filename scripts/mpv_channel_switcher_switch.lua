-- MPV Channel Switcher Switch Module
-- Handles channel switching operations

local mp = require 'mp'
local msg = require 'mp.msg'

-- Switch to a specific channel
local function switch_to_channel(channel_index, available_channels, calculate_channel_position, current_channel)
    if channel_index < 1 or channel_index > #available_channels then
        mp.osd_message("Channel " .. channel_index .. " not available", 2)
        return current_channel
    end
    
    local channel = available_channels[channel_index]
    local position = calculate_channel_position(channel.path)
    
    if not position then
        mp.osd_message("Failed to calculate position for channel: " .. channel.name, 2)
        return current_channel
    end
    
    -- Construct YouTube URL
    local youtube_url = "https://www.youtube.com/watch?v=" .. position.video_id
    
    -- Store target position for later seeking
    mp.set_property("user-data/target-position", tostring(math.floor(position.position)))
    
    -- Load the video without immediate seeking
    mp.commandv("loadfile", youtube_url, "replace")
    
    local new_current_channel = channel.name
    mp.osd_message("Switched to " .. channel.name .. ": " .. position.title .. " (target: " .. math.floor(position.position) .. "s)", 3)
    
    msg.info("Switched to channel: " .. channel.name .. " (video: " .. position.video_id .. " at " .. position.position .. "s)")
    
    return new_current_channel
end

-- Register script message handler for channel switching
local function register_script_message(switch_to_channel, available_channels, calculate_channel_position, current_channel)
    mp.register_script_message("switch-channel", function(channel_index_str)
        local channel_index = tonumber(channel_index_str)
        if channel_index then
            current_channel = switch_to_channel(channel_index, available_channels, calculate_channel_position, current_channel)
        else
            mp.osd_message("Invalid channel index: " .. (channel_index_str or "nil"), 2)
        end
    end)
end

-- Add key bindings for channel switching
local function setup_key_bindings(available_channels, switch_to_channel, current_channel)
    for i = 1, 9 do -- Support up to 9 channels
        if i <= #available_channels then
            mp.add_key_binding(tostring(i), "switch-to-channel-" .. i, function()
                current_channel = switch_to_channel(i, available_channels, calculate_channel_position, current_channel)
            end)
        end
    end
    
    -- Add info key binding
    mp.add_key_binding("i", "show-channel-info", function()
        local info = "Current channel: " .. (current_channel or "none") .. "\n"
        info = info .. "Available channels:\n"
        for i, channel in ipairs(available_channels) do
            info = info .. i .. ": " .. channel.name .. "\n"
        end
        mp.osd_message(info, 5)
    end)
end

return {
    switch_to_channel = switch_to_channel,
    register_script_message = register_script_message,
    setup_key_bindings = setup_key_bindings
}
