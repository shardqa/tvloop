-- Time Calculation Module for MPV Channel Switcher
-- Handles time-related calculations and formatting

local mp = require 'mp'
local msg = require 'mp.msg'

-- Import core functions
local core = require 'scripts.mpv_position_calculator_core'
local get_current_timestamp = core.get_current_timestamp
local calculate_channel_position = core.calculate_channel_position

-- Calculate time until next video
local function calculate_time_until_next(channel_dir, playlist_parser)
    local position = calculate_channel_position(channel_dir, 0, playlist_parser)
    if not position then
        return nil
    end
    
    local time_in_current_video = position.position
    local time_remaining_in_video = position.duration - time_in_current_video
    
    return {
        time_remaining = time_remaining_in_video,
        next_video_id = position.video_id,
        next_video_title = position.title
    }
end

-- Calculate time since channel start
local function calculate_time_since_start(channel_dir, playlist_parser)
    local state_file = channel_dir .. "/state.json"
    local state = playlist_parser.parse_channel_state(state_file)
    if not state then
        return nil
    end
    
    local current_time = get_current_timestamp()
    local elapsed_time = current_time - state.start_time
    
    return {
        elapsed_time = elapsed_time,
        total_duration = state.total_duration,
        cycles_completed = math.floor(elapsed_time / state.total_duration),
        time_in_current_cycle = elapsed_time % state.total_duration
    }
end

-- Format time for display
local function format_time(seconds)
    if seconds < 60 then
        return string.format("%ds", seconds)
    elseif seconds < 3600 then
        local minutes = math.floor(seconds / 60)
        local secs = seconds % 60
        return string.format("%dm %ds", minutes, secs)
    else
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        return string.format("%dh %dm %ds", hours, minutes, secs)
    end
end

-- Export time functions
return {
    calculate_time_until_next = calculate_time_until_next,
    calculate_time_since_start = calculate_time_since_start,
    format_time = format_time
}
