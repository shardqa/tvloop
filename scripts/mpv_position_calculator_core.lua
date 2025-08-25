-- Core Position Calculator Module for MPV Channel Switcher
-- Handles main position calculation logic

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

-- Export core functions
return {
    get_current_timestamp = get_current_timestamp,
    calculate_channel_position = calculate_channel_position
}
