-- Event Registration Module for MPV Channel Switcher
-- Handles event registration and utility functions

local mp = require 'mp'
local msg = require 'mp.msg'

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

-- Register all event handlers
local function register_event_handlers(position_calculator, playlist_parser)
    -- Import core functions
    local core = require 'scripts.mpv_event_handlers_core'
    local on_file_loaded = core.on_file_loaded
    local on_load_fail = core.on_load_fail
    
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

-- Export registration functions
return {
    register_event_handlers = register_event_handlers
}
