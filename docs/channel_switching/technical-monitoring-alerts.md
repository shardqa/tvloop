# 🔧 Stream Alerts and Advanced Monitoring

## Alert System
```lua
-- Set up alerts for stream issues
local function alert_stream_issue(issue_type, message)
    -- Log to file
    local log_file = io.open("/tmp/stream_alerts.log", "a")
    if log_file then
        log_file:write(os.date() .. " - " .. issue_type .. ": " .. message .. "\n")
        log_file:close()
    end
    
    -- Show OSD message
    mp.osd_message("ALERT: " .. message, 5)
end
```

## Network Latency Detection
```lua
-- Detect network latency issues
local function detect_latency_issues()
    local cache_time = mp.get_property_number("demuxer-cache-duration", 0)
    local cache_state = mp.get_property("cache-buffering-state", "unknown")
    
    if cache_state == "yes" and cache_time < 2 then
        mp.osd_message("High latency detected - buffering", 2)
        return true
    end
    
    return false
end
```

## Advanced Monitoring
```lua
-- Monitor multiple stream parameters
local function advanced_stream_monitor()
    local metrics = {
        latency = detect_latency_issues(),
        dropped = mp.get_property_number("frame-drop-count", 0),
        cache = mp.get_property_number("cache-used", 0)
    }
    
    -- Alert if issues detected
    if metrics.latency then
        alert_stream_issue("LATENCY", "High network latency detected")
    end
    
    if metrics.dropped > 10 then
        alert_stream_issue("QUALITY", "Frame drops detected: " .. metrics.dropped)
    end
end
```

## Usage Examples

### Enable Alerts
```lua
-- In mpv_channel_switcher.lua, add:
mp.add_periodic_timer(15, advanced_stream_monitor)
```

### Custom Alert Handling
```lua
-- Custom alert handler
local function handle_custom_alert(type, message)
    alert_stream_issue(type, message)
    
    -- Additional custom actions
    if type == "CRITICAL" then
        mp.command("quit")
    end
end
```

## See Also
- [Stream Statistics](technical-monitoring-stats.md) - Basic statistics
- [Stream Monitoring](technical-streaming-monitoring.md) - Health monitoring
