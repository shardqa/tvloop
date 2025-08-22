# 🔧 Stream Recovery and Statistics

## Overview

Stream recovery and statistics provide automatic recovery systems, performance monitoring, and alert mechanisms for maintaining optimal stream playback.

## Recovery and Statistics Categories

### [Stream Statistics](technical-monitoring-stats.md)
- Stream statistics collection
- Performance metrics tracking
- Network latency detection
- Alert systems

## Automatic Recovery
```lua
-- Implement automatic recovery for failed streams
local last_position = 0
local stall_count = 0

local function auto_recovery_monitor()
    local current_pos = mp.get_property_number("time-pos", 0)
    
    if current_pos == last_position then
        stall_count = stall_count + 1
        
        if stall_count > 3 then  -- Stalled for 30 seconds
            mp.osd_message("Stream stalled - attempting recovery", 2)
            mp.command("seek +1")  -- Try to unstick
            stall_count = 0
        end
    else
        stall_count = 0
    end
    
    last_position = current_pos
end

-- Register recovery monitoring
mp.add_periodic_timer(10, auto_recovery_monitor)
```

## Usage Examples

### Enable Recovery
```lua
-- In mpv_channel_switcher.lua, add:
mp.add_periodic_timer(10, auto_recovery_monitor)
```

### Basic Recovery Check
```lua
-- Simple recovery check
local function basic_recovery_check()
    local pos = mp.get_property_number("time-pos", 0)
    return pos > 0
end
```

## See Also
- [Stream Monitoring](technical-streaming-monitoring.md) - Basic health monitoring
- [Stream Quality](technical-streaming-quality.md) - Quality management
