# 🔧 Stream Statistics and Performance

## Stream Statistics
```lua
-- Collect and display stream statistics
local function show_stream_stats()
    local stats = {
        fps = mp.get_property_number("estimated-vf-fps", 0),
        bitrate = mp.get_property_number("video-bitrate", 0),
        dropped = mp.get_property_number("frame-drop-count", 0),
        cache = mp.get_property_number("cache-used", 0)
    }
    
    local stats_text = string.format(
        "FPS: %.1f | Bitrate: %.0f kbps | Dropped: %d | Cache: %.1f MB",
        stats.fps, stats.bitrate/1000, stats.dropped, stats.cache/(1024*1024)
    )
    
    mp.osd_message(stats_text, 5)
end

-- Add key binding to show stats
mp.add_key_binding("s", "show-stream-stats", show_stream_stats)
```

## Performance Metrics
```lua
-- Track performance metrics
local metrics = {
    total_stalls = 0,
    recovery_attempts = 0,
    successful_recoveries = 0,
    average_bitrate = 0,
    dropped_frames_total = 0
}

local function update_metrics()
    metrics.dropped_frames_total = mp.get_property_number("frame-drop-count", 0)
    metrics.average_bitrate = mp.get_property_number("video-bitrate", 0)
end

local function show_performance_report()
    local report = string.format(
        "Performance Report:\nStalls: %d | Recoveries: %d/%d | Avg Bitrate: %.0f kbps | Dropped: %d",
        metrics.total_stalls,
        metrics.successful_recoveries,
        metrics.recovery_attempts,
        metrics.average_bitrate/1000,
        metrics.dropped_frames_total
    )
    
    mp.osd_message(report, 10)
end
```

## Usage Examples

### Enable Statistics
```lua
-- In mpv_channel_switcher.lua, add:
mp.add_periodic_timer(30, update_metrics)
mp.add_key_binding("r", "show-performance-report", show_performance_report)
```

### Statistics Display
```bash
# Press 's' to show stream statistics
# Press 'r' to show performance report
```

## See Also
- [Stream Recovery](technical-monitoring-recovery.md) - Recovery systems
- [Stream Alerts](technical-monitoring-alerts.md) - Alerts and advanced monitoring
