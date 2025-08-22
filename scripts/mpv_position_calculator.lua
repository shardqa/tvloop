-- Position Calculator Module for MPV Channel Switcher
-- Handles position calculation logic

local mp = require 'mp'
local msg = require 'mp.msg'

-- Utility function to get current timestamp
local function get_current_timestamp()
    return os.time()
end

-- Calculate current video and position for a channel
local function calculate_channel_position(channel_dir, offset, playlist_parser)
    offset = offset or 0
    
    local state_file = channel_dir .. "/state.json"
    local state = playlist_parser.parse_channel_state(state_file)
    if not state then
        msg.error("Failed to parse channel state: " .. state_file)
        return nil
    end
    
    local playlist = playlist_parser.parse_playlist(state.playlist_file)
    if #playlist == 0 then
        msg.error("Empty playlist: " .. state.playlist_file)
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
    
    local result = {
        video_id = current_video.id,
        title = current_video.title,
        position = video_position,
        duration = current_video.duration,
        video_index = target_video_index,
        total_videos = #playlist,
        elapsed_time = elapsed_time,
        total_elapsed = total_elapsed
    }
    
    msg.info("Calculated position: video=" .. result.video_id .. 
             ", title=" .. result.title .. 
             ", pos=" .. result.position .. 
             ", index=" .. result.video_index .. "/" .. result.total_videos)
    
    return result
end

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

-- Export functions
return {
    get_current_timestamp = get_current_timestamp,
    calculate_channel_position = calculate_channel_position,
    calculate_time_until_next = calculate_time_until_next,
    calculate_time_since_start = calculate_time_since_start,
    format_time = format_time
}
