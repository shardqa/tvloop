-- Core Key Bindings Module for MPV Channel Switcher
-- Handles main key binding setup logic

local mp = require 'mp'
local msg = require 'mp.msg'

-- Add key bindings for channel switching
local function setup_channel_key_bindings(available_channels, switch_to_channel_func)
    msg.info("Setting up key bindings for " .. #available_channels .. " channels")
    
    for i = 1, 9 do -- Support up to 9 channels
        if i <= #available_channels then
            msg.info("Adding key binding for channel " .. i .. ": " .. available_channels[i].name)
            mp.add_key_binding(tostring(i), "switch-to-channel-" .. i, function()
                msg.info("Key " .. i .. " pressed, switching to channel " .. i)
                switch_to_channel_func(i)
            end)
        end
    end
end

-- Add info key binding
local function setup_info_key_binding(available_channels, current_channel_func)
    msg.info("Adding info key binding")
    mp.add_key_binding("i", "show-channel-info", function()
        msg.info("Info key pressed")
        local current_channel = current_channel_func()
        local info = "Current channel: " .. (current_channel or "none") .. "\n"
        info = info .. "Available channels:\n"
        for i, channel in ipairs(available_channels) do
            info = info .. i .. ": " .. channel.name .. "\n"
        end
        mp.osd_message(info, 5)
    end)
end

-- Add test key binding
local function setup_test_key_binding()
    mp.add_key_binding("t", "test-key", function()
        msg.info("Test key pressed!")
        mp.osd_message("Test key works!", 3)
    end)
end

-- Add manual seek key binding
local function setup_seek_key_binding()
    mp.add_key_binding("s", "seek-to-position", function()
        local target_pos = mp.get_property("user-data/target-position")
        if target_pos then
            local duration = mp.get_property_number("duration", 0)
            if duration > 0 then
                local seek_pos = math.min(tonumber(target_pos), duration - 10)
                mp.commandv("seek", seek_pos)
                mp.osd_message("Seeked to position: " .. seek_pos .. "s", 2)
            else
                mp.osd_message("No duration available for seeking", 2)
            end
        else
            mp.osd_message("No target position set", 2)
        end
    end)
end

-- Add position info key binding
local function setup_position_info_key_binding()
    mp.add_key_binding("p", "show-position-info", function()
        local current_pos = mp.get_property_number("time-pos", 0)
        local duration = mp.get_property_number("duration", 0)
        local target_pos = mp.get_property("user-data/target-position")
        
        local info = string.format("Current: %.1fs", current_pos)
        if duration > 0 then
            info = info .. string.format(" / %.1fs", duration)
        end
        if target_pos then
            info = info .. string.format("\nTarget: %ss", target_pos)
        end
        
        mp.osd_message(info, 3)
    end)
end

-- Export core functions
return {
    setup_channel_key_bindings = setup_channel_key_bindings,
    setup_info_key_binding = setup_info_key_binding,
    setup_test_key_binding = setup_test_key_binding,
    setup_seek_key_binding = setup_seek_key_binding,
    setup_position_info_key_binding = setup_position_info_key_binding
}
