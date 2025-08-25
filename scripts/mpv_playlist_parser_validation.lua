-- Playlist Parser Validation Module for MPV Channel Switcher
-- Handles playlist validation and summary logic

local mp = require 'mp'
local msg = require 'mp.msg'

-- Import parse module
local parse_module = require 'scripts.mpv_playlist_parser_parse'

-- Validate playlist format
local function validate_playlist_format(playlist_file)
    local file = io.open(playlist_file, "r")
    if not file then
        return false, "Could not open playlist file"
    end
    
    local line_count = 0
    local valid_lines = 0
    
    for line in file:lines() do
        line_count = line_count + 1
        line = line:match("^%s*(.-)%s*$") -- trim whitespace
        
        if line and line ~= "" and not line:match("^#") then
            local video_id, title, duration = line:match("youtube://([^|]+)|([^|]+)|(%d+)")
            if video_id and title and duration then
                valid_lines = valid_lines + 1
            else
                msg.warn("Invalid playlist line " .. line_count .. ": " .. line)
            end
        end
    end
    file:close()
    
    if valid_lines == 0 then
        return false, "No valid video entries found"
    end
    
    return true, "Valid playlist with " .. valid_lines .. " videos"
end

-- Get playlist summary
local function get_playlist_summary(playlist_file)
    local entries = parse_module.parse_playlist(playlist_file)
    local total_duration = 0
    local video_count = #entries
    
    for _, entry in ipairs(entries) do
        total_duration = total_duration + entry.duration
    end
    
    return {
        video_count = video_count,
        total_duration = total_duration,
        entries = entries
    }
end

return {
    validate_playlist_format = validate_playlist_format,
    get_playlist_summary = get_playlist_summary
}
