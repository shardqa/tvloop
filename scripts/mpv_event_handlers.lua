-- Event Handlers Module for MPV Channel Switcher
-- Handles MPV event handling and error recovery

local mp = require 'mp'
local msg = require 'mp.msg'

-- Global variables for error handling
local current_channel_info = nil
local retry_count = 0
local max_retries = 3

-- Global event handlers
local function on_file_loaded()
    if current_channel_info then
        msg.info("Video loaded successfully: " .. current_channel_info.video_id)
        
        -- Get video duration and seek to target position
        local duration = mp.get_property_number("duration", 0)
        local target_pos = current_channel_info.position
        
        if duration > 0 then
            -- Ensure position is within bounds
            local seek_pos = math.min(target_pos, duration - 10)
            mp.commandv("seek", seek_pos)
            mp.osd_message("Switched to " .. current_channel_info.channel_name .. ": " .. current_channel_info.title .. " at " .. seek_pos .. "s", 3)
            msg.info("Seeked to position: " .. seek_pos .. "s (duration: " .. duration .. "s)")
        else
            mp.osd_message("Switched to " .. current_channel_info.channel_name .. ": " .. current_channel_info.title, 3)
            msg.warn("No duration available, cannot seek")
        end
        
        -- Store the target position for manual seeking
        mp.set_property("user-data/target-position", tostring(target_pos))
        
        -- Reset retry count on success
        retry_count = 0
        current_channel_info = nil
    end
end

local function on_load_fail(position_calculator, playlist_parser)
    if current_channel_info then
        retry_count = retry_count + 1
        msg.error("Failed to load video: " .. current_channel_info.video_id .. " (attempt " .. retry_count .. ")")
        
        if retry_count <= max_retries then
            mp.osd_message("Failed to load video, trying next one... (attempt " .. retry_count .. ")", 3)
            
            -- Try to load the next video in the playlist
            local next_position = position_calculator.calculate_channel_position(current_channel_info.channel_path, retry_count, playlist_parser)
            if next_position then
                local next_url = "https://www.youtube.com/watch?v=" .. next_position.video_id
                msg.info("Trying next video: " .. next_position.video_id)
                
                -- Update current channel info for the next attempt
                current_channel_info.video_id = next_position.video_id
                current_channel_info.title = next_position.title
                current_channel_info.position = next_position.position
                
                mp.commandv("loadfile", next_url, "replace")
            else
                mp.osd_message("No more videos available in this channel", 3)
                retry_count = 0
                current_channel_info = nil
            end
        else
            mp.osd_message("Failed to load any videos in this channel after " .. max_retries .. " attempts", 3)
            retry_count = 0
            current_channel_info = nil
        end
    end
end

-- Handle idle mode
local function on_idle()
    msg.info("MPV entered idle mode - ready for channel switching")
    mp.osd_message("Ready for channel switching. Press 1-9 to switch channels.", 5)
end

-- Handle shutdown
local function on_shutdown()
    msg.info("MPV shutting down")
end

-- Handle log messages for error detection
local function on_log_message(event)
    if event.level == "error" and event.text:find("Failed to recognize file format") then
        msg.warn("Detected file format error, will retry with next video")
    end
end

-- Set current channel info for event handlers
local function set_current_channel_info(channel_info)
    current_channel_info = channel_info
    retry_count = 0
end

-- Get current channel info
local function get_current_channel_info()
    return current_channel_info
end

-- Reset error handling state
local function reset_error_state()
    retry_count = 0
    current_channel_info = nil
end

-- Register all event handlers
local function register_event_handlers(position_calculator, playlist_parser)
    mp.register_event("file-loaded", on_file_loaded)
    mp.register_event("end-file", function(event)
        if event.reason == "error" or event.reason == "eof" then
            on_load_fail(position_calculator, playlist_parser)
        end
    end)
    mp.register_event("idle", on_idle)
    mp.register_event("shutdown", on_shutdown)
    mp.register_event("log-message", on_log_message)
    
    msg.info("Event handlers registered successfully")
end

-- Export functions
return {
    set_current_channel_info = set_current_channel_info,
    get_current_channel_info = get_current_channel_info,
    reset_error_state = reset_error_state,
    register_event_handlers = register_event_handlers
}
