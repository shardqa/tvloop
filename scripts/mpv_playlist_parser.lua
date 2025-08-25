-- Playlist Parser Module for MPV Channel Switcher
-- Main module that sources parsing functionality

local mp = require 'mp'
local msg = require 'mp.msg'

-- Import modules
local parse_module = require 'scripts.mpv_playlist_parser_parse'
local validation_module = require 'scripts.mpv_playlist_parser_validation'

-- Export functions from modules
return {
    parse_playlist = parse_module.parse_playlist,
    parse_channel_state = parse_module.parse_channel_state,
    validate_playlist_format = validation_module.validate_playlist_format,
    get_playlist_summary = validation_module.get_playlist_summary
}
