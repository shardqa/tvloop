-- Position Calculator Module for MPV Channel Switcher
-- Main module that sources all position calculator sub-modules

local mp = require 'mp'
local msg = require 'mp.msg'

-- Source position calculator sub-modules
local core = require 'scripts.mpv_position_calculator_core'
local time_calc = require 'scripts.mpv_position_calculator_time'

-- Export all functions from sub-modules
return {
    get_current_timestamp = core.get_current_timestamp,
    calculate_channel_position = core.calculate_channel_position,
    calculate_time_until_next = time_calc.calculate_time_until_next,
    calculate_time_since_start = time_calc.calculate_time_since_start,
    format_time = time_calc.format_time
}
