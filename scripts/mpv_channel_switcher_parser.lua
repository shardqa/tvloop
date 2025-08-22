-- MPV Channel Switcher Parser Module
-- Handles parsing of playlist and state files

local mp = require 'mp'
local msg = require 'mp.msg'

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

return {
    parse_playlist = parse_playlist,
    parse_channel_state = parse_channel_state
}
