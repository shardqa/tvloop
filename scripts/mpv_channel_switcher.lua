-- MPV Channel Switcher Script for tvloop
-- Allows switching between channels using hotkeys (1, 2, 3, etc.)
-- Each channel starts at its calculated time position

local mp = require 'mp'
local msg = require 'mp.msg'

-- Configuration
local channels_dir = os.getenv("TVLOOP_CHANNELS_DIR") or "channels"
local current_channel = nil
local available_channels = {}

-- Utility function to get current timestamp
local function get_current_timestamp()
    return os.time()
end

-- Parse playlist file and return video entries
local function parse_playlist(playlist_file)
    local entries = {}
    local file = io.open(playlist_file, "r")
    if not file then
        return entries
    end
    
    for line in file:lines() do
        line = line:match("^%s*(.-)%s*$") -- trim whitespace
        if line and line ~= "" and not line:match("^#") then
            local video_id, title, duration = line:match("youtube://([^|]+)|([^|]+)|(%d+)")
            if video_id then
                table.insert(entries, {
                    id = video_id,
                    title = title,
                    duration = tonumber(duration)
                })
            end
        end
    end
    file:close()
    return entries
end

-- Parse channel state file
local function parse_channel_state(state_file)
    local file = io.open(state_file, "r")
    if not file then
        return nil
    end
    
    local content = file:read("*all")
    file:close()
    
    -- Simple JSON parsing for our specific format
    local start_time = content:match('"start_time":%s*(%d+)')
    local total_duration = content:match('"total_duration":%s*(%d+)')
    local playlist_file = content:match('"playlist_file":%s*"([^"]+)"')
    
    if start_time and total_duration and playlist_file then
        return {
            start_time = tonumber(start_time),
            total_duration = tonumber(total_duration),
            playlist_file = playlist_file
        }
    end
    
    return nil
end

-- Calculate current video and position for a channel
local function calculate_channel_position(channel_dir, offset)
    offset = offset or 0
    local state_file = channel_dir .. "/state.json"
    local state = parse_channel_state(state_file)
    if not state then
        return nil
    end
    
    local playlist = parse_playlist(state.playlist_file)
    if #playlist == 0 then
        return nil
    end
    
    local current_time = get_current_timestamp()
    local elapsed_time = current_time - state.start_time
    
    -- Calculate which video should be playing and at what position
    local total_elapsed = elapsed_time % state.total_duration
    local current_video_index = 1
    local video_start_time = 0
    
    for i, video in ipairs(playlist) do
        if total_elapsed < video_start_time + video.duration then
            current_video_index = i
            break
        end
        video_start_time = video_start_time + video.duration
    end
    
    -- Apply offset to get next/previous video
    local target_video_index = current_video_index + offset
    
    -- Handle wrap-around
    if target_video_index > #playlist then
        target_video_index = 1
    elseif target_video_index < 1 then
        target_video_index = #playlist
    end
    
    local current_video = playlist[target_video_index]
    local video_position = 0 -- Start from beginning for offset videos
    
    -- For the current video (offset = 0), calculate the actual position
    if offset == 0 then
        video_position = total_elapsed - video_start_time
        -- Ensure position is within video bounds
        if video_position < 0 then
            video_position = 0
        elseif video_position >= current_video.duration then
            video_position = current_video.duration - 10 -- 10 seconds from end
        end
    end
    
    return {
        video_id = current_video.id,
        title = current_video.title,
        position = video_position,
        duration = current_video.duration
    }
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

-- Global variables for error handling
local current_channel_info = nil
local retry_count = 0
local max_retries = 3

-- Global event handlers
local function on_file_loaded()
    if current_channel_info then
        msg.info("Video loaded successfully: " .. current_channel_info.video_id)
        current_channel = current_channel_info.channel_name
        mp.osd_message("Switched to " .. current_channel_info.channel_name .. ": " .. current_channel_info.title, 3)
        
        -- Store the target position for manual seeking
        mp.set_property("user-data/target-position", tostring(current_channel_info.position))
        
        -- Reset retry count on success
        retry_count = 0
        current_channel_info = nil
    end
end

local function on_load_fail()
    if current_channel_info then
        retry_count = retry_count + 1
        msg.error("Failed to load video: " .. current_channel_info.video_id .. " (attempt " .. retry_count .. ")")
        
        if retry_count <= max_retries then
            mp.osd_message("Failed to load video, trying next one... (attempt " .. retry_count .. ")", 3)
            
            -- Try to load the next video in the playlist
            local next_position = calculate_channel_position(current_channel_info.channel_path, retry_count)
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

-- Register global event handlers
mp.register_event("file-loaded", on_file_loaded)
mp.register_event("end-file", function(event)
    if event.reason == "error" or event.reason == "eof" then
        on_load_fail()
    end
end)

-- Handle idle mode
mp.register_event("idle", function()
    msg.info("MPV entered idle mode - ready for channel switching")
    mp.osd_message("Ready for channel switching. Press 1-9 to switch channels.", 5)
end)

-- Prevent MPV from exiting on errors
mp.register_event("shutdown", function()
    msg.info("MPV shutting down")
end)

-- Add a hook to prevent exit on certain errors
mp.register_event("log-message", function(event)
    if event.level == "error" and event.text:find("Failed to recognize file format") then
        msg.warn("Detected file format error, will retry with next video")
    end
end)

-- Switch to a specific channel with error handling
local function switch_to_channel(channel_index)
    if channel_index < 1 or channel_index > #available_channels then
        mp.osd_message("Channel " .. channel_index .. " not available", 2)
        return
    end
    
    local channel = available_channels[channel_index]
    msg.info("Switching to channel: " .. channel.name)
    
    local position = calculate_channel_position(channel.path)
    
    if not position then
        mp.osd_message("Failed to calculate position for channel: " .. channel.name, 2)
        msg.error("Failed to calculate position for channel: " .. channel.name)
        return
    end
    
    msg.info("Calculated position: video=" .. position.video_id .. ", title=" .. position.title .. ", pos=" .. position.position)
    
    -- Store channel info for error handling
    current_channel_info = {
        video_id = position.video_id,
        title = position.title,
        position = position.position,
        channel_name = channel.name,
        channel_path = channel.path
    }
    
    -- Reset retry count
    retry_count = 0
    
    -- Construct YouTube URL
    local youtube_url = "https://www.youtube.com/watch?v=" .. position.video_id
    msg.info("Loading URL: " .. youtube_url)
    
    -- Load the video
mp.commandv("loadfile", youtube_url, "replace")

-- Add a manual seek key binding
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

-- Add a key to show current position info
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

-- Register script message handler for channel switching
mp.register_script_message("switch-channel", function(channel_index_str)
    local channel_index = tonumber(channel_index_str)
    if channel_index then
        switch_to_channel(channel_index)
    else
        mp.osd_message("Invalid channel index: " .. (channel_index_str or "nil"), 2)
    end
end)

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

-- Add key bindings for channel switching
local function setup_key_bindings()
    msg.info("Setting up key bindings for " .. #available_channels .. " channels")
    
    for i = 1, 9 do -- Support up to 9 channels
        if i <= #available_channels then
            msg.info("Adding key binding for channel " .. i .. ": " .. available_channels[i].name)
            mp.add_key_binding(tostring(i), "switch-to-channel-" .. i, function()
                msg.info("Key " .. i .. " pressed, switching to channel " .. i)
                switch_to_channel(i)
            end)
        end
    end
    
    -- Add info key binding
    msg.info("Adding info key binding")
    mp.add_key_binding("i", "show-channel-info", function()
        msg.info("Info key pressed")
        local info = "Current channel: " .. (current_channel or "none") .. "\n"
        info = info .. "Available channels:\n"
        for i, channel in ipairs(available_channels) do
            info = info .. i .. ": " .. channel.name .. "\n"
        end
        mp.osd_message(info, 5)
    end)
    
    -- Add a test key binding
    mp.add_key_binding("t", "test-key", function()
        msg.info("Test key pressed!")
        mp.osd_message("Test key works!", 3)
    end)
    
    msg.info("Key bindings setup complete")
end

-- Initialize when script loads
initialize()
setup_key_bindings()

msg.info("MPV Channel Switcher loaded successfully")
