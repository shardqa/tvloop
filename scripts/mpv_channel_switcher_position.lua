-- MPV Channel Switcher Position Module
-- Handles position calculation for channels

local mp = require 'mp'
local msg = require 'mp.msg'

-- Calculate current video and position for a channel
local function calculate_channel_position(channel_dir, parse_playlist, parse_channel_state, get_current_timestamp)
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
    
    local video_position = total_elapsed - video_start_time
    local current_video = playlist[current_video_index]
    
    return {
        video_id = current_video.id,
        title = current_video.title,
        position = video_position,
        duration = current_video.duration
    }
end

-- Format time for display
local function format_time(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%d:%02d", minutes, secs)
    end
end

-- Get channel info for display
local function get_channel_info(channel_name, position)
    if not position then
        return "Channel: " .. channel_name .. " (unavailable)"
    end
    
    local time_str = format_time(position.position)
    local duration_str = format_time(position.duration)
    
    return string.format("Channel: %s\nVideo: %s\nTime: %s / %s", 
        channel_name, position.title, time_str, duration_str)
end

return {
    calculate_channel_position = calculate_channel_position,
    format_time = format_time,
    get_channel_info = get_channel_info
}
