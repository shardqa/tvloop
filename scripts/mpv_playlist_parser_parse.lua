-- Playlist Parser Parse Module for MPV Channel Switcher
-- Handles playlist and state file parsing logic

local mp = require 'mp'
local msg = require 'mp.msg'

-- Parse playlist file and return video entries
local function parse_playlist(playlist_file)
    local entries = {}
    local file = io.open(playlist_file, "r")
    if not file then
        msg.warn("Could not open playlist file: " .. playlist_file)
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
            else
                msg.warn("Could not parse playlist line: " .. line)
            end
        end
    end
    file:close()
    
    msg.info("Parsed " .. #entries .. " videos from playlist: " .. playlist_file)
    return entries
end

-- Parse channel state file
local function parse_channel_state(state_file)
    local file = io.open(state_file, "r")
    if not file then
        msg.warn("Could not open state file: " .. state_file)
        return nil
    end
    
    local content = file:read("*all")
    file:close()
    
    -- Simple JSON parsing for our specific format
    local start_time = content:match('"start_time":%s*(%d+)')
    local total_duration = content:match('"total_duration":%s*(%d+)')
    local playlist_file = content:match('"playlist_file":%s*"([^"]+)"')
    
    if start_time and total_duration and playlist_file then
        local state = {
            start_time = tonumber(start_time),
            total_duration = tonumber(total_duration),
            playlist_file = playlist_file
        }
        msg.info("Parsed state file: start_time=" .. state.start_time .. ", total_duration=" .. state.total_duration)
        return state
    else
        msg.error("Invalid state file format: " .. state_file)
        return nil
    end
end

return {
    parse_playlist = parse_playlist,
    parse_channel_state = parse_channel_state
}
