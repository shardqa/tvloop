# 🔧 Video Format Extensions

## Video Format Conversion
```lua
-- Handle different video formats
local function get_video_format(video_path)
    if video_path:match("%.mkv$") then
        return "matroska"
    elseif video_path:match("%.mp4$") then
        return "mp4"
    elseif video_path:match("%.avi$") then
        return "avi"
    else
        return "unknown"
    end
end

local function handle_format_specific_loading(video_path)
    local format = get_video_format(video_path)
    
    if format == "matroska" then
        -- MKV specific options
        mp.set_property("sub-auto", "fuzzy")
    elseif format == "avi" then
        -- AVI specific options
        mp.set_property("sub-auto", "no")
    end
    
    mp.commandv("loadfile", video_path, "replace")
end
```

## Usage Examples

### Format-Specific Loading
```bash
# Create playlist with different formats
echo "/videos/movie1.mkv|MKV Movie|7200" > channels/mixed_formats/playlist.txt
echo "/videos/movie2.mp4|MP4 Movie|5400" >> channels/mixed_formats/playlist.txt
echo "/videos/movie3.avi|AVI Movie|6000" >> channels/mixed_formats/playlist.txt
```

### Basic Format Detection
```lua
-- Simple format-based configuration
local function setup_for_format(video_path)
    local format = get_video_format(video_path)
    
    if format == "matroska" then
        mp.set_property("sub-auto", "fuzzy")
    end
    
    handle_format_specific_loading(video_path)
end
```

## See Also
- [Subtitle and Audio](technical-formats-subtitles.md) - Subtitle and audio formats
- [Protocol Extensions](technical-protocols.md) - Custom protocol handlers
