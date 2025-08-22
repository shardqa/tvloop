# 🔧 Stream Health Monitoring

## Stream Health Monitoring
```lua
-- Monitor stream health and auto-switch on failure
local function monitor_stream_health()
    local current_time = mp.get_property_number("time-pos", 0)
    local duration = mp.get_property_number("duration", 0)
    
    -- If stream is stuck, try to recover
    if current_time > 0 and duration > 0 then
        local progress = current_time / duration
        if progress < 0.1 and current_time > 30 then
            -- Stream might be stuck, try reloading
            mp.command("seek 0")
        end
    end
end

-- Register health monitoring
mp.add_periodic_timer(10, monitor_stream_health)
```

## Connection Quality Monitoring
```lua
-- Monitor connection quality and adjust accordingly
local function check_connection_quality()
    local dropped_frames = mp.get_property_number("frame-drop-count", 0)
    local total_frames = mp.get_property_number("estimated-frame-count", 1)
    
    if total_frames > 100 then
        local drop_ratio = dropped_frames / total_frames
        
        if drop_ratio > 0.1 then  -- More than 10% dropped frames
            -- Consider lowering quality
            mp.osd_message("Poor connection detected - consider lowering quality", 3)
            return "poor"
        elseif drop_ratio > 0.05 then  -- More than 5% dropped frames
            return "fair"
        else
            return "good"
        end
    end
    
    return "unknown"
end
```

## Basic Health Monitoring
```lua
-- Simple health check
local function basic_health_check()
    local pos = mp.get_property_number("time-pos", 0)
    local duration = mp.get_property_number("duration", 0)
    
    if pos and duration and pos > 0 then
        return true
    end
    return false
end
```

## Usage Examples

### Enable Basic Monitoring
```lua
-- In mpv_channel_switcher.lua, add:
mp.add_periodic_timer(10, monitor_stream_health)
mp.add_periodic_timer(30, check_connection_quality)
```

### Simple Statistics
```bash
# Add basic stats key binding
echo "s script-binding show-basic-stats" >> config/mpv_input.conf
```

## See Also
- [Stream Quality](technical-streaming-quality.md) - Quality management
- [Stream Authentication](technical-streaming-auth.md) - Authentication methods
