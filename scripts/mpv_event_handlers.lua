-- Event Handlers Module for MPV Channel Switcher
-- Main module that sources event handling sub-modules

local mp = require 'mp'
local msg = require 'mp.msg'

-- Source event handler sub-modules
local core = require 'scripts.mpv_event_handlers_core'
local register = require 'scripts.mpv_event_handlers_register'

-- Export all functions from sub-modules
return {
    set_current_channel_info = core.set_current_channel_info,
    get_current_channel_info = core.get_current_channel_info,
    reset_error_state = core.reset_error_state,
    register_event_handlers = register.register_event_handlers
}
