# 🔧 Bandwidth and Fallback Management

## Quality Fallback System
```lua
-- Implement quality fallback for failed streams
local function try_quality_fallback(stream_url)
    local quality_levels = {"1080p", "720p", "480p", "360p"}
    
    for _, quality in ipairs(quality_levels) do
        local test_url = stream_url:gsub("quality=[^&]*", "quality=" .. quality)
        if test_stream_availability(test_url) then
            return test_url, quality
        end
    end
    
    return stream_url, "original"
end
```

## Bandwidth Detection
```lua
-- Estimate available bandwidth
local function estimate_bandwidth()
    local test_url = "http://speedtest.example.com/1mb.bin"
    local start_time = os.time()
    
    local handle = io.popen("curl -o /dev/null -s -w '%{speed_download}' " .. test_url)
    if handle then
        local speed = handle:read("*a")
        handle:close()
        return tonumber(speed) or 0
    end
    
    return 0
end

local function select_quality_by_bandwidth(stream_url, bandwidth)
    if bandwidth > 5000000 then  -- 5 Mbps
        return stream_url:gsub("quality=auto", "quality=1080")
    elseif bandwidth > 2500000 then  -- 2.5 Mbps
        return stream_url:gsub("quality=auto", "quality=720")
    else
        return stream_url:gsub("quality=auto", "quality=480")
    end
end
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

## Usage Examples

### Bandwidth-Based Quality
```lua
-- Auto-select quality based on bandwidth
local bandwidth = estimate_bandwidth()
local optimized_url = select_quality_by_bandwidth(stream_url, bandwidth)
mp.commandv("loadfile", optimized_url, "replace")
```

### Quality Fallback
```lua
-- Try different qualities if stream fails
local url, quality = try_quality_fallback(original_stream_url)
mp.osd_message("Using " .. quality .. " quality due to fallback", 3)
```

## See Also
- [Adaptive Streaming](technical-streaming-adaptive.md) - Adaptive streaming features
- [Stream Quality Management](technical-streaming-quality.md) - Quality management overview
