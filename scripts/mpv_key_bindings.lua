-- Key Bindings Module for MPV Channel Switcher
-- Main module that sources key binding sub-modules

local mp = require 'mp'
local msg = require 'mp.msg'

-- Source key binding sub-modules
local core = require 'scripts.mpv_key_bindings_core'
local setup = require 'scripts.mpv_key_bindings_setup'

-- Export all functions from sub-modules
return {
    setup_all_key_bindings = setup.setup_all_key_bindings,
    setup_channel_key_bindings = core.setup_channel_key_bindings,
    setup_info_key_binding = core.setup_info_key_binding,
    setup_test_key_binding = core.setup_test_key_binding,
    setup_seek_key_binding = core.setup_seek_key_binding,
    setup_position_info_key_binding = core.setup_position_info_key_binding,
    setup_script_message_handler = setup.setup_script_message_handler,
    show_available_channels = setup.show_available_channels
}
